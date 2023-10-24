import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/vehicle_type.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/services/toast.service.dart';
import 'package:fuodz/view_models/taxi_google_map.vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supercharged/supercharged.dart';

class TripTaxiViewModel extends TaxiGoogleMapViewModel {
//requests
  TaxiRequest taxiRequest = TaxiRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
//
  Order onGoingOrderTrip;
  double newTripRating = 3.0;
  TextEditingController tripReviewTEC = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription tripUpdateStream;
  StreamSubscription driverLocationStream;

  LatLng driverPosition;
  double driverPositionRotation = 0;

  //
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod selectedPaymentMethod;

  //vheicle types
  List<VehicleType> vehicleTypes = [];
  VehicleType selectedVehicleType;

//get current on going trip
  void getOnGoingTrip() async {
    //
    setBusyForObject(onGoingOrderTrip, true);
    try {
      onGoingOrderTrip = await taxiRequest.getOnGoingTrip();
      futureGoingTrip = taxiRequest.getOnGoingTrip();
      loadTripUIByOrderStatus(initial: true);
    } catch (error) {
      print("trip ongoing error ==> $error");
    }
    setBusyForObject(onGoingOrderTrip, false);
  }

  Future<Order> futureGoingTrip;

  //cancel trip
  void cancelTrip() async {
    //
    setBusyForObject(onGoingOrderTrip, true);
    try {
      final apiResponse = await taxiRequest.cancelTrip(onGoingOrderTrip.id);
      //
      if (apiResponse.allGood) {
        toastSuccessful(apiResponse.message);
        vehicleSearchTimer.cancel();
        vehicleSearchTimer = null;
        setCurrentStep(1);
        clearMapData();
      } else {
        toastError(apiResponse.message);
      }
    } catch (error) {
      print("trip ongoing error ==> $error");
    }
    setBusyForObject(onGoingOrderTrip, false);
  }

  //
  loadTripUIByOrderStatus({bool initial = false}) {
    //
    //
    if (onGoingOrderTrip != null && (initial || pickupLocation == null)) {
      //
      pickupLocation = DeliveryAddress(
        latitude: onGoingOrderTrip.taxiOrder.pickupLatitude.toDouble(),
        longitude: onGoingOrderTrip.taxiOrder.pickupLongitude.toDouble(),
        address: onGoingOrderTrip.taxiOrder.pickupAddress,
      );
      //
      dropoffLocation = DeliveryAddress(
        latitude: onGoingOrderTrip.taxiOrder.dropoffLatitude.toDouble(),
        longitude: onGoingOrderTrip.taxiOrder.dropoffLongitude.toDouble(),
        address: onGoingOrderTrip.taxiOrder.dropoffAddress,
      );
      //set the pickup and drop off locations
      drawTripPolyLines();
      startHandlingOnGoingTrip();
    } else if (onGoingOrderTrip != null) {
      switch (onGoingOrderTrip.status) {
        case "pending":
          setCurrentStep(3);
          break;
        case "preparing":
          setCurrentStep(4);
          startZoomFocusDriver();
          break;
        case "ready":
          setCurrentStep(4);
          startZoomFocusDriver();
          break;
        case "enroute":
          setCurrentStep(4);
          startZoomFocusDriver();
          break;
        case "delivered":
          setCurrentStep(6);
          clearMapData();
          zoomToLocation(
            LatLng(
              onGoingOrderTrip.taxiOrder.dropoffLatitude.toDouble(),
              onGoingOrderTrip.taxiOrder.dropoffLongitude.toDouble(),
            ),
          );
          stopAllListeners();
          break;
        case "failed":
          setCurrentStep(1);
          clearMapData();
          stopAllListeners();
          closeOrderSummary();
          break;
        case "cancelled":
          setCurrentStep(1);
          clearMapData();
          stopAllListeners();
          closeOrderSummary();
          break;
        default:
      }
    } else if (onGoingOrderTrip == null) {
      setCurrentStep(1);
      clearMapData();
      stopAllListeners();
      closeOrderSummary();
    }
  }

