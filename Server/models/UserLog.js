import mongoose from "mongoose";

const schema = new mongoose.Schema({
  user_id: String,
  year: Number,
  quarter: Number,
  data: [
    {
      Q: String,
      A: String
    }
  ]
});

export default mongoose.model("UserLog", schema);
