// routes/todayQuestion.js
import express from "express";
import TodayQuestion from "../models/TodayQuestion.js";
import UserLog from "../models/UserLog.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

const todayKey = () => new Date().toISOString().substring(0, 10);

/**
 * GET /api/question/today
 * → 오늘의 질문 + 기존 답변(있으면)
 */
router.get("/today", verifyToken, async (req, res) => {
  try {
    const date = todayKey();
    const userId = req.user.id;

    // 1) 오늘 질문 조회 or 생성
    let tq = await TodayQuestion.findOne({ date });
    if (!tq) {
      tq = await TodayQuestion.create({
        date,
        question: "오늘 하루는 어떠셨나요?" // 기본 질문
      });
    }

    // 2) 유저 로그 조회 or 생성
    let log = await UserLog.findOne({ user_id: userId, date });

    if (!log) {
      log = await UserLog.create({
        user_id: userId,
        date,
        question: tq.question,
        answer: ""
      });
    }

    res.json({
      date,
      question: log.question,
      answer: log.answer,
    });

  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
});

/**
 * POST /api/question/answer
 * → 답변 저장
 */
router.post("/answer", verifyToken, async (req, res) => {
  try {
    const date = todayKey();
    const userId = req.user.id;
    const { answer } = req.body;

    const log = await UserLog.findOneAndUpdate(
      { user_id: userId, date },
      { answer },
      { new: true }
    );

    if (!log) {
      return res.status(404).json({ msg: "No question log found for today" });
    }

    res.json({
      msg: "ok",
      date,
      question: log.question,
      answer: log.answer,
    });

  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
});

export default router;
