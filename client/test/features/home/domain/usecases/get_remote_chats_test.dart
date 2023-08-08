import 'package:client/features/home/domain/entities/contact.dart';
import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_remote_chats_test.mocks.dart';

@GenerateMocks([HomeRepository, Contact])
void main() {
  late MockHomeRepository mockHomeRepository;
  late GetRemoteChats getRemoteChats;
  late List<Contact> contacts;
  setUp(() {
    mockHomeRepository = MockHomeRepository();
    getRemoteChats = GetRemoteChats(homeRepository: mockHomeRepository);
    contacts = [];
  });
  test(
    'should call getAllPeople in repository when GetRemoteChats called and should return list of contacts for success',
    () async {
      when(mockHomeRepository.getAllPeople(token: ''))
          .thenAnswer((realInvocation) async => Right(contacts));
      var result = await getRemoteChats.call(appToken: '');
      expect(result, Right(contacts));
      verify(mockHomeRepository.getAllPeople(token: '')).called(1);
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
