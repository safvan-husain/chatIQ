// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/core/Injector/ws_injector.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/features/home/presentation/widgets/user_wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import 'package:client/provider/chat_list_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/get_data_services.dart';

import '../../../../../local_database/message_schema.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/push_notification_services.dart';
import '../../../../../services/web_socket_set_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late IOWebSocketChannel channel; //channel varaible for websocket
  List<Message> allMessages = [];
  List<User> userList = [];
  GetDataService getData = GetDataService();

  @override
  void initState() {
    context.read<HomeCubit>().getChats();
    WSInjection.initInjection(
      context.read<AuthenticationCubit>().state.user!.username,
      (String message, String from) async {
        log('here');
        await context
            .read<HomeCubit>()
            .cacheMessage(CacheMessageParams(message: message, from: from));
        context.read<ChatBloc>().add(ShowChatEvent(chatId: from));
      },
    );
    FirebaseMessaging.onMessage.listen((message) {
      log('onmsg');
      bool canIshow = true;
      (message.data.forEach((key, value) {
        if (key == "reciever") {
          if (value == context.read<Unread>().currentChat) {
            canIshow = false;
          }
        }
      }));
      if (canIshow) showFlutterNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.router.push(const ContactsRoute()),
        ),
        appBar: _buildAppBar(context),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeLogOut) {
              context.router.pushAndPopUntil(const GoogleSignInRoute(),
                  predicate: (_) => false);
            }
          },
          buildWhen: (previous, current) => current is HomeStateImpl,
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                return UserWrapper(
                  user: state.chats.elementAt(index),
                  allMessages: [],
                  index: index,
                );
              },
            );
          },
        ));
  }

  _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 40),
      child: AppBar(
        title: const Text(
          "Messenger",
          style: TextStyle(color: Colors.blueGrey),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              _buildPopupItem('search', () {}),
              _buildPopupItem(
                'settings',
                () {},
              ),
              _buildPopupItem(
                'Log out',
                () => context.read<HomeCubit>().logOut(),
              ),
            ],
          )
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupItem(String action, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(action),
    );
  }
}
