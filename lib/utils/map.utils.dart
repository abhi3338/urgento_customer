import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  //
  static targetBounds(LatLng locNE, LatLng locSW) {
    var nLat, nLon, sLat, sLon;

    if (locSW.latitude <= locNE.latitude) {
      sLat = locSW.latitude;
      nLat = locNE.latitude;
    } else {
      sLat = locNE.latitude;
      nLat = locSW.latitude;
    }
    if (locSW.longitude <= locNE.longitude) {
      sLon = locSW.longitude;
      nLon = locNE.longitude;
    } else {
      sLon = locNE.longitude;
      nLon = locSW.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    );
  }
}
