import * as websocket from "ws";
import { Message } from "../model/message_model";
import UserModel from "../model/user_model";
import { sendMessage } from "./push_notification";
import { WSEvent } from "./ws_event";

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
          console.log(`${ws_event.eventName} from ${ws_event.senderUsername} to ${ws_event.recieverUsername}`);

          if (ws_event.eventName == "message") {
            var response: string = ws_event.toJson("message");
            reciever.send(response);
          } else if (ws_event.eventName == "offer") {
            var response = ws_event.toJson("offer");
            // console.log(response);
            webSockets[ws_event.recieverUsername].send(response);

            // for (const userID in webSockets) {

            //   //sending to every client in the network
            //   webSockets[userID].send(response);
            // }
          }
           else if (ws_event.eventName == "answer") {
            var response = ws_event.toJson("answer");
            // console.log(response);
            webSockets[ws_event.recieverUsername].send(response);

            // for (const userID in webSockets) {

            //   //sending to every client in the network
            //   webSockets[userID].send(response);
            // }
          } else if(ws_event.eventName === "candidate" ) {
            var response = ws_event.toJson("candidate");
            // console.log(response);
            webSockets[ws_event.recieverUsername].send(response);
          }
        } else {  
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
