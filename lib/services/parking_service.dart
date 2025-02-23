// services/parking_service.dart
import '../models/parking_spot.dart';

class ParkingService {
  Future<List<ParkingSpot>> getNearbyParkingSpots(
      double lat, double lng) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return a list of 5 predefined parking spots
    return [
      ParkingSpot(
        id: '1',
        name: 'Downtown Parking',
        latitude: 37.7749,
        longitude: -122.4194,
        pricePerHour: 5.0,
        isAvailable: true,
      ),
      ParkingSpot(
        id: '2',
        name: 'City Center Garage',
        latitude: 37.7849,
        longitude: -122.4294,
        pricePerHour: 7.5,
        isAvailable: true,
      ),
      ParkingSpot(
        id: '3',
        name: 'Main Street Lot',
        latitude: 37.7649,
        longitude: -122.4094,
        pricePerHour: 4.0,
        isAvailable: false,
      ),
      ParkingSpot(
        id: '4',
        name: 'Riverside Parking',
        latitude: 37.7549,
        longitude: -122.4394,
        pricePerHour: 6.0,
        isAvailable: true,
      ),
      ParkingSpot(
        id: '5',
        name: 'Harbor View Garage',
        latitude: 37.7749,
        longitude: -122.4494,
        pricePerHour: 8.0,
        isAvailable: true,
      ),
    ];
  }

  Future<bool> reserveSpot(String spotId) async {
    // Implement reservation logic
    return true;
  }

  Future<bool> processPayment(double amount) async {
    // Implement payment processing
    return true;
  }
}
