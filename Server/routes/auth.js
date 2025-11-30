import express from "express";
import UserLogin from "../models/UserLogin.js";
import UserInfo from "../models/UserInfo.js";
import crypto from "crypto";
import jwt from "jsonwebtoken";

const router = express.Router();
const SECRET_KEY = "YOUR_SECRET_KEY_CHANGE_THIS";

// 해시 함수
function hashPassword(pw, salt) {
  return crypto.pbkdf2Sync(pw, salt, 1000, 32, "sha256").toString("hex");
}

// 회원가입
router.post("/signup", async (req, res) => {
  const { id, password, name, phone } = req.body;

  const exists = await UserLogin.findById(id);
  if (exists) return res.status(400).json({ msg: "ID already exists" });

  const salt = crypto.randomBytes(16).toString("hex");
  const hashed = hashPassword(password, salt);

  await UserLogin.create({ _id: id, password: hashed, salt });
  await UserInfo.create({ _id: id, name, phone });

  res.json({ msg: "ok" });
});

// 로그인 → JWT 발급
router.post("/login", async (req, res) => {
  const { id, password } = req.body;

  const user = await UserLogin.findById(id);
  if (!user) return res.status(404).json({ msg: "Not found" });

  const hashed = hashPassword(password, user.salt);
  if (hashed !== user.password)
    return res.status(400).json({ msg: "Wrong password" });

  // JWT 생성
  const token = jwt.sign({ id }, SECRET_KEY, { expiresIn: "7d" });

  res.json({ msg: "ok", token, id });
});

export default router;
