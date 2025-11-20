import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:hive/hive.dart';
part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends EventEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final String imageUrl;
  @HiveField(6)
  final String price;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
  }) : super(
         id: id,
         title: title,
         description: description,
         date: date,
         location: location,
         imageUrl: imageUrl,
         price: price,
       );

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
