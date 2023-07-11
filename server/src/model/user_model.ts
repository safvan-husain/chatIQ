import mongoose, { Schema, Document } from "mongoose";
import { messageSchema, Message } from "./message_model";
export interface User extends Document {
  username: string;
  email: string;
  password: string;
  isOnline: boolean;
  avatar: string;
  messages: Array<Message>;
  appToken: string;
}

const userSchema: Schema = new Schema({
  username: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  isOnline: { type: Boolean, default: false },
  avatar: { type: String, },
  appToken: { type: String, },
  messages: [ messageSchema ]
});

const UserModel = mongoose.model<User>("User", userSchema);
export default UserModel;
