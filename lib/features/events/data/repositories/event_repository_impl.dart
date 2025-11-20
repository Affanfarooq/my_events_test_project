import 'package:dartz/dartz.dart';
import 'package:my_events_test_project/app/core/errors/failures.dart';
import 'package:my_events_test_project/app/core/network/network_info.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_local_datasource.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_remote_datasource.dart';
import 'package:my_events_test_project/features/events/data/models/event_model.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getEvents(page, limit);
        if (page == 1) {
          await localDataSource.cacheEvents(remoteEvents);
        }
        return Right(remoteEvents);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localEvents = await localDataSource.getCachedEvents();
        if (localEvents.isEmpty) {
          return const Left(CacheFailure('No internet and no cached data'));
        }
        return Right(localEvents);
      } catch (e) {
        return const Left(CacheFailure('Error loading cache'));
      }
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventDetails(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.getEventDetails(id);
        return Right(event);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localEvent = await localDataSource.getCachedEventById(id);
        if (localEvent != null) {
          return Right(localEvent);
        } else {
          return const Left(CacheFailure("Event not found in cache"));
        }
      } catch (e) {
        return const Left(CacheFailure("Error accessing local storage"));
      }
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    if (!await networkInfo.isConnected) {
      return const Left(ServerFailure("No Internet Connection"));
    }
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        location: event.location,
        imageUrl: event.imageUrl,
        price: event.price,
        attendeeCount: event.attendeeCount, 
        isFavorite: event.isFavorite,       
        organizerName: event.organizerName, 
        latitude: event.latitude,           
        longitude: event.longitude,         
      );

      final result = await remoteDataSource.createEvent(eventModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    if (!await networkInfo.isConnected) {
      return const Left(ServerFailure("No Internet Connection"));
    }
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        location: event.location,
        imageUrl: event.imageUrl,
        price: event.price,
        attendeeCount: event.attendeeCount, 
        isFavorite: event.isFavorite,       
        organizerName: event.organizerName, 
        latitude: event.latitude,           
        longitude: event.longitude,         
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