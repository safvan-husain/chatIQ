import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    // AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       id: 1,
    //       channelKey: 'incoming_call',
    //       title: message.data['caller'],
    //       criticalAlert: true,
    //       category: NotificationCategory.Call,
    //       locked: true,
    //       autoDismissible: false,
    //     ),
    //     actionButtons: [
    //       NotificationActionButton(key: 'Accept', label: 'Accept'),
    //       NotificationActionButton(
    //         key: 'Reject',
    //         label: 'Reject',
    //         isDangerousOption: true,
    //       ),
    //     ]);
    // Timer.periodic(const Duration(seconds: 5), (timer) {
    //   AwesomeNotifications().cancel(1);
    // });
    _showCallkitIncoming(const Uuid().v4(), message.data['caller']);
  }
}

Future<void> _showCallkitIncoming(String uuid, String caller) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: caller,
    appName: 'Callkit',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}
