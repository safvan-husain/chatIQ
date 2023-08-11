// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/constance/color_log.dart';
import 'package:client/core/Injector/ws_injector.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/ws_event.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/features/home/presentation/widgets/user_tile.dart';
import 'package:client/features/home/presentation/widgets/user_wrapper.dart';
import 'package:client/features/video_call/presentation/bloc/video_call_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/routes/router.gr.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../common/entity/message.dart';
import '../../../../../common/widgets/second_coustom.dart';
import '../../../../../core/helper/firebase/firebase_background_message_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkAndNavigationCallingPage();
    context.read<HomeCubit>().getChats();
    WSInjection.initWebSocket(
      myid: context.read<AuthenticationCubit>().state.user!.username,
      onMessage: (Message message, String from) async {
        log('new mwssage home');
        await context.read<HomeCubit>().cachedMessage(message, from);
        context.read<ChatBloc>().add(ShowChatEvent(chatId: from));
      },
      onCall: (WSEvent event) {
        if (event.eventName == "offer") {
          log('offer');
          context.router
              .push(VideoCallRoute(recieverName: event.senderUsername));
          context.read<VideoCallBloc>().add(ResponseCallEvent(event));
        }
      },
      onAnswer: (event) {
        context.read<VideoCallBloc>().add(ResponseAnswerEvent(event));
      },
      onCandidate: (event) {
        context.read<VideoCallBloc>().add(CandidateEvent(event));
      },
      onEnd: (event) async {
        logSuccess('on ennd home event');
        var currentCalls = await getCurrentCall();
        if (currentCalls != null) {
          for (var call in currentCalls) {
            await FlutterCallkitIncoming.endCall(call['id']);
          }
        }
        context.router
            .pushAndPopUntil(const DefaultRoute(), predicate: (_) => false);
        WSInjection.injector.get<WebrtcHelper>().closeConnection();
      },
    ).then((_) {
      WSInjection.initWebRTCPeerConnection();
    });

    FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
    });

    super.initState();
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        // _currentUuid = calls[0]['id'];
        return calls;
      } else {
        // _currentUuid = "";
        return null;
      }
    }
  }

  Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      //making an offer when he accecept the call

      if (currentCall[0]['accepted'] == true) {
        log("${currentCall[0]['nameCaller']} is now on call list");
        context.router
            .push(VideoCallRoute(recieverName: currentCall[0]['nameCaller']));
        context.read<VideoCallBloc>().add(
              MakeCallEvent(
                  recieverName: currentCall[0]['nameCaller'],
                  my_name:
                      context.read<AuthenticationCubit>().state.user!.username),
            );
      }
    } else {
      log('no currentcalling');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAndNavigationCallingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeLogOut) {
          context.router.pushAndPopUntil(const GoogleSignInRoute(),
              predicate: (_) => false);
        }
      },
      buildWhen: (previous, current) => current is HomeStateImpl,
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const FaIcon(FontAwesomeIcons.users),
            onPressed: () {
              context.router.popUntilRoot();
              context.navigateTo(const ContactsRoute());
            },
          ),
          appBar: _builtAppBar(context, state.newMessages),
          body: ListView.builder(
            itemCount: state.newMessages.length,
            itemBuilder: (context, index) {
              return UserWrapper(
                user: state.newMessages.elementAt(index).user,
                index: index,
                newMessageCount: 2,
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _builtAppBar(
      BuildContext context, List<NewMessages> people) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50.0),
      child: AppBar(
        elevation: 0.0,
        title: const Text('New friends'),
        actions: [
          InkWell(
            child: const Icon(Icons.search),
            onTap: () => showSearchForCustomiseSearchDelegate<NewMessages>(
              context: context,
              delegate: SearchScreen<NewMessages>(
                itemStartsWith: true,
                hintText: 'search here',
                items: people,
                filter: (t) => [t.user.username],
                builder: (t) => UserTile(
                  user: t.user,
                  newMessageCount: t.messageCount,
                ),
                failure: const Center(
                  child: Text('No Possible result found'),
                ),
                appBarBuilder:
                    (controller, onSubmitted, textInputAction, focusNode) {
                  return PreferredSize(
                    preferredSize: const Size(double.infinity, 60.0),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(30)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                        ),
                                        child: TextField(
                                          focusNode: focusNode,
                                          controller: controller,
                                          textInputAction: textInputAction,
                                          keyboardType: TextInputType.text,
                                          onSubmitted: onSubmitted,
                                          decoration: const InputDecoration(
                                            hintText: '',
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () =>
                                            onSubmitted!(controller.text),
                                        child: const Icon(Icons.search))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                controller.text = "";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    child: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: () => context.read<HomeCubit>().logOut(),
            child: const Icon(Icons.logout_outlined),
          )
        ],
      ),
    );
  }
}
