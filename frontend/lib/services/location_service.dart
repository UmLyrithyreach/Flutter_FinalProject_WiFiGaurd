import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }
}
