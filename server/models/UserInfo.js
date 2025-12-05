import mongoose from "mongoose";

const schema = new mongoose.Schema({
  _id: String,
  name: String,
  phone: String,
  family_code: { type: String, default: null }
});

export default mongoose.model("UserInfo", schema);
