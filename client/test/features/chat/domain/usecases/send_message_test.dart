import 'package:client/features/chat/domain/usecases/send_message.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generate.mocks.dart';

void main() {
  late SendMessage sendMessage;
  late MockChatRepository mockChatRepository;
  late MockMessage mockMessage;
  setUp(() {
    mockChatRepository = MockChatRepository();
    sendMessage = SendMessage(repository: mockChatRepository);
    mockMessage = MockMessage();
  });
  test(
    'should call repository.sendMessage when called',
    () async {
      when(mockChatRepository.sendMessage(any, any, any))
          .thenAnswer((realInvocation) async => Right(mockMessage));
      var actual =
          await sendMessage.call(SendMessageParams(mockMessage, '', ''));
      expect(actual, Right(mockMessage));
      verify(mockChatRepository.sendMessage(any, any, any)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
