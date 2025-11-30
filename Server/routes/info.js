import express from "express";
import UserInfo from "../models/UserInfo.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

router.get("/:id", verifyToken, async (req, res) => {
  res.json(await UserInfo.findById(req.params.id));
});

export default router;
