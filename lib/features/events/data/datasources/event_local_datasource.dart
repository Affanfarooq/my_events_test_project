import 'package:hive/hive.dart';
import 'package:my_events_test_project/features/events/data/models/event_model.dart';

abstract class EventLocalDataSource {
  Future<List<EventModel>> getCachedEvents();
  Future<void> cacheEvents(List<EventModel> events);
  Future<EventModel?> getCachedEventById(String id);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final String _boxName = 'events_box';

  @override
  Future<List<EventModel>> getCachedEvents() async {
    final box = await Hive.openBox<EventModel>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    final box = await Hive.openBox<EventModel>(_boxName);
    await box.clear();
    await box.addAll(events);
  }


  @override
  Future<EventModel?> getCachedEventById(String id) async {
    final box = await Hive.openBox<EventModel>(_boxName);
    try {
      return box.values.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}