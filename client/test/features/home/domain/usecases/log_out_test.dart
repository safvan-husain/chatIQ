import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:client/features/home/domain/usecases/log_out.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'log_out_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  late Logout logOut;
  setUp(() {
    mockHomeRepository = MockHomeRepository();
    logOut = Logout(mockHomeRepository);
  });
  test(
    'should call logOut in repository when logOut called and should return list of contacts for success',
    () async {
      when(mockHomeRepository.logOut())
          .thenAnswer((realInvocation) async => const Right(true));
      var result = await logOut.call();
      expect(result, const Right(true));
      verify(mockHomeRepository.logOut()).called(1);
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
