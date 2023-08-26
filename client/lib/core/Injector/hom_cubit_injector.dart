import 'package:flutter_simple_dependency_injection/injector.dart';

import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repositoy.dart';
import '../../features/home/domain/usecases/cache_message.dart';
import '../../features/home/domain/usecases/get_local_chats.dart';
import '../../features/home/domain/usecases/get_remote_chats.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../platform/network_info.dart';
import 'package:http/http.dart' as http;

import '../helper/database/data_base_helper.dart';
import 'injector.dart';

class HomeCubitInjector {
  static late Injector injector;
//I want to trigger a event from auth feature, after fetching the remote messages
//I want to update the home ui, I can't use context because, navigate to home before
//getting the messages, to make the loading faster.
  static HomeCubit init() {
    HomeRepository homeRepository = HomeRepositoryImpl(
      localDataSource: HomeLocalDataSourceImpl(
          databaseHelper: Injection.injector.get<DatabaseHelper>()),
      remoteDataSource: HomeRemoteDataSourceImpl(client: http.Client()),
      networkInfo: NetworkInfo(isConnected: Future.value(true)),
    );
    var homeCubit = HomeCubit(
        getRemoteChats: GetRemoteChats(homeRepository: homeRepository),
        getLocalChats: GetLocalChats(homeRepository),
        cacheMessage: CacheMessage(homeRepository));
    injector = Injector();
    injector.map<HomeCubit>((i) => homeCubit, isSingleton: true);
    return homeCubit;
  }
}
