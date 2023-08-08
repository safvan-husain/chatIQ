import 'package:client/common/entity/message.dart';
import 'package:client/core/helper/database/data_base_helper.dart';
import 'package:client/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:client/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:client/features/chat/domain/repositories/chat_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ChatRepository,
  DatabaseHelper,
  Message,
  ChatLocalDataSource,
  ChatRemoteDataSource
])
void main() {}
//flutter pub run build_runner build