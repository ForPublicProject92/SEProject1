// app.js
import express from "express";
import cors from "cors";
import { connectMongo } from "./config/mongo.js";
import { SECRET_KEY } from "./config/secret.js";

const app = express();
app.use(express.json());
app.use(cors());

// DB 연결
connectMongo();

// 라우트 import
import authRouter from "./routes/auth.js";
import infoRoute from "./routes/info.js";
import logRoute from "./routes/log.js";
import familyRoute from "./routes/family.js";
import todayQuestionRoute from "./routes/todayQuestion.js";

// 서버 확인
app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// 인증 불필요
app.use("/api/auth", authRouter);

// 인증 필요 라우트
import { verifyToken } from "./middleware/auth.js";
app.use("/api/info", verifyToken, infoRoute);
app.use("/api/log", verifyToken, logRoute);

app.use("/api/question", verifyToken, todayQuestionRoute);

app.use("/api/family", verifyToken, familyRoute);

app.listen(2803, () => {
  console.log("API server running on port 2803");
  console.log("[SECRET_KEY]", SECRET_KEY);
});
