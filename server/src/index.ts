import express from "express";
import * as dotenv from "dotenv";
import * as websocket from "ws";
import { SigninRouter } from "./routes/sign_in_route";
import bodyParser from "body-parser";
import { SignUpRouter } from "./routes/sign_up_route";
import mongoose from "mongoose";
import cors from "cors";
import { DataRouter } from "./routes/get_data";
import { onWebSocket } from "./utils/web_socket";
import { ProfileRouter } from "./routes/user_account";
import { messageRouter } from "./routes/message_router";

dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.json());
app.use(SigninRouter);
app.use(SignUpRouter);
app.use(messageRouter);
app.use(DataRouter);
app.use(ProfileRouter);

app.get("/", (req, res) => {
  res.send("privacy policy");
});

mongoose.set("strictQuery", true);
mongoose.connect(process.env.MongoUrl!, () => {
  console.log(
    mongoose.connection.readyState == 1
      ? "MongoDB connected!"
      : "MongoDB Not connected!"
  );
});

const server = app.listen(process.env.PORT, function () {
  console.log("port lisenting on " + process.env.PORT);
});

const wss = new websocket.Server({ server });
onWebSocket(wss);
