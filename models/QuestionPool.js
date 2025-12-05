// models/QuestionPool.js
import mongoose from "mongoose";

const QuestionPoolSchema = new mongoose.Schema({
  text: {
    type: String,
    required: true
  }
});

export default mongoose.model("QuestionPool", QuestionPoolSchema);
