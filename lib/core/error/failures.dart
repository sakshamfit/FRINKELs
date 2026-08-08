import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure();

  @override
  String toString() => 'Server Failure';
}

class CacheFailure extends Failure {
  const CacheFailure();

  @override
  String toString() => 'Cache Failure';
}