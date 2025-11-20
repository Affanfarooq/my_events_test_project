import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String price;
  final int attendeeCount;
  final bool isFavorite;
  final String organizerName;
  final double latitude;
  final double longitude;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    this.attendeeCount = 0,
    this.isFavorite = false,
    this.organizerName = "Event Organizer",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  @override
  List<Object?> get props => [id, title, description, date, location, imageUrl, price, attendeeCount, isFavorite];
}