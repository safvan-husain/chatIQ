// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/snack_bar.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/features/home/presentation/widgets/user_tile.dart';
import 'package:client/features/video_call/presentation/bloc/video_call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_search_bar/custom_search_bar.dart';
import 'package:client/features/video_call/presentation/pages/incoming_call_screen.dart'
    as a;

import 'package:client/routes/router.gr.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/Injector/injector.dart';

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
    checkAndNavigationCallingPage(context);
    getChats();
    initilizeWebSocket(context);

    super.initState();
  }

  void getChats() {
    context.read<HomeCubit>().getChats(
      () {
        showSnackBar(context, "Failed to get recent chats!!");
      },
    );
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls;
      }
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.router.pushAndPopUntil(
        const HomeRoute(),
        predicate: (_) => false,
      );
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      Injection.injector.get<WebSocketHelper>().close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeLogOut) {
          context.router.pushAndPopUntil(
            const GoogleSignInRoute(),
            predicate: (_) => false,
          );
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.newMessages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAppBar(context, state.newMessages);
                }
                return UserTile(
                  user: state.newMessages.elementAt(index - 1).user,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Row _buildAppBar(BuildContext context, List<NewMessages> people) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            height: 50,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).dividerColor,
                  ),
                  children: const <TextSpan>[
                    TextSpan(text: 'Chat'),
                    TextSpan(text: 'IQ', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Hero(tag: 'icon', child: Icon(Icons.search)),
                    onTap: () =>
                        showSearchForCustomiseSearchDelegate<NewMessages>(
                      context: context,
                      delegate: SearchScreen<NewMessages>(
                        itemStartsWith: true,
                        hintText: 'search here',
                        items: people,
                        filter: (t) => [t.user.username],
                        itemBuilder: (t) => UserTile(user: t.user),
                        failure: const Center(
                          child: Text('No Possible result found'),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => context.router.push(SettingsRoute()),
                    child: const Icon(Icons.settings_outlined),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> checkAndNavigationCallingPage(BuildContext context) async {
  var currentCall = await getCurrentCall();
  if (currentCall != null) {
    //making an offer when he accecept the call

    if (currentCall[0]['accepted'] == true) {
      if (context.mounted) {
        context.router
            .push(VideoCallRoute(recieverName: currentCall[0]['nameCaller']));
        context.read<VideoCallBloc>().add(
              MakeCallEvent(
                recieverName: currentCall[0]['nameCaller'],
                myName:
                    context.read<AuthenticationCubit>().state.user!.username,
              ),
            );
      }
    } else if (currentCall[0]['accepted'] == false) {
      //informing caller it rejected.
      Injection.injector
          .get<WebSocketHelper>()
          .sendRejection(recieverId: currentCall[0]['nameCaller']);
    }
  }
}

void initilizeWebSocket(BuildContext context) {
  Injection.initWebSocket(
    myid: context.read<AuthenticationCubit>().state.user!.username,
    onMessage: (message, from) async {
      await context.read<HomeCubit>().cachedMessage(message, from);
      context.read<ChatBloc>().add(ShowChatEvent(chatId: from));
    },
    onCall: (event) {
      context.router.push(VideoCallRoute(recieverName: event.senderUsername));
      context.read<VideoCallBloc>().add(ResponseCallEvent(event));
    },
    onAnswer: (event) {
      Future.delayed(Duration.zero, () {
        context.read<VideoCallBloc>().add(ResponseAnswerEvent(event));
      });
    },
    onCandidate: (event) {
      context.read<VideoCallBloc>().add(CandidateEvent(event));
    },
    onEnd: () async {
      var currentCalls = await getCurrentCall();
      if (currentCalls != null) {
        await FlutterCallkitIncoming.endAllCalls();
      }
      if (context.mounted) {
        context.router
            .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
      }
      Injection.injector.get<WebrtcHelper>().closeConnection();
    },
    onBusy: () => context.read<VideoCallBloc>().add(const BusyEvent()),
    onRequest: (caller) {
      Navigator.of(context).push(a.IncomingCallRoute(caller));
    },
  ).then((_) {
    Injection.initWebRTCPeerConnection();
  });
}
