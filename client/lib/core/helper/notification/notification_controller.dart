import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:client/constance/color_log.dart';
import 'package:client/core/Injector/injector.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';
import 'package:client/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/Authentication/presentation/cubit/authentication_cubit.dart';
import '../../../features/video_call/presentation/bloc/video_call_bloc.dart';
import '../../../routes/router.gr.dart';
import '../firebase/firebase_background_message_handler.dart';

class NotificationController {
  static Future<void> initilize() async {
    Future<void> firebadeMessageHandler(RemoteMessage message) async {
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
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'incoming_call',
              title: message.data['caller'],
              criticalAlert: true,
              category: NotificationCategory.Call,
              locked: true,
              autoDismissible: false,
            ),
            actionButtons: [
              NotificationActionButton(key: 'Accept', label: 'Accept'),
              NotificationActionButton(
                key: 'Reject',
                label: 'Reject',
                isDangerousOption: true,
              ),
            ]);
        Timer.periodic(const Duration(seconds: 15), (timer) {
          AwesomeNotifications().cancel(1);
        });
      }
    }

    FirebaseMessaging.onMessage.listen(firebadeMessageHandler);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> initChannels() async {
    await AwesomeNotifications().initialize(
        null, // set the icon to null if you want to use the default app icon
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
          ),
          NotificationChannel(
            channelKey: 'incoming_call',
            channelName: 'Incoming Call',
            channelDescription: 'Notification channel for Incoming call',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
        ],
        debug: true);
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    if (MyApp.navigatorKey.currentContext != null) {
      logError('context is not null');
    } else {
      logError('context is  null');
    }
    if (action.buttonKeyPressed == "Reject") {
      Injection.injector
          .get<WebSocketHelper>()
          .sendRejection(recieverId: action.title!);
    } else if (action.buttonKeyPressed == "Accept") {
      BuildContext context = MyApp.navigatorKey.currentContext!;
      context.router.push(VideoCallRoute(recieverName: action.title!));
      context.read<VideoCallBloc>().add(
            MakeCallEvent(
              recieverName: action.title!,
              myName: context.read<AuthenticationCubit>().state.user!.username,
            ),
          );
      logSuccess('accepted ${action.title}');
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   BuildContext context = NavigatorService.navigatorKey.currentContext!;
      //   context.router.push(VideoCallRoute(recieverName: action.title!));
      //   context.read<VideoCallBloc>().add(
      //         MakeCallEvent(
      //           recieverName: action.title!,
      //           myName:
      //               context.read<AuthenticationCubit>().state.user!.username,
      //         ),
      //       );
      // });
    }
  }
}
