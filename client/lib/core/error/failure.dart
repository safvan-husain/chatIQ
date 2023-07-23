import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List propertice = const <dynamic>[]]);
}

//General failures
class ServerFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object?> get props => [];
}
