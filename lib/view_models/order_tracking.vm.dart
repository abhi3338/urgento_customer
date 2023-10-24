import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderTrackingViewModel extends MyBaseViewModel {
  //
  Order order;
  GoogleMapController controller;
  Set<Marker> mapMarkers;
  LatLng pickupLatLng;
  LatLng destinationLatLng;
  LatLng driverLatLng;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  //
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription driverLocationStream;

  //
  OrderTrackingViewModel(BuildContext context, this.order) {
    this.viewContext = context;
  }

  //
  void setMapController(GoogleMapController mController) {
    controller = mController;
    notifyListeners();

    //zoom map camera to bound
    zoomToLatLngBound();
  }

  //
  initialise() async {
    //vendor location marker
    mapMarkers = new Set<Marker>();

    //pickup address
    final vendorIcon = await markerIcon(
      order.isPackageDelivery ? AppImages.addressPin : AppImages.vendor,
    );
    mapMarkers.add(
      Marker(
        markerId: MarkerId("pickup"),
        position: pickupLatLng = LatLng(
            order.isPackageDelivery
                ? order.pickupLocation.latitude
                : double.parse(order.vendor.latitude),
            order.isPackageDelivery
                ? order.pickupLocation.longitude
                : double.parse(order.vendor.longitude)),
        infoWindow: InfoWindow(
          title: order.isPackageDelivery
              ? order.pickupLocation.name
              : order.vendor.name,
        ),
        icon: vendorIcon,
      ),
    );

    //delivery address
    final deliveryAddressIcon = await markerIcon(AppImages.deliveryParcel);
    mapMarkers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: destinationLatLng = LatLng(
          order.isPackageDelivery
              ? order.dropoffLocation.latitude
              : order.deliveryAddress.latitude,
          order.isPackageDelivery
              ? order.dropoffLocation.longitude
              : order.deliveryAddress.longitude,
        ),
        infoWindow: InfoWindow(
          title: order.isPackageDelivery
              ? order.dropoffLocation.name
              : order.deliveryAddress.name,
        ),
        icon: deliveryAddressIcon,
      ),
    );

    //
    notifyListeners();
    zoomToLatLngBound();
    getPolyline();
    listenToDriverLocation();
  }

  dispose() {
    super.dispose();
    if (driverLocationStream != null) {
      driverLocationStream.cancel();
    }
  }

  //
  zoomToLatLngBound() {
    if (controller != null &&
        destinationLatLng != null &&
        driverLatLng != null &&
        mapMarkers != null) {
      //
      LatLngBounds bound = boundsFromLatLngList(
        [driverLatLng, destinationLatLng],
      );

      //
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(bound, 80),
      );
    }
  }

  //
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  //
  void getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppStrings.googleMapApiKey,
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(destinationLatLng.latitude, destinationLatLng.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    //
    addPolyLine(polylineCoordinates);
  }

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      color: AppColor.primaryColor,
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  //listen to drriver location
  void listenToDriverLocation() {
    //
    driverLocationStream = firebaseFirestore
        .collection("drivers")
        .doc("${order.driverId}")
        .snapshots()
        .listen((event) async {
      //

      print("listening for driver location: ${event.data()}");
      var driverMarker = mapMarkers.firstWhere(
              (e) => e.markerId.value.contains("driverLocation"),
          orElse: () => null);

      //
      final driverInfo = event.data();
      driverLatLng = LatLng(
        driverInfo["lat"] ?? 0.00,
        driverInfo["long"] ?? 0.00,
      );

      //
      if (driverMarker == null) {
        //
        final driverLocationIcon = await markerIcon(AppImages.deliveryBoy);
        driverMarker = Marker(
          markerId: MarkerId("driverLocation"),
          position: driverLatLng,
          infoWindow: InfoWindow.noText,
          icon: driverLocationIcon,
        );
        pickupLatLng = driverLatLng;
        getPolyline();
      } else {
        //remove the old one
        mapMarkers.remove(driverMarker);
        //
        driverMarker = driverMarker.copyWith(
          positionParam: driverLatLng,
        );
        pickupLatLng = driverLatLng;
        getPolyline();
      }

      //adding to list
      mapMarkers.add(driverMarker);
      //
      notifyListeners();
      zoomToLatLngBound();
    });
  }

  //
  Future<BitmapDescriptor> markerIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 1.1, size: Size(24, 24)),
      assetPath,
    );
  }

  void callDriver() {
    launchUrlString("tel:${order.driver.phone}");
  }
}