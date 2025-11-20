import 'package:hive/hive.dart';
import 'dart:math';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart'; 
part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends EventEntity {
  @override
  @HiveField(0) final String id;
  @override
  @HiveField(1) final String title;
  @override
  @HiveField(2) final String description;
  @override
  @HiveField(3) final DateTime date;
  @override
  @HiveField(4) final String location;
  @override
  @HiveField(5) final String imageUrl;
  @override
  @HiveField(6) final String price;
  @override
  @HiveField(7) final int attendeeCount;
  @override
  @HiveField(8) final bool isFavorite;
  @override
  @HiveField(9) final String organizerName;
  @override
  @HiveField(10) final double latitude;
  @override
  @HiveField(11) final double longitude;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.attendeeCount,
    required this.isFavorite,
    required this.organizerName,
    required this.latitude,
    required this.longitude,
  }) : super(
          id: id,
          title: title,
          description: description,
          date: date,
          location: location,
          imageUrl: imageUrl,
          price: price,
          attendeeCount: attendeeCount,
          isFavorite: isFavorite,
          organizerName: organizerName,
          latitude: latitude,
          longitude: longitude,
        );

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final random = Random();
    
    return EventModel(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'].toString()) ?? DateTime.now(),
      location: json['location'] ?? 'Unknown City',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      price: json['price'].toString(),
      attendeeCount: json['attendeeCount'] ?? random.nextInt(500) + 10, 
      isFavorite: json['isFavorite'] ?? random.nextBool(),
      organizerName: "John Doe",
      latitude: 24.8607, 
      longitude: 67.0011, 
    );
  }
}