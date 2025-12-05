// routes/info.js
import express from "express";
import UserInfo from "../models/UserInfo.js";
import { verifyToken } from "../middleware/verifyToken.js";

const router = express.Router();

/**
 * GET /api/info/me
 * → 현재 로그인한 유저 정보 반환
 */
router.get("/me", verifyToken, async (req, res) => {
  try {
    const id = req.user.id;
    const user = await UserInfo.findById(id).select("-__v");

    if (!user) return res.status(404).json({ msg: "User not found" });

    res.json(user);
  } catch (e) {
    res.status(500).json({ msg: "Server error", error: e.message });
  }
});

/**
 * POST /api/info/update
 * → 사용자 정보 수정 (이름/전화번호)
 */
router.post("/update", verifyToken, async (req, res) => {
  try {
    const id = req.user.id;
    const { name, phone } = req.body;

    const updated = await UserInfo.findByIdAndUpdate(
      id,
      { name, phone },
      { new: true }
    );

    res.json({ msg: "update_ok", user: updated });
  } catch (e) {
    res.status(500).json({ msg: "Server error", error: e.message });
  }
});

export default router;
