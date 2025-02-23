// screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/parking_spot.dart';

class MapScreen extends StatefulWidget {
  final List<ParkingSpot> parkingSpots;

  const MapScreen({super.key, required this.parkingSpots});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 14,
        ),
        markers: _createMarkers(),
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return widget.parkingSpots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: '\$${spot.pricePerHour}/hour',
        ),
      );
    }).toSet();
  }
}
