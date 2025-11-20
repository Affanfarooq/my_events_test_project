import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents({int page = 1, int limit = 10});
  Future<Either<Failure, EventEntity>> getEventDetails(String id);
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event);
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event);
  Future<Either<Failure, String>> uploadImage(String filePath);
}