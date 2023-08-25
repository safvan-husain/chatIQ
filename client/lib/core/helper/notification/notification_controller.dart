import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class NotificationController {
  static Future<void> initilize() async {
    FirebaseMessaging.onMessage.listen(_firebaseForeGroundMessageHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> initChannels() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification channel for alerts',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          )
        ],
        debug: true);
  }
}

Future<void> _firebaseForeGroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'alerts',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );
  } else {
    _showCallkitIncoming(const Uuid().v4(), message.data['caller']);
  }
}

Future<void> _showCallkitIncoming(String uuid, String caller) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: caller,
    appName: 'ChatIQ',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}
