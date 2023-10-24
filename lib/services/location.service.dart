import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/widgets/bottomsheets/location_permission.bottomsheet.dart';
import 'package:location/location.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';
import 'geocoder.service.dart';

class LocationService {
  //
  static Location location = new Location();

  static bool serviceEnabled;
  static PermissionStatus _permissionGranted;
  static LocationData _locationData;
  static Address currenctAddress;
  static DeliveryAddress deliveryaddress;
  static StreamSubscription currentLocationListener;

  //
  static BehaviorSubject<Address> currenctAddressSubject =
      BehaviorSubject<Address>();
  // static Stream<Address> get currenctAddressStream =>
  //     _currenctAddressSubject.stream;

  static Future<void> prepareLocationListener() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //
      bool requestPermission = true;
      if (!Platform.isIOS) {
        requestPermission = await showRequestDialog();
      }
      if (requestPermission) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _startLocationListner();
  }

  static Future<bool> showRequestDialog() async {
    //
    var requestResult = false;
    //
    await showDialog(
      context: AppService().navigatorKey.currentContext,
      builder: (context) {
        return LocationPermissionDialog(onResult: (result) {
          requestResult = result;
        });
      },
    );

    //
    return requestResult;
  }

  static void _startLocationListner() async {
    //
    //update location every 100meters
    await location.changeSettings(distanceFilter: 50);

    //listen
    currentLocationListener =
        location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      _locationData = currentLocation;
      //
      geocodeCurrentLocation(true);
    });

    //get the current location on send to listeners
    _locationData = await location.getLocation();
    geocodeCurrentLocation();
  }

  //
  static geocodeCurrentLocation([bool closeListener = false]) async {
    if (_locationData != null) {
      final coordinates = new Coordinates(
        _locationData.latitude,
        _locationData.longitude,
      );

      try {
        //
        final addresses = await GeocoderService().findAddressesFromCoordinates(
          coordinates,
        );
        //
        currenctAddress = addresses.first;
        //
        currenctAddressSubject.add(currenctAddress);
      } catch (error) {
        print("Error get location ==> $error");
      }
    }

    //
    if (closeListener) {
      print("Location listener closed");
      currentLocationListener?.cancel();
    }
  }

  //coordinates to address
  static Future<Address> addressFromCoordinates({
    @required double lat,
    @required double lng,
  }) async {
    Address address;
    final coordinates = new Coordinates(
      lat,
      lng,
    );

    try {
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      //
      address = addresses.first;
    } catch (error) {
      print("Issue with addressFromCoordinates ==> $error");
    }
    return address;
  }
}
