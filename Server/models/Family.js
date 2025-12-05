// models/Family.js
import mongoose from "mongoose";

const FamilySchema = new mongoose.Schema(
  {
    family_code: { type: String, unique: true, required: true },
    members: [
      {
        user_id: String,
        name: String,
        phone: String,
        joined_at: { type: Date, default: Date.now }
      }
    ],
    pending: [
      {
        from: String, // 초대한 사람
        to: String,   // 초대받은 사람 (ID)
        created_at: { type: Date, default: Date.now }
      }
    ]
  },
  { timestamps: true }
);

export default mongoose.model("Family", FamilySchema);
