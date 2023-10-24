import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:fuodz/views/pages/delivery_address/widgets/address_search.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoder/geocoder.dart';

class TaxiGoogleMapViewModel extends CheckoutBaseViewModel {
//
  int currentOrderStep = 1;
  int currentAddressSelectionStep = 1;
  bool onTrip = false;
  bool ignoreMapInteraction = false;

//MAp related variables
  CameraPosition mapCameraPosition = CameraPosition(target: LatLng(0.00, 0.00));
  GoogleMapController googleMapController;
  EdgeInsets googleMapPadding = EdgeInsets.all(10);
  StreamSubscription currentLocationListener;
  // this will hold the generated polylines
  Set<Polyline> gMapPolylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  Set<Marker> gMapMarkers = {};
  PolylinePoints polylinePoints = PolylinePoints();
// for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor driverIcon;
//END MAP RELATED VARIABLES

//step 1
  TextEditingController placeSearchTEC = TextEditingController();
  TextEditingController pickupLocationTEC = TextEditingController();
  FocusNode pickupLocationFocusNode = FocusNode();
  DeliveryAddress pickupLocation;
  TextEditingController dropoffLocationTEC = TextEditingController();
  FocusNode dropoffLocationFocusNode = FocusNode();
  DeliveryAddress dropoffLocation;

  //
  dispose() {
    super.dispose();
    if (currentLocationListener != null) {
      currentLocationListener.cancel();
    }

    pickupLocationFocusNode.dispose();
    dropoffLocationFocusNode.dispose();
  }

  void setCurrentStep(int step) {
    if (step == 4) {
      if (vehicleSearchTimer != null) {
        if (vehicleSearchTimer.isActive) {
          vehicleSearchTimer.cancel();
        }
        vehicleSearchTimer = null;
      }
    }
    currentOrderStep = step;
    onTrip = false;
    notifyListeners();
  }

  Timer vehicleSearchTimer;
  int maxTimeInSecond = 120;
  int currentTimeInSecond = 0;

  //MAP RELATED FUNCTIONS
  void updateGoogleMapPadding({double height}) {
    googleMapPadding = EdgeInsets.only(bottom: height - 20);
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    notifyListeners();
    setGoogleMapStyle();
    //start listening to user current location
    startUserLocationListener();
    setSourceAndDestinationIcons();
  }

  //
  void setGoogleMapStyle() async {
    String value = await DefaultAssetBundle.of(viewContext).loadString(
      'assets/json/google_map_style.json',
    );
    //
    googleMapController?.setMapStyle(value);
  }

