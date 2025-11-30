import express from "express";
import UserLog from "../models/UserLog.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

router.get("/:id/:year/:quarter", verifyToken, async (req, res) => {
  const { id, year, quarter } = req.params;
  const data = await UserLog.findOne({ user_id: id, year, quarter });
  res.json(data || { data: [] });
});

router.post("/:id/:year/:quarter", verifyToken, async (req, res) => {
  const { id, year, quarter } = req.params;
  const { data } = req.body;
  const saved = await UserLog.findOneAndUpdate(
    { user_id: id, year, quarter },
    { data },
    { upsert: true, new: true }
  );
  res.json(saved);
});

export default router;
