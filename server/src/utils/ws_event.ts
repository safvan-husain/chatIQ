export class WSEvent {
  eventName: string;
  recieverUsername: string;
  senderUsername: string;
  message: string;
  time: Number;

  constructor(
    eventName: string,
    recieverUsername: string,
    senderUsername: string,
    message: string,
    time: Number
  ) {
    this.eventName = eventName;
    this.recieverUsername = recieverUsername;
    this.senderUsername = senderUsername;
    this.message = message;
    this.time = time;
  }
  static fromJson(jsonObject: string): WSEvent {
    var map = JSON.parse(jsonObject);
    return new WSEvent(
      map["eventName"],
      map["recieverUsername"],
      map["senderUsername"],
      map["message"],
      map["time"]
    );
  } 
  ///used
  toJson(eventName: string): string {
    return JSON.stringify({
      eventName: eventName,
      recieverUsername: this.recieverUsername,
      senderUsername: this.senderUsername,
      message: this.message,
      time: this.time,
    });
  }
 }