  // Timer vehicleSearchTimer;
  // int maxTimeInSecond = 120;
  // int currentTimeInSecond = 0;

//
  void startHandlingOnGoingTrip() async {
    //clear current UI step
    setCurrentStep(3);

    currentTimeInSecond = maxTimeInSecond;

    vehicleSearchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTimeInSecond < 1) {
        currentTimeInSecond = maxTimeInSecond;
        vehicleSearchTimer.cancel();
        vehicleSearchTimer = null;
        setCurrentStep(2);
        ToastService.toastError("None of the driver has accepted order. Please try again.");
        cancelTrip();
      } else {
        currentTimeInSecond--;
      }
      notifyListeners();
    });

    //
    //set new on trip step
    tripUpdateStream = firebaseFirestore
        .collection("orders")
        .doc("${onGoingOrderTrip.code}")
        .snapshots()
        .listen(
          (event) async {
        //once driver is assigned

        if (currentOrderStep == 6) {
          tripUpdateStream.cancel();
        } else {
          final driverId =
          event.data() != null ? event.data()["driver_id"] ?? null : null;
          if (driverId != null && onGoingOrderTrip.driverId == null) {
            onGoingOrderTrip.driverId = event.data()["driver_id"];
            onGoingOrderTrip.driver = event.data()["driver"] ?? null;
          }

          //
          if (onGoingOrderTrip.driver == null) {
            await loadDriverDetails();
          }
          startDriverDetailsListener();

          //update the rest onGoingTrip details
          if (event.exists) {
            onGoingOrderTrip?.status = event.data()["status"] ?? "failed";
          }
          //
          notifyListeners();
          loadTripUIByOrderStatus();
        }
      },
    );
    //start order details listening stream
  }

  //DRIVER SECTION
  loadDriverDetails() async {
    try {
      final mDriverId = onGoingOrderTrip.driverId;
      // onGoingOrderTrip.driver =
      //     await taxiRequest.getDriverInfo(onGoingOrderTrip.driverId);
      onGoingOrderTrip = await taxiRequest.getOnGoingTrip();
      //loop until driver data is gotten
      if (onGoingOrderTrip.driver == null) {
        onGoingOrderTrip.driver = await taxiRequest.getDriverInfo(mDriverId);
        if (onGoingOrderTrip.driver == null) {
          await Future.delayed(Duration(seconds: 5));
          loadDriverDetails();
        }
      }
      notifyListeners();
    } catch (error) {
      print("trip ongoing error ==> $error");
    }
  }

  //Start listening to driver location changes
  void startDriverDetailsListener() async {
    //
    driverLocationStream = firebaseFirestore
        .collection("drivers")
        .doc("${onGoingOrderTrip?.driverId}")
        .snapshots()
        .listen((event) {
      //
      if (!event.exists) {
        return;
      }
      //
      driverPosition = LatLng(event.data()["lat"], event.data()["long"]);
      driverPositionRotation = event.data()["rotation"] ?? 0;
      updateDriverMarkerPosition();
      startZoomFocusDriver();
    });
  }

  //
  updateDriverMarkerPosition() {
    //
    Marker driverMarker = gMapMarkers.firstWhere(
          (e) => e.markerId.value == "driverMarker",
      orElse: () => null,
    );
    //
    if (driverMarker == null) {
      driverMarker = Marker(
        markerId: MarkerId('driverMarker'),
        position: driverPosition,
        rotation: driverPositionRotation,
        icon: driverIcon,
        anchor: Offset(0.5, 0.5),
      );
      gMapMarkers.add(driverMarker);
    } else {
      driverMarker = driverMarker.copyWith(
        positionParam: driverPosition,
        rotationParam: driverPositionRotation,
      );
      gMapMarkers.removeWhere((e) => e.markerId.value == "driverMarker");
      gMapMarkers.add(driverMarker);
    }

    notifyListeners();
  }

  //
  startZoomFocusDriver() {
    //create bond between driver and
    if (driverPosition == null) {
      return;
    }
    //check status to determine the latlng bound
    if (onGoingOrderTrip.canZoomOnPickupLocation) {
      //zoom to driver and pickup latbound
      updateCameraLocation(
          driverPosition,
          LatLng(
            pickupLocation.latitude,
            pickupLocation.longitude,
          ),
          googleMapController);
    } else if (onGoingOrderTrip.canZoomOnDropoffLocation) {
      //zoom to driver and dropoff latbound
      updateCameraLocation(
          driverPosition,
          LatLng(
            dropoffLocation.latitude,
            dropoffLocation.longitude,
          ),
          googleMapController);
    }
  }

  //
  stopAllListeners() {
    tripUpdateStream?.cancel();
    driverLocationStream?.cancel();
  }

  //when trip is ended
  dismissTripRating() async {
    tripReviewTEC.clear();
    setCurrentStep(1);
    zoomToCurrentLocation();
  }

  submitTripRating() async {
    //
    setBusyForObject(newTripRating, true);
    //
    final apiResponse = await taxiRequest.rateDriver(
      onGoingOrderTrip.id,
      onGoingOrderTrip.driverId,
      newTripRating,
      tripReviewTEC.text,
    );
    //
    if (apiResponse.allGood) {
      toastSuccessful(apiResponse.message);
      dismissTripRating();
    } else {
      toastError(apiResponse.message);
    }
    setBusyForObject(newTripRating, false);
  }

  closeOrderSummary({bool clear = true}) {
    if (clear) {
      pickupLocation = null;
      dropoffLocation = null;
      pickupLocationTEC.clear();
      dropoffLocationTEC.clear();
      selectedVehicleType = null;
      selectedPaymentMethod = paymentMethods?.first ?? null;
      notifyListeners();
    }
    //
    clearMapData();
    setCurrentStep(1);
  }
}