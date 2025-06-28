import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request location permission and return the user location with city and country.
  Future<Map<String,dynamic>> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) {
      // Location services are not enabled, return an error
      return {'error': 'Location services are disabled.'};
    }

    //check for location permission
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        // Permissions are denied, return an error
        return {'error': 'Location permissions are denied.'};
      }
    }

    if(permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, return an error
      return {'error': 'Location permissions are permanently denied, we cannot request permissions.'};
    }

    // Get the current position
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      //Convert position to a map with city and country
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if(placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        //Testing:
        print(placemarks[0]);
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'city': place.locality ?? 'Unknown',
          'country': place.country ?? 'Unknown',
        };
      } else {
        return {'error': 'No placemarks found for the current location.'};
      }

    }catch(e) {
      // Handle any errors that occur during the location retrieval
      return {'error': 'Failed to get location: $e'};
    }
  }
}