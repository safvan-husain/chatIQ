import 'package:client/core/theme/theme_services.dart';
import 'package:client/core/helper/notification/notification_controller.dart';
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
import 'package:client/features/settings/data/datasources/local_settings_data_source.dart';
import 'package:client/features/settings/data/datasources/remote_settings_data_source.dart';
import 'package:client/features/settings/domain/repositories/settings_repository.dart';
import 'package:client/features/settings/domain/usecases/delete_local_chats.dart';
import 'package:client/features/settings/domain/usecases/delete_remote_data.dart';
import 'package:client/platform/network_info.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'core/theme/theme.dart';
import 'core/Injector/injector.dart';
import 'core/helper/database/data_base_helper.dart';
import 'features/Authentication/data/datasources/user_local_data_source.dart';
import 'features/Authentication/data/datasources/user_remote_data_source.dart';
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repositoy.dart';
import 'features/settings/domain/usecases/log_out.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/video_call/presentation/bloc/video_call_bloc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Injection.initilaizeLocalDB();
  await GetStorage.init();

  if (!kIsWeb) {
    NotificationController.initilize();
    NotificationController.initChannels();
    //Ending any call (cache data) if the network connection lost.
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        FlutterCallkitIncoming.endAllCalls();
      }
    });
  }

  DatabaseHelper dataBaseHelper = Injection.injector.get<DatabaseHelper>();

  UserRepository userRepository = UserRepositoryImpl(
    localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance()),
    remoteDataSource: UserRemoteDataSourceImpl(httpClient: http.Client()),
    networkInfo: NetworkInfo(isConnected: Future.value(true)),
  );
  HomeRepository homeRepository = HomeRepositoryImpl(
    localDataSource: HomeLocalDataSourceImpl(databaseHelper: dataBaseHelper),
    remoteDataSource: HomeRemoteDataSourceImpl(client: http.Client()),
    networkInfo: NetworkInfo(isConnected: Future.value(true)),
  );
  ChatRepository chatRepository = ChatRepositoryImpl(
    localDataSource: ChatLocalDataSource(databaseHelper: dataBaseHelper),
    remoteDataSource: ChatRemoteDataSource(),
  );
  SettingsRepository settingsRepository = SettingsRepositoryImpl(
    RemoteSettingDataSource(http.Client()),
    LocalSettingDataSource(dataBaseHelper),
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
          create: (_) => VideoCallBloc(),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(
            Logout(settingsRepository),
            DeleteLocalChats(settingsRepository),
            DeleteRemoteData(settingsRepository),
          ),
        ),
        BlocProvider(
          create: (_) => HomeCubit(
              getRemoteChats: GetRemoteChats(homeRepository: homeRepository),
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
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _appRouter = AppRouter();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //Ending any call (cache data) if the network connection lost.
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        FlutterCallkitIncoming.endAllCalls();
        Navigator.of(Get.context!).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      FlutterCallkitIncoming.endAllCalls();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      key: MyApp.navigatorKey,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeService().theme,
    );
  }
}
