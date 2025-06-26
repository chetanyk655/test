import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:event_app/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _pickedAddress;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    final locationData = await location.getLocation();
    final lat = locationData.latitude!;
    final lng = locationData.longitude!;

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";

        setState(() {
          _pickedAddress = address;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("📍 Location Found: $address"),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.blueAccent,
          ),
        );
      }
    } catch (error) {
      setState(() {
        _pickedAddress = "Address not found";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("❌ Error fetching address"),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const MapScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _pickedAddress = result['address'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("📍 Location Selected: ${result['address']}"),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/subtle_pattern.png"), // Single background image
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text("Select Location"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_pickedAddress != null)
                        Card(
                          color: Colors.blue.shade50,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.blue, size: 30),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _pickedAddress!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.my_location),
                                    label: const Text("Use Current Location"),
                                    onPressed: _getCurrentLocation,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                      textStyle: const TextStyle(fontSize: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.map),
                                    label: const Text("Pick Location on Map"),
                                    onPressed: _selectOnMap,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade500,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                      textStyle: const TextStyle(fontSize: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
