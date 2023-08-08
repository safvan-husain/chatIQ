import 'dart:convert';

import 'package:client/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../Authentication/data/datasources/user_remote_data_source_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late HomeRemoteDataSource homeRemoteDataSource;
  late MockClient client;
  setUp(() {
    client = MockClient();
    homeRemoteDataSource = HomeRemoteDataSourceImpl(client: client);
  });
  test(
    'should call client get when call getALLPeople and should return a List',
    () async {
      when(client.get(any, headers: captureAnyNamed("headers")))
          .thenAnswer((_) async => Response(jsonEncode([]), 200));
      var result = await homeRemoteDataSource.getAllPeople(token: '');
      expect(result, []);
      verify(client.get(any)).called(1);
      verifyNoMoreInteractions(client);
    },
  );
}
