import mongoose from "mongoose";

const schema = new mongoose.Schema({
  _id: String, // ID = primary key
  password: String,
  salt: String,
  created_at: { type: Date, default: Date.now },
  login_locked: { type: Boolean, default: false }
});

export default mongoose.model("UserLogin", schema);
