import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng _pickedLocation = const LatLng(0, 0);
  late GoogleMapController _controller;

  // Custom map style JSON string
  final String _mapStyle = '''
  [
    // Your custom map style JSON here
  ]
  ''';

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });

    // Optionally, set a custom map style
    _controller.setMapStyle(_mapStyle);
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Center the map at a default location
          zoom: 15.0,
        ),
        scrollGesturesEnabled: true, // Enable scroll gestures
        zoomGesturesEnabled: true, // Enable zoom gestures
        markers: _pickedLocation == const LatLng(0, 0)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('picked_location'),
                  position: _pickedLocation,
                ),
              },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something with the picked location
          Navigator.of(context).pop(_pickedLocation);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
