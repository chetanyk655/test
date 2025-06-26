import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  String? _pickedAddress;

  Future<void> _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      _pickedAddress = "Fetching address...";
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
        setState(() {
          _pickedAddress = address;
        });
      }
    } catch (error) {
      print('Error in reverse geocoding: $error');
      setState(() {
        _pickedAddress = "Address not found";
      });
    }
  }

  void _savePickedLocation() {
    if (_pickedLocation == null || _pickedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on the map.")),
      );
      return;
    }

    Navigator.of(context).pop({
      'latitude': _pickedLocation!.latitude,
      'longitude': _pickedLocation!.longitude,
      'address': _pickedAddress!,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePickedLocation,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(19.0760, 72.8777), // Default to Mumbai
          zoom: 16,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation!,
                ),
              },
      ),
    );
  }
}
