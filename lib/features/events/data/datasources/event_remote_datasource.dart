import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/features/events/domain/entities/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents(int page, int limit);
  Future<EventModel> getEventDetails(String id);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final Dio _dio = Get.find(tag: 'mockapi');

  @override
  Future<List<EventModel>> getEvents(int page, int limit) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {
          'page': page,
          'limit': limit,
          'sortBy': 'date',
          'order': 'desc',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = response.data;
        return body.map((item) => EventModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<EventModel> getEventDetails(String id) async {
    try {
      final response = await _dio.get('/events/$id');
      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      } else {
        throw Exception('Event not found');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
