import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart' as CloudFirestore;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuodz/constants/app_ui_sizes.dart';
import 'package:fuodz/models/vehicle_type.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/views/shared/payment_method_selection.page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import "package:velocity_x/velocity_x.dart";

class NewTaxiOrderSummaryViewModel extends MyBaseViewModel {
  //
  NewTaxiOrderSummaryViewModel(BuildContext context, this.taxiViewModel) {
    this.viewContext = context;
  }

  TaxiRequest taxiRequest = TaxiRequest();
  GeocoderService geocoderService = GeocoderService();
  final TaxiViewModel taxiViewModel;
  PanelController panelController = PanelController();
  double customViewHeight = AppUISizes.taxiNewOrderSummaryHeight;

  Set<Marker> gMapMarkers = new Set<Marker>();
  List<VehicleType> vehicleTypes = [];

  initialise() async {
    vehicleTypes = await taxiRequest.getVehicleTypes();
    retrieveNearByDrivers();
  }

  Future<void> retrieveNearByDrivers() async {
    setBusyForObject(gMapMarkers, true);
    Position currentLocation = await Geolocator.getCurrentPosition();
    if (currentLocation == null) {
      currentLocation = await Geolocator.getLastKnownPosition();
    }

    if (currentLocation != null) {
      var querySnapshot = await CloudFirestore.FirebaseFirestore.instance.collection("drivers").get();
      for (int i = 0; i < querySnapshot.size; i++) {
        final itemData = querySnapshot.docs[i].data();
        print("Drivers: ${itemData}");
        if (itemData.isNotEmpty) {
          bool isDriverOnline = false;
          if (itemData.containsKey('online')) {
            isDriverOnline = itemData['online'] == 1;
            if (isDriverOnline) {
              double latitude = 0.0;
              if (itemData.containsKey('lat') && itemData['lat'] != null) {
                latitude = itemData['lat'];
              }

              double longitude = 0.0;
              if (itemData.containsKey('long') && itemData['long'] != null) {
                longitude = itemData['long'];
              }

              int vehicle_type_id = 0;
              if (itemData.containsKey('vehicle_type_id') && itemData['vehicle_type_id'] != null) {
                vehicle_type_id = itemData['vehicle_type_id'];
              }

              if (latitude > 0.0 && longitude > 0.0) {
                LatLng latLng = new LatLng(latitude, longitude);
                var distanceCalculator = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, latLng.latitude, latLng.longitude) / 1000;
                if (distanceCalculator <= 10) {
                  int searchVehicleIndex = vehicleTypes.indexWhere((element) => element.id == vehicle_type_id);
                  if (searchVehicleIndex != -1) {
                    if (vehicleTypes[searchVehicleIndex].photo != null && vehicleTypes[searchVehicleIndex].photo.trim().isNotEmpty) {
                      Uint8List byteData = (await NetworkAssetBundle(Uri.parse(vehicleTypes[searchVehicleIndex].photo))
                          .load(vehicleTypes[searchVehicleIndex].photo))
                          .buffer
                          .asUint8List();

                      ui.Codec codec = await ui.instantiateImageCodec(byteData, targetWidth: 120);
                      ui.FrameInfo fi = await codec.getNextFrame();
                      Uint8List newByteData = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
                      gMapMarkers.add(new Marker(markerId: MarkerId(i.toString()), draggable: false, position: LatLng(currentLocation.latitude, currentLocation.longitude), icon: BitmapDescriptor.fromBytes(newByteData)));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    setBusyForObject(gMapMarkers, false);
  }

  //
  updateLoadingheight() {
    customViewHeight = AppUISizes.taxiNewOrderHistoryHeight;
    notifyListeners();
  }

  resetStateViewheight([double height = 0]) {
    customViewHeight = AppUISizes.taxiNewOrderIdleHeight + height;
    notifyListeners();
  }

  closePanel() async {
    clearFocus();
    await panelController.close();
    notifyListeners();
  }

  clearFocus() {
    FocusScope.of(taxiViewModel.viewContext).requestFocus(new FocusNode());
  }

  openPanel() async {
    await panelController.open();
    notifyListeners();
  }

  void openPaymentMethodSelection() async {
    //
    if (taxiViewModel.paymentMethods == null ||
        taxiViewModel.paymentMethods.isEmpty) {
      await taxiViewModel.fetchTaxiPaymentOptions();
    }
    final mPaymentMethod = await viewContext.push(
          (context) => PaymentMethodSelectionPage(
        list: taxiViewModel.paymentMethods,
      ),
    );
    if (mPaymentMethod != null) {
      taxiViewModel.changeSelectedPaymentMethod(
        mPaymentMethod,
        callTotal: false,
      );
    }

    notifyListeners();
  }


}