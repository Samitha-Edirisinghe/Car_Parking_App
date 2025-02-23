// models/parking_spot.dart
class ParkingSpot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  bool isAvailable;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    this.isAvailable = true,
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      pricePerHour: json['pricePerHour'],
      isAvailable: json['isAvailable'],
    );
  }
}
