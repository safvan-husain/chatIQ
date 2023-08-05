"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.onWebSocket = void 0;
const push_notification_1 = require("./push_notification");
const ws_event_1 = require("./ws_event");
function onWebSocket(wss) {
    var webSockets = {};
    var conected_devices = [];
    wss.on("connection", function (ws, req) {
        var userID = req.url.substr(1); //get userid from URL/userid
        webSockets[userID] = ws; //add new user to the connection list
        if (!conected_devices.includes(userID)) {
            conected_devices.push(userID);
            console.log(conected_devices);
            for (const userID in webSockets) {
                //sending to every client in the network
                webSockets[userID].send(JSON.stringify({
                    cmd: "connected_devices",
                    connected_devices: conected_devices,
                }));
            }
        }
        ws.on("message", (message) => __awaiter(this, void 0, void 0, function* () {
            if (message.toString()[0] === "{") {
                var ws_event = ws_event_1.WSEvent.fromJson(message.toString());
                // console.log(ws_event.message);
                var reciever = webSockets[ws_event.recieverUsername];
                if (reciever != null) {
                    console.log(`${ws_event.eventName} from ${ws_event.senderUsername} to ${ws_event.recieverUsername}`);
                    if (ws_event.eventName == "message") {
                        (0, push_notification_1.sendMessage)({
                            title: ws_event.senderUsername,
                            body: ws_event.message,
                            username: ws_event.recieverUsername,
                        });
                        var response = ws_event.toJson("message");
                        reciever.send(response);
                    }
                    else if (ws_event.eventName == "request") {
                        (0, push_notification_1.makeCall)(ws_event.recieverUsername, ws_event.senderUsername);
                    }
                    else if (ws_event.eventName == "offer") {
                        var response = ws_event.toJson("offer");
                        webSockets[ws_event.recieverUsername].send(response);
                    }
                    else if (ws_event.eventName == "answer") {
                        var response = ws_event.toJson("answer");
                        // console.log(response);
                        webSockets[ws_event.recieverUsername].send(response);
                        // for (const userID in webSockets) {
                        //   //sending to every client in the network
                        //   webSockets[userID].send(response);
                        // }
                    }
                    else if (ws_event.eventName === "candidate") {
                        var response = ws_event.toJson("candidate");
                        // console.log(response);
                        webSockets[ws_event.recieverUsername].send(response);
                    }
                }
                else {
                    if (ws_event.eventName === "message") {
                        console.log(ws_event.message);
                        (0, push_notification_1.sendMessage)({
                            title: ws_event.senderUsername,
                            body: ws_event.message,
                            username: ws_event.recieverUsername,
                        });
                    }
                    else if (ws_event.eventName === "request") {
                        (0, push_notification_1.makeCall)(ws_event.recieverUsername, ws_event.senderUsername);
                    }
                    console.log(`${ws_event.recieverUsername} is not online`);
                }
            }
            else {
                console.log(message.toString());
            }
        }));
        ws.on("close", function () {
            var userID = req.url.substr(1);
            delete webSockets[userID]; //on connection close, remove reciver from connection list
            console.log("User Disconnected: " + userID);
            var index = conected_devices.indexOf(userID);
            if (index > -1) {
                conected_devices.splice(index, 1);
            }
            console.log(conected_devices);
            for (const userID in webSockets) {
                //sending to every client in the network
                webSockets[userID].send(JSON.stringify({
                    cmd: "connected_devices",
                    connected_devices: conected_devices,
                }));
            }
        });
        ws.send(JSON.stringify({ cmd: "connected" }));
    });
}
exports.onWebSocket = onWebSocket;
