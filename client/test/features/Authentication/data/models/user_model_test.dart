import 'dart:convert';

import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:client/features/Authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserModel userModel;
  setUp(() {
    userModel = const UserModel(
      username: 'safvan',
      email: 'safvan@gmail.com',
      token: '',
    );
  });
  test('should be a subtype of User', () {
    expect(userModel, isA<User>());
  });
  test(
    'fromjson method should be able to convert a json to UserModel',
    () {
      String jsonUser = jsonEncode({
        "username": "safvan",
        "email": "safvan@gmail.com",
        "token": "",
      });
      UserModel user = UserModel.fromJson(jsonUser);
      expect(user, userModel);
    },
  );
  test(
    'fromApiJson method should be able to convert a json to UserModel',
    () {
      String jsonUser = jsonEncode({
        "user": {
          "username": "safvan",
          "email": "safvan@gmail.com",
        },
        "token": "",
      });
      UserModel user = UserModel.fromApiJson(jsonUser);
      expect(user, userModel);
    },
  );
}
