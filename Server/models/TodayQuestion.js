// models/TodayQuestion.js
import mongoose from "mongoose";

const TodayQuestionSchema = new mongoose.Schema(
  {
    // "2025-12-05" 이런 형태의 날짜 문자열
    date: {
      type: String,
      required: true,
      unique: true,
    },
    // 실제 질문 내용
    question: {
      type: String,
      required: true,
    },
    // 선택: 태그 등 메타데이터(필요 없으면 지워도 됨)
    tags: [String],
  },
  {
    timestamps: true, // createdAt, updatedAt 자동 생성
  }
);

export default mongoose.model("TodayQuestion", TodayQuestionSchema);
