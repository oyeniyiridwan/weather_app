import 'package:geolocator/geolocator.dart';
import 'package:weather_app/app/app.logger.dart';
import 'package:weather_app/model/weather_model.dart';

class LocationService {
  final log = getLogger('location service');
  bool hasPermission = false;
  LocationService() {
    checkForPermission();
  }

  Future<bool> checkForPermission() async {
    log.i('locationService initialised');
    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      await Geolocator.openLocationSettings();
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        hasPermission = true;
      }
      return hasPermission;
    } else {
      hasPermission = true;
    }
    return hasPermission;
  }

  Future<Coord> getCoordinate() async {
    var position = await Geolocator.getCurrentPosition();
    return Coord(lat: position.latitude, lon: position.longitude);
  }
}
