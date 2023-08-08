import 'package:client/common/entity/message.dart';
import 'package:client/features/home/data/models/user_model.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../datasources/home_local_data_source_test.mocks.dart';

@GenerateMocks([Message])
void main() {
  late UserModel userModel;
  late Message message;
  setUp(() {
    message = MockMessage();
    userModel = UserModel(
      username: 'safvan',
      lastMessage: message,
      lastSeenMessageId: 2,
      id: 1,
    );
  });
  test('should be a subtype of User', () {
    expect(userModel, isA<User>());
  });
  test(
    'fromjson method should be able to convert a json to UserModel',
    () {
      String jsonUser = userModel.toJson();
      UserModel user = UserModel.fromJson(jsonUser, message);
      expect(user, userModel);
    },
  );
}
