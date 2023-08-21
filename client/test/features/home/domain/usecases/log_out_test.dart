import 'package:client/features/home/domain/repositories/home_repositoy.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'log_out_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  setUp(() {
    mockHomeRepository = MockHomeRepository();
  });
  
}
