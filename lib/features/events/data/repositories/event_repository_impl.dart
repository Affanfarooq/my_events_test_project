import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_remote_datasource.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/entities/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({int page = 1, int limit = 10}) async {
    try {
      final events = await remoteDataSource.getEvents(page, limit);
      return Right(events);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}