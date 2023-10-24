import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/utils/map.utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiTripMapPreview extends StatefulWidget {
  TaxiTripMapPreview(this.order, {Key key}) : super(key: key);

  final Order order;
  @override
  State<TaxiTripMapPreview> createState() => _TaxiTripMapPreviewState();
}

class _TaxiTripMapPreviewState extends State<TaxiTripMapPreview> {
  //
  List<Marker> markers = [];
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: GoogleMap(
        zoomControlsEnabled: false,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        markers: Set.of(markers),
        initialCameraPosition: CameraPosition(
          target: widget.order?.taxiOrder?.pickupLatLng,
          zoom: 16,
        ),
        cameraTargetBounds: CameraTargetBounds(
          MapUtils.targetBounds(
            widget.order?.taxiOrder?.pickupLatLng,
            widget.order?.taxiOrder?.dropoffLatLng,
          ),
        ),
        onMapCreated: setLocMarkers,
      ),
    );
  }

  setLocMarkers(GoogleMapController gMapController) async {
    await setGoogleMapStyle(gMapController);
    markers = [];
    markers = await getLocMakers();
    //
    setState(() {
      markers = markers;
    });

    //zoom to bound
    gMapController.moveCamera(
      CameraUpdate.newLatLngBounds(
        MapUtils.targetBounds(
          widget.order?.taxiOrder?.pickupLatLng,
          widget.order?.taxiOrder?.dropoffLatLng,
        ),
        40,
      ),
    );
  }

  void setGoogleMapStyle(gMapController) async {
    String value = await DefaultAssetBundle.of(context).loadString(
      'assets/json/google_map_style.json',
    );
    //
    gMapController?.setMapStyle(value);
  }

  //
  Future<List<Marker>> getLocMakers() async {
    BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.pickupLocation,
    );
    //
    BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.dropoffLocation,
    );
    //
    //
    Marker pickupLocMarker = Marker(
      markerId: MarkerId(widget.order?.taxiOrder?.pickupLatitude),
      position: widget.order?.taxiOrder?.pickupLatLng,
      icon: sourceIcon,
    );
    //
    Marker dropoffLocMarker = Marker(
      markerId: MarkerId(widget.order?.taxiOrder?.id.toString()),
      position: widget.order?.taxiOrder?.dropoffLatLng,
      icon: destinationIcon,
    );
    //
    return [pickupLocMarker, dropoffLocMarker];
  }
}
