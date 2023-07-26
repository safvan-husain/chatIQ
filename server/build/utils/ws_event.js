"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WSEvent = void 0;
class WSEvent {
    constructor(eventName, recieverUsername, senderUsername, message, time) {
        this.eventName = eventName;
        this.recieverUsername = recieverUsername;
        this.senderUsername = senderUsername;
        this.message = message;
        this.time = time;
    }
    static fromJson(jsonObject) {
        var map = JSON.parse(jsonObject);
        return new WSEvent(map["eventName"], map["recieverUsername"], map["senderUsername"], map["message"], map["time"]);
    }
    ///used
    toJson(eventName) {
        return JSON.stringify({
            eventName: eventName,
            recieverUsername: this.recieverUsername,
            senderUsername: this.senderUsername,
            message: this.message,
            time: this.time,
        });
    }
}
exports.WSEvent = WSEvent;
