import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/permission.service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationFetchViewModel extends MyBaseViewModel {
  LocationFetchViewModel(BuildContext context, this.nextPage) {
    this.viewContext = context;
  }

  bool showManuallySelection = false;
  bool showRequestPermission = false;
  Widget nextPage;
  //
  void initialise() {
    handleFetchCurrentLocation();
  }

  handleFetchCurrentLocation() async {
    final granted = await locationPermissionGetter();
    showManuallySelection = !granted;
    showRequestPermission = granted;
    notifyListeners();
    if (granted) {
      await fetchCurrentLocation();
      if (LocationService.deliveryaddress != null) {
        loadNextPage();
      }
    }

  }

  Future<bool> locationPermissionGetter() async {
    bool granted = await PermissionService.isLocationGranted();
    if (!granted) {
      final permanentlyDenied =
          await PermissionService.isLocationPermanentlyDenied();
      if (permanentlyDenied) {
        //
        toastError(
          "Permission is denied permanently, please re-enable permission from app info on your device settings. Thank you"
              .tr(),
        );
        //
        granted = await LocationService.showRequestDialog();
        if (granted) {
          granted = await Geolocator.openLocationSettings();
        }
      } else {
        granted = await LocationService.showRequestDialog();
       

        if (granted) {
          try {
            granted = await PermissionService.requestPermission();
          } catch (error) {
            granted = false;
          }
        }
      }
    }

    return granted;
  }

  void pickFromMap() async {
    //
    final granted = await locationPermissionGetter();
    if (!granted) {
      return;
    }
    dynamic result = await newPlacePicker();
    DeliveryAddress deliveryAddress = DeliveryAddress();

    if (result is PickResult) {
      PickResult locationResult = result;
      deliveryAddress.address = locationResult.formattedAddress;
      deliveryAddress.latitude = locationResult.geometry.location.lat;
      deliveryAddress.longitude = locationResult.geometry.location.lng;
      // From coordinates
      setBusy(true);
      final coordinates = new Coordinates(
        deliveryAddress.latitude,
        deliveryAddress.longitude,
      );
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      deliveryAddress.city = addresses.first.locality;
      setBusy(false);
      //
      LocationService.deliveryaddress = deliveryAddress;
      LocationService.currenctAddressSubject.add(addresses?.first);
      loadNextPage();
    } else if (result is Address) {
      Address locationResult = result;
      deliveryAddress.address = locationResult.addressLine;
      deliveryAddress.latitude = locationResult.coordinates.latitude;
      deliveryAddress.longitude = locationResult.coordinates.longitude;
      deliveryAddress.city = locationResult.locality;
      deliveryAddress.state = locationResult.adminArea;
      deliveryAddress.country = locationResult.countryName;
      //
      LocationService.deliveryaddress = deliveryAddress;
      LocationService.currenctAddressSubject.add(locationResult);
      loadNextPage();
    }
  }

  loadNextPage() {
    viewContext.nextAndRemoveUntilPage(nextPage);
  }
  //
}
