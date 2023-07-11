import 'package:client/constance/constant_variebles.dart';
import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'auth_services_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  MockClient client = MockClient();
  WidgetsFlutterBinding.ensureInitialized();
  late AuthServices authservices;
  setUp(() {
    authservices = AuthServices(httpClient: client);
  });
  group("test for auth Token", () {
    test('when there is no token response should return 505 status code.',
        () async {
      SharedPreferences.setMockInitialValues({});
      var response = await authservices.authenticationByToken();
      expect(response.statusCode, 505);
    });
    test('when there is invalid token response should return 401 status code.',
        () async {
      SharedPreferences.setMockInitialValues({"token": "test"});
      when(
        client.get(
          Uri.parse('$uri/auth/token'),
          headers: <String, String>{
            'content-type': 'application/json; charset=utf-8',
            'x-auth-token': 'test',
          },
        ),
      ).thenAnswer((realInvocation) async => http.Response('', 401));

      var response = await authservices.authenticationByToken();
      expect(response.statusCode, 401);
    });
    test('when there is valid token response should return 200 status code.',
        () async {
      SharedPreferences.setMockInitialValues({"token": "valid token"});
      when(
        client.get(
          Uri.parse('$uri/auth/token'),
          headers: <String, String>{
            'content-type': 'application/json; charset=utf-8',
            'x-auth-token': 'valid token',
          },
        ),
      ).thenAnswer((realInvocation) async => http.Response('', 200));

      var response = await authservices.authenticationByToken();
      expect(response.statusCode, 200);
    });
  });
}
