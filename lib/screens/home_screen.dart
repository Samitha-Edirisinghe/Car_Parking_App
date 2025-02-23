import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../models/parking_spot.dart';
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
  Future<List<ParkingSpot>>? _parkingSpotsFuture;

  @override
  void initState() {
    super.initState();
    _initializeParkingData();
  }

  void _initializeParkingData() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _parkingSpotsFuture = Provider.of<ParkingService>(
            context,
            listen: false,
          ).getNearbyParkingSpots(0, 0);
        });
      }
    });
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() {
      _parkingSpotsFuture = Provider.of<ParkingService>(
        context,
        listen: false,
      ).getNearbyParkingSpots(0, 0);
    });
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
              final parkingService = context.read<ParkingService>();
              try {
                final spots = await parkingService.getNearbyParkingSpots(0, 0);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(parkingSpots: spots),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading map: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: _parkingSpotsFuture == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<List<ParkingSpot>>(
                future: _parkingSpotsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Error loading parking spots'),
                          ElevatedButton(
                            onPressed: _refreshData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
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
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingScreen(parkingSpot: spot),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
