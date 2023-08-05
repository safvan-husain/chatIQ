import 'package:client/features/Authentication/data/repositories/user_repository_impl.dart';
import 'package:client/features/Authentication/domain/repositories/user_repository.dart';
import 'package:client/features/Authentication/domain/usecases/get_cache_user.dart';
import 'package:client/features/Authentication/domain/usecases/get_user.dart';
import 'package:client/features/Authentication/domain/usecases/login_with_google.dart';
import 'package:client/features/Authentication/domain/usecases/register_user.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:client/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:client/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:client/features/chat/domain/repositories/chat_repository.dart';
import 'package:client/features/chat/domain/usecases/send_message.dart';
import 'package:client/features/chat/domain/usecases/show_message.dart';
import 'package:client/features/chat/domain/usecases/update_last_visit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:client/features/video_call/domain/repositories/video_call_repository.dart';
import 'package:client/features/video_call/domain/usecases/answer_call.dart';
import 'package:client/features/video_call/domain/usecases/reject_call.dart';
import 'package:client/platform/network_info.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/push_notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constance/theme.dart';
import 'core/Injector/injector.dart';
import 'core/helper/firebase/firebase_background_message_handler.dart';
import 'features/Authentication/data/datasources/user_local_data_source.dart';
import 'features/Authentication/data/datasources/user_remote_data_source.dart';
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repositoy.dart';
import 'features/home/domain/usecases/log_out.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/video_call/data/datasources/video_call_local_data_source.dart';
import 'features/video_call/data/datasources/video_call_remote_data_source.dart';
import 'features/video_call/data/repositories/video_call_repository_impl.dart';
import 'features/video_call/domain/usecases/make_call.dart';
import 'features/video_call/presentation/bloc/video_call_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.initInjection();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  UserRepository userRepository = UserRepositoryImpl(
    localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance()),
    remoteDataSource: UserRemoteDataSourceImpl(httpClient: http.Client()),
    networkInfo: NetworkInfo(isConnected: Future.value(true)),
  );
  HomeRepository homeRepository = HomeRepositoryImpl(
    localDataSource: HomeLocalDataSourceImpl(),
    remoteDataSource: HomeRemoteDataSourceImpl(client: http.Client()),
    networkInfo: NetworkInfo(isConnected: Future.value(true)),
  );
  ChatRepository chatRepository = ChatRepositoryImpl(
    localDataSource: ChatLocalDataSource(),
    remoteDataSource: ChatRemoteDataSource(),
  );
  VideoCallRepository videoCallRepository = VideoCallRepositoryImpl(
    VideoCallLocalDataSource(),
    VideoCallRemoteDataSource(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationCubit(
            loginWithGoogle: LoginWithGoogle(
              userRepository: userRepository,
            ),
            registerUser: RegisterUser(
              authenticationRepository: userRepository,
            ),
            getUser: GetUser(repository: userRepository),
            getCachedUser: GetCachedUser(repository: userRepository),
          ),
        ),
        BlocProvider(
          create: (_) => VideoCallBloc(
            MakeCall(videoCallRepository),
            AnswerCall(videoCallRepository),
            RejectCall(videoCallRepository),
          ),
        ),
        BlocProvider(
          create: (_) => HomeCubit(
              getRemoteChats: GetRemoteChats(homeRepository: homeRepository),
              logout: Logout(homeRepository),
              getLocalChats: GetLocalChats(homeRepository),
              cacheMessage: CacheMessage(homeRepository)),
        ),
        BlocProvider(
            create: (_) => ChatBloc(
                  SendMessage(repository: chatRepository),
                  ShowMessage(repository: chatRepository),
                  UpdateLastVisit(chatRepository: chatRepository),
                )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
