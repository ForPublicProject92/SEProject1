// routes/log.js
import express from "express";
import UserLog from "../models/UserLog.js";
import UserInfo from "../models/UserInfo.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

/**
 * GET /api/log/group/:date
 * → 가족 전체의 질문/답변 조회
 */
router.get("/group/:date", verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { date } = req.params;

    // 1) 내 가족 코드 조회
    const me = await UserInfo.findById(userId);
    if (!me) return res.status(404).json({ msg: "User not found" });

    const familyCode = me.family_code;

    // 가족이 없다면 자기 기록만 반환
    if (!familyCode) {
      const myLog = await UserLog.findOne({ user_id: userId, date });

      if (!myLog) {
        return res.json([]); // 기록이 없으면 빈 배열
      }

      return res.json([
        {
          user_id: userId,
          name: me.name,
          question: myLog.question,
          answer: myLog.answer
        }
      ]);
    }

    // 2) 같은 family_code를 가진 모든 구성원 조회
    const familyMembers = await UserInfo.find({ family_code: familyCode }).lean();
    const ids = familyMembers.map(m => m._id);

    // 3) UserLog에서 이 가족의 해당 날짜 기록을 가져옴
    const logs = await UserLog.find({ user_id: { $in: ids }, date }).lean();

    // 4) 매칭
    const result = familyMembers.map(member => {
      const found = logs.find(log => log.user_id === member._id);
      return {
        user_id: member._id,
        name: member.name,
        question: found?.question ?? "",
        answer: found?.answer ?? ""
      };
    });

    res.json(result);

  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
});

export default router;
