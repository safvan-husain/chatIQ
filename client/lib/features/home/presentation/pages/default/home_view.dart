import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/snack_bar.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:client/core/helper/websocket/websocket_helper.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/features/home/presentation/widgets/user_tile.dart';
import 'package:client/features/home/presentation/widgets/user_wrapper.dart';
import 'package:client/features/video_call/presentation/bloc/video_call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_search_bar/custom_search_bar.dart';

import 'package:client/routes/router.gr.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
    // Injection.injector.get<NotificationController>().setContext(context);
    WidgetsBinding.instance.addObserver(this);
    checkAndNavigationCallingPage();
    context
        .read<HomeCubit>()
        .getChats(() => showSnackBar(context, "Failed to get recent chats!!"));
    Injection.initWebSocket(
      myid: context.read<AuthenticationCubit>().state.user!.username,
      onMessage: (message, from) async {
        await context.read<HomeCubit>().cachedMessage(message, from);
        if (context.mounted) {
          context.read<ChatBloc>().add(ShowChatEvent(chatId: from));
        }
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
      onBusy: () {
        context.read<VideoCallBloc>().add(const BusyEvent());
      },
      onRequest: (caller) {
        context.router.push(IncomingCallRoute(caller: caller));
      },
    ).then((_) {
      Injection.initWebRTCPeerConnection();
    });

    super.initState();
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

  Future<void> checkAndNavigationCallingPage() async {
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
        Injection.injector
            .get<WebSocketHelper>()
            .sendRejection(recieverId: currentCall[0]['nameCaller']);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // checkAndNavigationCallingPage();
      context.router
          .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
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
        title: const Row(
          children: [
            Text(
              'Chat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'IQ',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: const Hero(tag: 'icon', child: Icon(Icons.search)),
              onTap: () => showSearchForCustomiseSearchDelegate<NewMessages>(
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
    );
  }
}
