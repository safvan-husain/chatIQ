import 'package:client/features/chat/domain/usecases/show_message.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../generate.mocks.dart';

void main() {
  late ShowMessage showMessage;
  late MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    showMessage = ShowMessage(repository: mockChatRepository);
  });
  test(
    'should call repository.showMessages when called',
    () async {
      when(mockChatRepository.showMessages(any))
          .thenAnswer((realInvocation) async => const Right([]));
      var actual = await showMessage.call(ShowMessageParams(''));
      expect(actual.isRight(), true);
      verify(mockChatRepository.showMessages(any)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
