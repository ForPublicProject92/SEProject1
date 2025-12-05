import fs from "fs";
import mongoose from "mongoose";
import QuestionPool from "../models/QuestionPool.js";

const MONGO_URL = "mongodb://127.0.0.1:27017/soft1test"; // ← 수정 필요
const FILE_PATH = "./Insert.txt"; // Insert.txt 경로

async function run() {
  try {
    // 1) MongoDB 연결
    await mongoose.connect(MONGO_URL);
    console.log("MongoDB connected");

    // 2) Insert.txt 파일 읽기
    const raw = fs.readFileSync(FILE_PATH, "utf8");

    // 3) <br> 기준으로 split하여 배열 생성
    const list = raw
      .split("<br>")
      .map(q => q.trim())
      .filter(q => q.length > 0);

    if (list.length === 0) {
      console.log("Insert.txt 파일에 질문이 없습니다.");
      process.exit();
    }

    // 4) MongoDB에 일괄 삽입
    const docs = list.map(q => ({ text: q }));
    await QuestionPool.insertMany(docs);

    console.log(`총 ${docs.length}개의 질문이 삽입되었습니다.`);
    process.exit();

  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

run();
