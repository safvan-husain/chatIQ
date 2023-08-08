import 'package:client/common/entity/message.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_local_chats_test.mocks.dart';

@GenerateMocks([HomeRepository, NewMessages, Message])
void main() {
  late MockHomeRepository mockHomeRepository;
  late GetLocalChats getLocalChats;
  late List<NewMessages> newMessages;
  setUp(() {
    mockHomeRepository = MockHomeRepository();
    getLocalChats = GetLocalChats(mockHomeRepository);
    newMessages = [MockNewMessages()];
  });
  test(
    'should call GetLocalChats in repository when call called and should return list of NewMessages for success',
    () async {
      when(mockHomeRepository.getLocalChats())
          .thenAnswer((realInvocation) async => Right(newMessages));
      var result = await getLocalChats.call(NoParams());
      expect(result, Right(newMessages));
      verify(mockHomeRepository.getLocalChats()).called(1);
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
