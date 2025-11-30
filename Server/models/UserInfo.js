import mongoose from "mongoose";

const schema = new mongoose.Schema({
  _id: String,   // ID
  name: String,
  phone: String,
  family_code: Number
});

export default mongoose.model("UserInfo", schema);
