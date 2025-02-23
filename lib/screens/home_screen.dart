import 'package:car_parking_app/models/parking_spot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/parking_service.dart';
import 'map_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ParkingSpot>> _parkingSpotsFuture;

  @override
  void initState() {
    super.initState();
    _parkingSpotsFuture =
        context.read<ParkingService>().getNearbyParkingSpots(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Parking Spots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () async {
              if (!mounted) return;
              final currentContext = context;
              final parkingService = currentContext.read<ParkingService>();
              final spots = await parkingService.getNearbyParkingSpots(0, 0);
              if (!mounted) return;
              Navigator.push(
                currentContext,
                MaterialPageRoute(
                  builder: (context) => MapScreen(parkingSpots: spots),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: FutureBuilder<List<ParkingSpot>>(
        future: _parkingSpotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final parkingSpots = snapshot.data!;
          return ListView.builder(
            itemCount: parkingSpots.length,
            itemBuilder: (context, index) {
              final spot = parkingSpots[index];
              return ListTile(
                title: Text(spot.name),
                subtitle: Text('\$${spot.pricePerHour}/hour'),
                trailing: spot.isAvailable
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(parkingSpot: spot),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
