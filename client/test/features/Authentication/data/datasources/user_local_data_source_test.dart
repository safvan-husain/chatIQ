import 'package:client/features/Authentication/data/datasources/user_local_data_source.dart';
import 'package:client/features/Authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late UserLocalDataSource localDataSource;
  late MockSharedPreferences mockSharedPreferences;
  UserModel usermodel = const UserModel(username: '', email: '', token: '');

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource =
        UserLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
  test(
    'should return User from local data source',
    () async {
      when(mockSharedPreferences.getString('user'))
          .thenAnswer((realInvocation) => usermodel.toJson());
      final user = await localDataSource.getUser();
      expect(user, usermodel);
      verify(mockSharedPreferences.getString('user'));
      verifyNoMoreInteractions(mockSharedPreferences);
    },
  );
  test(
    'should call setString when cacheUser called',
    () async {
      when(mockSharedPreferences.setString('user', usermodel.toJson()))
          .thenAnswer((realInvocation) async => true);
      await localDataSource.cacheUser(usermodel);
      verify(mockSharedPreferences.setString('user', usermodel.toJson()));
      verifyNoMoreInteractions(mockSharedPreferences);
    },
  );
}
