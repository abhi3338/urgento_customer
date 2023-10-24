import 'package:geolocator/geolocator.dart';

class PermissionService {
  static Future<bool> isLocationGranted() async {
    var status = await Geolocator.checkPermission();
    return (status == LocationPermission.whileInUse) ||
        (status == LocationPermission.always);
  }

  static Future<bool> isLocationDenied() async {
    var status = await Geolocator.checkPermission();
    return status == LocationPermission.denied;
  }

  static Future<bool> isLocationPermanentlyDenied() async {
    var status = await Geolocator.checkPermission();
    return status == LocationPermission.deniedForever;
  }

  static Future<bool> requestPermission() async {
    var status = await Geolocator.requestPermission();
    if (status == LocationPermission.deniedForever) {
      throw LocationPermission;
    }
    return (status == LocationPermission.whileInUse) ||
        (status == LocationPermission.always);
  }
}
