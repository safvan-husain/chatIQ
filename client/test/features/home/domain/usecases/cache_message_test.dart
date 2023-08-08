import 'package:client/common/entity/message.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cache_message_test.mocks.dart';

@GenerateMocks([HomeRepository, NewMessages, CacheMessageParams, Message])
void main() {
  late MockHomeRepository mockHomeRepository;
  late CacheMessage cacheMessage;
  late NewMessages newMessages;
  setUp(() {
    mockHomeRepository = MockHomeRepository();
    cacheMessage = CacheMessage(mockHomeRepository);
    newMessages = MockNewMessages();
  });
  test(
    'should call cacheMessage in repository when call called and should return NewMessages for success',
    () async {
      when(mockHomeRepository.cacheMessage(any, any))
          .thenAnswer((realInvocation) async => Right(newMessages));
      var result = await cacheMessage
          .call(CacheMessageParams(message: MockMessage(), from: ''));
      expect(result, Right(newMessages));
      verify(mockHomeRepository.cacheMessage(any, any)).called(1);
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