  //
  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.pickupLocation,
    );
    //
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.dropoffLocation,
    );
    //
    driverIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      AppImages.driverCar,
    );
  }

  //
  void startUserLocationListener() async {
    //
    await LocationService.prepareLocationListener();
    currentLocationListener =
        LocationService.currenctAddressSubject.listen((currentAddress) {
          //
          if (!onTrip) {
            zoomToLocation(
              LatLng(
                currentAddress.coordinates.latitude,
                currentAddress.coordinates.longitude,
              ),
            );
          }
        });
  }

  //zoom to provided location
  void zoomToLocation(LatLng target, {double zoom = 16}) {
    if (googleMapController != null) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: zoom,
          ),
        ),
      );
      notifyListeners();
    }
  }

  openLocationSelector(int step, {bool showpicker = true}) async {
    //open address picker
    if (showpicker) {
      await openLocationPicker();
    }
    currentAddressSelectionStep = step;
    //
    if (currentAddressSelectionStep == 1) {
      pickupLocation = checkout.deliveryAddress;
      pickupLocationTEC.text = checkout.deliveryAddress?.address;
    } else {
      dropoffLocation = checkout.deliveryAddress;
      dropoffLocationTEC.text = checkout.deliveryAddress?.address;
    }

    //
    notifyListeners();
  }

  //
  openLocationPicker() async {
    //
    deliveryAddress = DeliveryAddress();
    checkout.deliveryAddress = null;
    //
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return AddressSearchView(
          this,
          addressSelected: (dynamic prediction) async {
            if (prediction is Prediction) {
              deliveryAddress.address = prediction.description;
              deliveryAddress.latitude = prediction.lat.toDouble();
              deliveryAddress.longitude = prediction.lng.toDouble();
              //
              checkout.deliveryAddress = deliveryAddress;
              //
              setBusy(true);
              await getLocationCityName(deliveryAddress);
              setBusy(false);
            } else if (prediction is Address) {
              deliveryAddress.address = prediction.addressLine;
              deliveryAddress.latitude = prediction.coordinates.latitude;
              deliveryAddress.longitude = prediction.coordinates.longitude;
              deliveryAddress.city = prediction.locality;
              deliveryAddress.state = prediction.adminArea;
              deliveryAddress.country = prediction.countryName;
              checkout.deliveryAddress = deliveryAddress;
            }
          },
          selectOnMap: this.showDeliveryAddressPicker,
        );
      },
    );
  }

  //
  showDeliveryAddressPicker() async {
    //
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      deliveryAddress.address = locationResult.formattedAddress;
      deliveryAddress.latitude = locationResult.geometry.location.lat;
      deliveryAddress.longitude = locationResult.geometry.location.lng;
      checkout.deliveryAddress = deliveryAddress;
      // From coordinates
      setBusy(true);
      deliveryAddress = await getLocationCityName(deliveryAddress);
      setBusy(false);
      openLocationSelector(currentAddressSelectionStep, showpicker: false);
    } else if (result is Address) {
      Address locationResult = result;
      deliveryAddress.address = locationResult.addressLine;
      deliveryAddress.latitude = locationResult.coordinates.latitude;
      deliveryAddress.longitude = locationResult.coordinates.longitude;
      deliveryAddress.city = locationResult.locality;
      deliveryAddress.state = locationResult.adminArea;
      deliveryAddress.country = locationResult.countryName;
      checkout.deliveryAddress = deliveryAddress;
      //
      openLocationSelector(currentAddressSelectionStep, showpicker: false);
    }
    //

    return null;
  }

  //setupCurrentLocationAsPickuplocation()
  setupCurrentLocationAsPickuplocation() async {
    //get current location
    Position currentLocation = await Geolocator.getCurrentPosition();
    if (currentLocation == null) {
      currentLocation = await Geolocator.getLastKnownPosition();
    }

    //
    if (currentLocation != null) {
      //get name and addres of current location
      final address = await GeocoderService().findAddressesFromCoordinates(
        Coordinates(
          currentLocation?.latitude,
          currentLocation?.longitude,
        ),
      );
      //
      if (address != null && address.isNotEmpty) {
        pickupLocation = DeliveryAddress(
          name: address?.first?.featureName,
          address: address?.first?.addressLine,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
        );
        pickupLocationTEC.text = pickupLocation?.address;
      }
    }
  }

  //plylines
  drawTripPolyLines() async {
    // source pin
    //gMapMarkers = {};
    gMapMarkers.add(
      Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(
          pickupLocation.latitude,
          pickupLocation.longitude,
        ),
        icon: sourceIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    // destination pin
    gMapMarkers.add(
      Marker(
        markerId: MarkerId('destPin'),
        position: LatLng(
          dropoffLocation.latitude,
          dropoffLocation.longitude,
        ),
        icon: destinationIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    //load the ploylines
    PolylineResult polylineResult =
    await polylinePoints?.getRouteBetweenCoordinates(
      AppStrings.googleMapApiKey,
      PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
      PointLatLng(dropoffLocation.latitude, dropoffLocation.longitude),
    );
    //get the points from the result
    List<PointLatLng> result = polylineResult.points;
    //
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId("poly"),
      color: AppColor.primaryColor,
      points: polylineCoordinates,
      width: 6,
    );
//
    gMapPolylines = {};
    gMapPolylines.add(polyline);

    //
    //zoom to latbound
    final pickupLocationLatLng = LatLng(
      pickupLocation.latitude,
      pickupLocation.longitude,
    );
    final dropoffLocationLatLng = LatLng(
      dropoffLocation.latitude,
      dropoffLocation.longitude,
    );

    await updateCameraLocation(
      pickupLocationLatLng,
      dropoffLocationLatLng,
      googleMapController,
    );
    //
    notifyListeners();
  }

  Future<void> updateCameraLocation(
      LatLng source,
      LatLng destination,
      GoogleMapController mapController,
      ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate,
      GoogleMapController mapController,
      ) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  zoomToCurrentLocation() async {
    Position currentLocation = await Geolocator.getCurrentPosition();
    if (currentLocation == null) {
      currentLocation = await Geolocator.getLastKnownPosition();
    }

    //
    if (currentLocation != null) {
      double lat = currentLocation.latitude;
      double lng = currentLocation.longitude;
      zoomToLocation(LatLng(lat, lng));
    }
  }

  //
  clearMapData() {
    gMapMarkers.clear();
    polylineCoordinates.clear();
    gMapPolylines.clear();
    pickupLocationTEC.clear();
    dropoffLocationTEC.clear();
    notifyListeners();
    //
    setupCurrentLocationAsPickuplocation();
  }
}