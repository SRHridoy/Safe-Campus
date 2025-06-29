import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationTestScreen extends StatefulWidget {
  const LocationTestScreen({Key? key}) : super(key: key);

  @override
  State<LocationTestScreen> createState() => _LocationTestScreenState();
}

class _LocationTestScreenState extends State<LocationTestScreen> {
  Map<String, dynamic>? _locationData;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getLocation(); // Auto-call on screen load
  }

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final data = await LocationService().getUserLocation();
    setState(() {
      _loading = false;
      if (data.containsKey('error')) {
        _error = data['error'];
        _locationData = null;
      } else {
        _locationData = data;
      }
    });
  }

  void _openInGoogleMaps() {
    if (_locationData != null &&
        _locationData!['latitude'] != null &&
        _locationData!['longitude'] != null) {
      final lat = _locationData!['latitude'];
      final lng = _locationData!['longitude'];
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Test'),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFFB2FF59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 64, color: Colors.green[800]),
                  const SizedBox(height: 16),
                  Text(
                    'Your Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: _getLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Get Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ] else if (_locationData != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        Text('Latitude: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_locationData!['latitude']}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        Text('Longitude: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_locationData!['longitude']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_city, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        Text('City: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_locationData!['city'] ?? 'Unknown'}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flag, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        Text('Country: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_locationData!['country'] ?? 'Unknown'}'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _openInGoogleMaps,
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Open in Google Maps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
