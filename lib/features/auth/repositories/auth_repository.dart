
import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';

abstract class AuthRepository {
  // Login: Returns Failure or Token (String)
  Future<Either<Failure, String>> login(String email, String password);
  
  // Register: Returns Failure or Token (String)
  Future<Either<Failure, String>> register(String email, String password);
}