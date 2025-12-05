// routes/auth.js
import express from "express";
import UserLogin from "../models/UserLogin.js";
import UserInfo from "../models/UserInfo.js";
import crypto from "crypto";
import jwt from "jsonwebtoken";
import { verifyToken } from "../middleware/verifyToken.js";
import { SECRET_KEY } from "../config/secret.js";

const router = express.Router();

// PBKDF2 해시 함수
function hashPassword(pw, salt) {
  return crypto.pbkdf2Sync(pw, salt, 1000, 32, "sha256").toString("hex");
}

// ================================
// 회원가입
// ================================
router.post("/signup", async (req, res) => {
  const { id, password, name, phone } = req.body;

  const exists = await UserLogin.findById(id);
  if (exists) return res.status(400).json({ msg: "ID already exists" });

  const salt = crypto.randomBytes(16).toString("hex");
  const hashed = hashPassword(password, salt);

  await UserLogin.create({ _id: id, password: hashed, salt });
  await UserInfo.create({ _id: id, name, phone });

  res.json({ msg: "signup_ok" });
});

// ================================
// 로그인
// ================================
router.post("/login", async (req, res) => {
  const { id, password } = req.body;

  const user = await UserLogin.findById(id);
  if (!user) return res.status(404).json({ msg: "Not found" });

  const hashed = hashPassword(password, user.salt);

  if (hashed !== user.password)
    return res.status(400).json({ msg: "Wrong password" });

  const token = jwt.sign({ id }, SECRET_KEY, { expiresIn: "7d" });
  const info = await UserInfo.findById(id).lean();

  res.json({
    msg: "login_ok",
    token,
    id,
    name: info?.name ?? "",
    phone: info?.phone ?? ""
  });
});

// ================================
// 비밀번호 변경
// ================================
router.post("/change-password", verifyToken, async (req, res) => {
  const id = req.user.id;
  const { current, new: newPw } = req.body;

  const user = await UserLogin.findById(id);
  if (!user) return res.status(404).json({ msg: "User not found" });

  const currentHash = hashPassword(current, user.salt);
  if (currentHash !== user.password)
    return res.status(400).json({ msg: "Wrong password" });

  const newSalt = crypto.randomBytes(16).toString("hex");
  const newHash = hashPassword(newPw, newSalt);

  user.salt = newSalt;
  user.password = newHash;
  await user.save();

  res.json({ msg: "password_changed" });
});

// ================================
// 회원 탈퇴
// ================================
router.post("/delete-account", verifyToken, async (req, res) => {
  const id = req.user.id;

  try {
    // 1) 유저 정보 가져오기
    const user = await UserInfo.findById(id);
    if (!user) {
      await UserLogin.findByIdAndDelete(id);
      return res.json({ msg: "delete_ok" });
    }

    // 2) 가족 정보에서 제거
    if (user.family_code) {
      const family = await Family.findOne({ family_code: user.family_code });

      if (family) {
        // 멤버 제거
        family.members = family.members.filter(m => m.user_id !== id);

        // pending 초대 제거
        family.pending = family.pending.filter(p => p.to !== id && p.from !== id);

        await family.save();

        // 구성원 0 → 가족 문서 삭제
        if (family.members.length === 0) {
          await Family.deleteOne({ family_code: family.family_code });
        }
      }
    }

    // 3) UserInfo 삭제
    await UserInfo.findByIdAndDelete(id);

    // 4) UserLogin 삭제
    await UserLogin.findByIdAndDelete(id);

    res.json({ msg: "delete_ok" });
  } catch (e) {
    res.status(500).json({ msg: "Server error", error: e.message });
  }
});

// ================================
// 자동 로그인용 토큰 검증 API
// ================================
router.get("/verify", verifyToken, (req, res) => {
  res.json({ msg: "valid", id: req.user.id });
});

export default router;
