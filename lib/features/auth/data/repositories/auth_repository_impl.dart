import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_events_test_project/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final token = await remoteDataSource.login(email, password);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register(String email, String password) async {
    try {
      final token = await remoteDataSource.register(email, password);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}