import 'package:client/features/chat/domain/usecases/update_last_visit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import '../../generate.mocks.dart';

void main() {
  late UpdateLastVisit updateLastVisit;
  late MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    updateLastVisit = UpdateLastVisit(chatRepository: mockChatRepository);
  });
  test(
    'should call repository.UpdateLastVisits when called',
    () async {
      await updateLastVisit.call('');
      verify(mockChatRepository.updateLasVisit(any)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
