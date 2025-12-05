// routes/family.js
import express from "express";
import UserInfo from "../models/UserInfo.js";
import Family from "../models/Family.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

/**
 * ===============================
 * 0) 내 가족 정보 조회
 * ===============================
 * GET /api/family/me
 */
router.get("/me", verifyToken, async (req, res) => {
  const userId = req.user.id;

  const user = await UserInfo.findById(userId);
  if (!user) return res.status(404).json({ msg: "UserNotFound" });

  // 가족 없음
  if (!user.family_code) {
    return res.json({
      family_code: null,
      members: [],
      pending: []
    });
  }

  const family = await Family.findOne({ family_code: user.family_code });
  if (!family) {
    user.family_code = null;
    await user.save();
    return res.json({
      family_code: null,
      members: [],
      pending: []
    });
  }

  const myPending = family.pending.filter((p) => p.to === userId);

  return res.json({
    family_code: family.family_code,
    members: family.members,
    pending: myPending
  });
});

/**
 * ===============================
 * 1) 가족 초대 보내기
 * ===============================
 * POST /api/family/invite
 */
router.post("/invite", verifyToken, async (req, res) => {
  const fromId = req.user.id;
  const { target_id } = req.body;

  const me = await UserInfo.findById(fromId);
  const target = await UserInfo.findById(target_id);

  if (!target) return res.status(404).json({ msg: "TargetNotFound" });

  // ★ 자기 자신 초대 방지
  if (target._id === fromId) {
    return res.status(400).json({ msg: "CannotInviteSelf" });
  }

  // 상대가 이미 가족이 있으면 초대 불가
  if (target.family_code) {
    return res.status(400).json({ msg: "TargetAlreadyHasFamily" });
  }

  let family;

  // 내가 가족 없음 → 새 가족 생성
  if (!me.family_code) {
    const newCode = "F" + Date.now();
    family = await Family.create({
      family_code: newCode,
      members: [{ user_id: me._id, name: me.name, phone: me.phone }],
      pending: []
    });

    me.family_code = newCode;
    await me.save();
  } else {
    family = await Family.findOne({ family_code: me.family_code });
  }

  // 초대 중복 방지
  const exists = family.pending.some(
    (p) => p.from === fromId && p.to === target_id
  );
  if (exists) {
    return res.status(400).json({ msg: "AlreadyInvited" });
  }

  family.pending.push({ from: fromId, to: target_id });
  await family.save();

  res.json({ msg: "invite_sent", family_code: family.family_code });
});

/**
 * ===============================
 * 전화번호로 사용자 검색
 * ===============================
 * GET /api/family/search/:phone
 */
router.get("/search/:phone", verifyToken, async (req, res) => {
  const myId = req.user.id;
  const { phone } = req.params;

  const user = await UserInfo.findOne({ phone }).lean();
  if (!user) return res.status(404).json({ msg: "UserNotFound" });

  // ★ 자기 자신 검색 방지
  if (user._id === myId) {
    return res.status(400).json({ msg: "CannotInviteSelf" });
  }

  res.json({
    _id: user._id,
    name: user.name,
    phone: user.phone,
    family_code: user.family_code ?? null
  });
});

/**
 * ===============================
 * 2) 받은 초대 목록 조회
 * ===============================
 * GET /api/family/invites
 */
router.get("/invites", verifyToken, async (req, res) => {
  const userId = req.user.id;

  const families = await Family.find({ "pending.to": userId }).lean();

  const pending = families.map((fam) => {
    const invite = fam.pending.find((p) => p.to === userId);
    return {
      family_code: fam.family_code,
      from: invite.from
    };
  });

  res.json(pending);
});

/**
 * ===============================
 * 3) 초대한 사람 정보 조회
 * ===============================
 * GET /api/family/invite-info/:user_id
 */
router.get("/invite-info/:user_id", verifyToken, async (req, res) => {
  const { user_id } = req.params;

  const user = await UserInfo.findById(user_id);
  if (!user) return res.status(404).json({ msg: "UserNotFound" });

  res.json({
    user_id: user._id,
    name: user.name,
    phone: user.phone
  });
});

/**
 * ===============================
 * 4) 가족 초대 수락
 * ===============================
 * POST /api/family/accept
 */
router.post("/accept", verifyToken, async (req, res) => {
  const userId = req.user.id;
  const { family_code } = req.body;

  const user = await UserInfo.findById(userId);
  const family = await Family.findOne({ family_code });

  if (!family) return res.status(404).json({ msg: "FamilyNotFound" });

  if (user.family_code) {
    return res.status(400).json({ msg: "AlreadyInFamily" });
  }

  family.pending = family.pending.filter((p) => p.to !== userId);

  family.members.push({
    user_id: user._id,
    name: user.name,
    phone: user.phone
  });

  await family.save();

  user.family_code = family_code;
  await user.save();

  res.json({ msg: "accepted" });
});

/**
 * ===============================
 * 5) 초대 거절
 * ===============================
 * POST /api/family/deny
 */
router.post("/deny", verifyToken, async (req, res) => {
  const userId = req.user.id;
  const { family_code } = req.body;

  const family = await Family.findOne({ family_code });
  if (!family) return res.status(404).json({ msg: "FamilyNotFound" });

  family.pending = family.pending.filter((p) => p.to !== userId);
  await family.save();

  res.json({ msg: "denied" });
});

/**
 * ===============================
 * 6) 가족 그룹에서 나가기
 * ===============================
 * POST /api/family/leave
 */
router.post("/leave", verifyToken, async (req, res) => {
  const userId = req.user.id;

  const user = await UserInfo.findById(userId);
  if (!user.family_code) {
    return res.status(400).json({ msg: "NotInFamily" });
  }

  const family = await Family.findOne({ family_code: user.family_code });
  if (!family) {
    user.family_code = null;
    await user.save();
    return res.json({ msg: "left_family" });
  }

  family.members = family.members.filter((m) => m.user_id !== userId);
  await family.save();

  user.family_code = null;
  await user.save();

  if (family.members.length === 0) {
    await Family.deleteOne({ family_code: family.family_code });
  }

  res.json({ msg: "left_family" });
});

export default router;
