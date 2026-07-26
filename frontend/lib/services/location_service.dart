import 'package:geolocator/geolocator.dart';

// this file only checks location permission and location service status
// it does not touch wifi at all, that is a different file

class LocationService {
  // Case A: check if app has permission to use location
  Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  // Case A: pop up android system dialog asking for permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  // Case B: check if gps/location service itself is turned on
  Future<bool> isServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  // Case B: open phone settings so user can turn on gps manually
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
