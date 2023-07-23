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
            console.log(message.toString());
            var data = JSON.parse(message.toString());
            var reciever = webSockets[data.recieverUsername];
            if (reciever != null) {
                var response_data = JSON.stringify({
                    'eventName': 'recieve',
                    'senderUsername': data.senderUsername,
                    'recieverUsername': data.recieverUsername,
                    'message': data.message,
                });
                reciever.send(response_data);
            }
            else {
                console.log(`${data.recieverUsername} is not online`);
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
