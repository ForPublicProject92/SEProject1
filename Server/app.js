import express from "express";
import cors from "cors";
import { connectMongo } from "./config/mongo.js";

const app = express();
app.use(express.json());
app.use(cors());

// MongoDB 연결
connectMongo();

// 라우트들
import authRoute from "./routes/auth.js";
import infoRoute from "./routes/info.js";
import logRoute from "./routes/log.js";

app.use("/auth", authRoute);
app.use("/info", infoRoute);
app.use("/log", logRoute);

app.listen(3000, () => console.log("API server running on port 3000"));
