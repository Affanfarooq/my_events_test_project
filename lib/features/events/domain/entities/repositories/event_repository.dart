import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents({int page = 1, int limit = 10});
}