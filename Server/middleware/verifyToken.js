// middleware/auth.js
import jwt from "jsonwebtoken";
import { SECRET_KEY } from "../config/secret.js";

export function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ msg: "No token" });
  }

  if (!authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ msg: "Invalid token format" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    req.user = decoded;      
    next();
  } catch (e) {
    return res.status(403).json({ msg: "Invalid token" });
  }
}
