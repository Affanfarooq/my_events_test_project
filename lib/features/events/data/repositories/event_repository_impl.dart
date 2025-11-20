import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_remote_datasource.dart';
import 'package:my_events_test_project/features/events/data/models/event_model.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final events = await remoteDataSource.getEvents(page, limit);
      return Right(events);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventDetails(String id) async {
    try {
      final event = await remoteDataSource.getEventDetails(id);
      return Right(event);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        location: event.location,
        imageUrl: event.imageUrl,
        price: event.price,
      );

      final result = await remoteDataSource.createEvent(eventModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        location: event.location,
        imageUrl: event.imageUrl,
        price: event.price,
      );

      final result = await remoteDataSource.updateEvent(eventModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    try {
      final url = await remoteDataSource.uploadImage(filePath);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
