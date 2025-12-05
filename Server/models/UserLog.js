// models/UserLog.js
import mongoose from "mongoose";

const UserLogSchema = new mongoose.Schema(
  {
    user_id: { type: String, required: true },     // 사용자 ID
    date: { type: String, required: true },        // YYYY-MM-DD
    question: { type: String, required: true },    // 질문 내용
    answer: { type: String, default: "" },         // 사용자가 작성한 답변
  },
  { timestamps: true }
);

// user_id + date 는 하나만 있어야 한다 (중복 방지)
UserLogSchema.index({ user_id: 1, date: 1 }, { unique: true });

export default mongoose.model("UserLog", UserLogSchema);
