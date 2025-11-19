
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.location,
    required super.imageUrl,
    required super.price,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'].toString()) ?? DateTime.now(),
      location: json['location'] ?? 'Unknown City',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      price: json['price'].toString(),
    );
  }
}