// routes/info.js
import express from "express";
import UserInfo from "../models/UserInfo.js";
import { verifyToken } from "../middleware/auth.js";

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

export default router;
