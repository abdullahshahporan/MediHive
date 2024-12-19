import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = false;

  final String _googleApiKey = 'AIzaSyA3KP1kyVmShHUoei0xZhy0J6RNUiHiEBg';
  final List<String> _keywords = ['hospital', 'clinic', 'diagnostic center', 'medical college'];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorSnackbar('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        _showErrorSnackbar('Location permissions are denied.');
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    _fetchNearbyPlaces();
  }

  /// Fetch nearby hospitals, clinics, etc.
  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoading = true;
    });

    final double lat = _currentPosition!.latitude;
    final double lng = _currentPosition!.longitude;
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$lat,$lng&radius=2500&key=$_googleApiKey';

    try {
      for (final keyword in _keywords) {
        String nextPageToken = '';
        do {
          final url = Uri.parse(
              '$baseUrl&keyword=$keyword${nextPageToken.isNotEmpty ? '&pagetoken=$nextPageToken' : ''}');
          final response = await http.get(url);

          if (response.statusCode != 200) {
            throw Exception('Failed to fetch places: ${response.reasonPhrase}');
          }

          final Map<String, dynamic> data = json.decode(response.body);
          final results = (data['results'] as List).cast<Map<String, dynamic>>();

          for (final place in results) {
            final location = place['geometry']['location'];
            final LatLng position = LatLng(location['lat'], location['lng']);
            final String name = place['name'] ?? 'Unknown';
            final String address = place['vicinity'] ?? 'No address available';

            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: address,
                ),
              ),
            );
          }

          nextPageToken = data['next_page_token'] ?? '';
          if (nextPageToken.isNotEmpty) {
            await Future.delayed(const Duration(seconds: 2));
          }
        } while (nextPageToken.isNotEmpty);
      }

      setState(() {
        _isLoading = false;
      });

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat, lng),
          15,
        ),
      );
    } catch (e) {
      _showErrorSnackbar('Error fetching places: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show error message
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Center the map to the user's current location
  void _centerToUserLocation() {
    if (_currentPosition != null) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Navigate back to the previous screen
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Google Map
            _currentPosition == null
                ? const Center(child: CircularProgressIndicator(color: Colors.red))
                : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 15,
              ),
              onMapCreated: (controller) => _controller = controller,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),

            // Floating Action Button to Center Map
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _centerToUserLocation,
                backgroundColor: Colors.grey.shade100,
                child: const Icon(Icons.my_location, color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
