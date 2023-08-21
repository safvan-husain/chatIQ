import * as websocket from "ws";
import { MessageModel } from "../model/message_model";
import { UserModel } from "../model/user_model";
import { sendMessage, makeCall } from "./push_notification";
import { WSEvent } from "./ws_event";
import { saveMessageDB } from "./data_base_methods";

export function onWebSocket(wss: websocket.Server<websocket.WebSocket>) {
  var webSockets: any = {};
  var conected_devices: string[] = [];

  wss.on("connection", function (ws, req) {
    var userID = req.url!.substr(1); //get userid from URL/userid
    webSockets[userID] = ws; //add new user to the connection list
    if (!conected_devices.includes(userID)) {
      conected_devices.push(userID);
      console.log(conected_devices);
      for (const userID in webSockets) {
        //sending to every client in the network
        webSockets[userID].send(
          JSON.stringify({
            cmd: "connected_devices",
            connected_devices: conected_devices,
          })
        );
      }
    }
    ws.on("message", async (message) => {
      if (message.toString()[0] === "{") {
        var ws_event: WSEvent = WSEvent.fromJson(message.toString());
        // console.log(ws_event.message);
        var reciever = webSockets[ws_event.recieverUsername];
        if (reciever != null) {
          console.log(
            `${ws_event.eventName} from ${ws_event.senderUsername} to ${ws_event.recieverUsername}`
          );

          if (ws_event.eventName == "message") {
            sendMessage({
              title: ws_event.senderUsername,
              body: ws_event.message,
              username: ws_event.recieverUsername,
            });
            var response: string = ws_event.toJson("message");
            reciever.send(response);
           
          } else if (ws_event.eventName == "request") {
            var response: string = ws_event.toJson("request");
            reciever.send(response);
          } else if (ws_event.eventName == "offer") {
            var response = ws_event.toJson("offer");
            webSockets[ws_event.recieverUsername].send(response);
          } else if (ws_event.eventName == "answer") {
            var response = ws_event.toJson("answer");
            webSockets[ws_event.recieverUsername].send(response);
          } else if (ws_event.eventName === "candidate") {
            var response = ws_event.toJson("candidate");
            webSockets[ws_event.recieverUsername].send(response);
          } else if (ws_event.eventName == "end") {
            var response = ws_event.toJson("end");
            webSockets[ws_event.recieverUsername].send(response);
          } else if (ws_event.eventName === "busy") {
            var response: string = ws_event.toJson("busy");
            reciever.send(response);
          } else if (ws_event.eventName === "available") {
            makeCall(ws_event.senderUsername, ws_event.recieverUsername);
          } else if (ws_event.eventName == "rejection") {
            var response: string = ws_event.toJson("rejection");
            reciever.send(response);
          }
        } else {
          if (ws_event.eventName === "message") {
            console.log(ws_event.message);

            sendMessage({
              title: ws_event.senderUsername,
              body: ws_event.message,
              username: ws_event.recieverUsername,
            });
            saveMessageDB(
              ws_event.senderUsername,
              ws_event.recieverUsername,
              ws_event.message,
              true
            );
          } else if (ws_event.eventName === "request") {
            makeCall(ws_event.recieverUsername, ws_event.senderUsername);
          }

          console.log(`${ws_event.recieverUsername} is not online`);
        }
      } else {
        console.log(message.toString());
      }
    });
    ws.on("close", function () {
      var userID = req.url!.substr(1);
      delete webSockets[userID]; //on connection close, remove reciver from connection list
      console.log("User Disconnected: " + userID);
      var index = conected_devices.indexOf(userID);
      if (index > -1) {
        conected_devices.splice(index, 1);
      }
      console.log(conected_devices);
      for (const userID in webSockets) {
        //sending to every client in the network
        webSockets[userID].send(
          JSON.stringify({
            cmd: "connected_devices",
            connected_devices: conected_devices,
          })
        );
      }
    });

    ws.send(JSON.stringify({ cmd: "connected" }));
  });
}
