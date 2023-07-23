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
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:client/local_database/message_schema.dart';
import 'package:client/platform/network_info.dart';
import 'package:client/provider/chat_list_provider.dart';
import 'package:client/provider/stream_provider.dart';
import 'package:client/provider/unread_messages.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/push_notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constance/theme.dart';
import 'core/Injector/injector.dart';
import 'features/Authentication/data/datasources/user_local_data_source.dart';
import 'features/Authentication/data/datasources/user_remote_data_source.dart';
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repositoy.dart';
import 'features/home/domain/usecases/log_out.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.initInjection();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ChatListProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => WsProvider(),
          ),
          Provider(
            create: (_) => AppDatabase(),
          ),
          ChangeNotifierProvider(
            create: (_) => Unread(),
          )
        ],
        child: const MyApp(),
      ),
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
      theme: darkTheme,
      darkTheme: darkTheme,
    );
  }
}
