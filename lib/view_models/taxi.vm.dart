import 'dart:convert';

import 'package:firestore_chat/firestore_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as CloudFirestore;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/vehicle_type.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/requests/cart.request.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/chat.service.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/toast.service.dart';
import 'package:fuodz/view_models/trip_taxi.vm.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class TaxiViewModel extends TripTaxiViewModel {
  //
  TaxiViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

//requests
  CartRequest cartRequest = CartRequest();
  TaxiRequest taxiRequest = TaxiRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
//

  VendorType vendorType;
  //coupons
  bool canApplyCoupon = false;
  bool canScheduleTaxiOrder = false;
  Coupon coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  CheckOut checkout = CheckOut();
  double subTotal = 0.0;
  double total = 0.0;
  double tip = 0.0;

  final _razorpay = Razorpay();

  //functions
  //functions
  void initialise() async {
    vehicleTypes = await taxiRequest.getVehicleTypes();
    //
    fetchTaxiPaymentOptions();
    //
    getOnGoingTrip();
    //set current location as pickup location
    setupCurrentLocationAsPickuplocation();

    retrieveNearByDrivers(null, null);
    setCurrentStep(1);
  }

  Future<void> retrieveNearByDrivers(LatLng latLng, VehicleType vehicleType, {bool clearGMapMarker = false}) async {
    setBusyForObject(gMapMarkers, true);
    Position currentLocation;

    if (clearGMapMarker) {
      gMapMarkers.removeWhere((element) => element.markerId.value != "sourcePin" || element.markerId.value != "destPin");
    }
    if (latLng == null) {
      currentLocation = await Geolocator.getCurrentPosition();
      if (currentLocation == null) {
        currentLocation = await Geolocator.getLastKnownPosition();
      }
    } else {
      currentLocation = Position(longitude: latLng.longitude, latitude: latLng.latitude, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
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
                //LatLng latLng = new LatLng(latitude, longitude);
                var distanceCalculator = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, latitude, longitude) / 1000;
                if (distanceCalculator <= 20) {
                  print("online driver:  ${itemData}");
                  if (vehicleType == null) {

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
                        gMapMarkers.add(new Marker(markerId: MarkerId("${i}_${vehicleTypes[searchVehicleIndex].name}"), draggable: false, position: LatLng(latitude, longitude), icon: BitmapDescriptor.fromBytes(newByteData)));
                      }
                    }

                  } else {

                    if (vehicle_type_id == vehicleType.id) {
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
                          gMapMarkers.add(new Marker(markerId: MarkerId("${i}_${vehicleType.name}"), draggable: false, position: LatLng(latitude, longitude), icon: BitmapDescriptor.fromBytes(newByteData)));
                        }
                      }
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
  bool currentStep(int step) {
    return step == currentOrderStep;
  }

  isSelected(PaymentMethod paymentMethod) {
    return selectedPaymentMethod != null &&
        paymentMethod.id == selectedPaymentMethod.id;
  }

  couponCodeChange(String code) {
    canApplyCoupon = code.isNotBlank;
    notifyListeners();
  }

  toggleScheduleTaxiOrder(bool enabled) {
    if (!enabled) {
      checkout?.pickupDate = null;
      checkout?.pickupTime = null;
    }

    canScheduleTaxiOrder = enabled;
    notifyListeners();
  }

  //
  applyCoupon() async {
    //
    setBusyForObject(coupon, true);
    try {
      coupon = await cartRequest.fetchCoupon(
        couponTEC.text,
        vendorTypeId: vendorType?.id,
      );
      //
      if (coupon.useLeft <= 0) {
        coupon = null;
        throw "Coupon use limit exceeded".tr();
      } else if (coupon.expired) {
        coupon = null;
        throw "Coupon has expired".tr();
      }
      clearErrors();

      //
      calculateTotalAmount();
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon, error);
    }
    setBusyForObject(coupon, false);
  }

  //after locations has been selected
  proceedToStep2() async {
    //validate user has selected both pickup and drop off location
    if (pickupLocation == null || dropoffLocation == null) {
      toastError("Please select pickup and drop-off location".tr());
    } else if (canScheduleTaxiOrder &&
        (checkout?.pickupDate == null || checkout?.pickupTime == null)) {
      toastError("Please select pickup date and pickup time".tr());
    } else {
      checkLocationAvailabilityForStep2();
    }
  }

//checking if taxi booking is enabled in the given location
  checkLocationAvailabilityForStep2() async {
    setBusy(true);
    final apiResponse = await taxiRequest.locationAvailable(
      pickupLocation.latitude,
      pickupLocation.longitude,
    );
    if (apiResponse.allGood) {
      await retrieveNearByDrivers(LatLng(pickupLocation.latitude, pickupLocation.longitude), null);
      prepareStep2();
    } else {
      setCurrentStep(0);
    }
    setBusy(false);
  }

  //
  void prepareStep2() {
    setCurrentStep(2);
    drawTripPolyLines();
    fetchVehicleTypes();
  }

  //vehicle types
  fetchVehicleTypes() async {
    setBusyForObject(vehicleTypes, true);
    try {
      vehicleTypes = await taxiRequest.getVehicleTypePricing(
        pickupLocation,
        dropoffLocation,
        countryCode: LocationService?.currenctAddress?.countryCode,
      );
    } catch (error) {
      print("Error getting vehicleTypes ==> $error");
    }
    setBusyForObject(vehicleTypes, false);
  }

  resortVehicleTypes() {
    if (selectedVehicleType != null) {
      vehicleTypes.removeWhere((e) => e.id == selectedVehicleType.id);
      vehicleTypes.insert(0, selectedVehicleType);
    }
  }

  //
  changeSelectedVehicleType(VehicleType vehicleType) async {
    selectedVehicleType = vehicleType;
    resortVehicleTypes();
    calculateTotalAmount();
    await retrieveNearByDrivers(LatLng(pickupLocation.latitude, pickupLocation.longitude), selectedVehicleType);
  }

  //
  calculateTotalAmount() {
    //
    subTotal = selectedVehicleType.total;
    print("subTotal ==> ${subTotal}");
    //
    if (coupon != null) {
      if (coupon.percentage == 1) {
        checkout.discount = (coupon.discount / 100) * subTotal;
      } else {
        checkout.discount = coupon.discount;
      }
    }
    print("discount ==> ${checkout.discount}");
    total = subTotal - (checkout.discount ?? 0);
    print("total ==> ${total}");
    notifyListeners();
  }

  //
  processNewOrder() async {
    //
    //element.markerId.value.endsWith(vm.selectedVehicleType.name) || element.markerId.value == "sourcePin" || element.markerId.value == "destPin"
    bool nearByDriverFound = gMapMarkers.any((element) => element.markerId.value.endsWith(selectedVehicleType.name));
    if (!nearByDriverFound) {
      ToastService.toastError("No ${selectedVehicleType.name} found near by you. Please try again.");
      return;
    }
    setBusy(true);
    final apiResponse = await taxiRequest.placeNeworder(
      params: {
        "payment_method_id": selectedPaymentMethod.id,
        "vehicle_type_id": selectedVehicleType.id,
        "pickup": {
          "lat": pickupLocation.latitude,
          "lng": pickupLocation.longitude,
          "address": pickupLocation.address,
        },
        "dropoff": {
          "lat": dropoffLocation.latitude,
          "lng": dropoffLocation.longitude,
          "address": dropoffLocation.address,
        },
        "sub_total": subTotal,
        "total": total,
        "discount": checkout.discount,
        "tip": tip,
        "coupon_code": coupon?.code,
        "vehicle_type": selectedVehicleType.encrypted,
        "pickup_date": checkout.pickupDate,
        "pickup_time": checkout.pickupTime,
      },
    );
    setBusy(false);

    //if there was an issue placing the order
    if (!apiResponse.allGood) {
      AlertService.error(
        title: "Order failed".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      onGoingOrderTrip = Order.fromJson(apiResponse.body["order"]);
      //payment
      print("taxi res====>>>>>${apiResponse.body}");
      String paymentLink = apiResponse.body["link"];
      taxiBookingId = apiResponse.body["order"]['id'];
      print("orderId====>>>>${taxiBookingId}");
      if (paymentLink.isNotBlank) {
        print("payment method===>>>${selectedPaymentMethod.name}");
        if(selectedPaymentMethod.name.toLowerCase() == "pay online"){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
            _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
            _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
          });
          print("taxi total===>>>${total}");
          await createOrder(total);
        }else{
          await openWebpageLink(paymentLink);
        }
      }
      //
      if (checkout.pickupDate == null || !canScheduleTaxiOrder) {
        startHandlingOnGoingTrip();
      } else {
        closeOrderSummary();
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    // viewContext.pop();
    // showOrdersTab(context: viewContext);
    print("orderId====>>>>${taxiBookingId}");
    UpdateOrderStatus(id: taxiBookingId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    // viewContext.pop();
    // showOrdersTab(context: viewContext);
    toastSuccessful(response.message ?? '');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    //response.walletName ?? ''
    toastSuccessful(response.walletName ?? '');
  }

  double finalAmount;

  void createOrder(double amounts) async {
    finalAmount = double.parse(amounts.toStringAsFixed(2)) * 100;
    isRazorpayLoading = true;
    var data = await LocalStorageService.prefs.getString(AppStrings.userKey);
    final userObject = json.decode(data);
    print("data is===>>>${userObject["email"]}");
    print("data is===>>>${userObject["phone"]}");
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> body = {
      "amount": finalAmount,
      "currency": "INR",
      "receipt": 'fyu'
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      isRazorpayLoading = false;
      openGateway(jsonDecode(res.body)['id'],userObject["phone"],userObject["email"]);
    }else{
      isRazorpayLoading = false;
    }
    print(res.body);
  }

  openGateway(String orderId,String contact,String email) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': finalAmount, //in the smallest currency sub-unit.
      'name': 'Urgento',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'powered by a work connect private limited',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme.color':'#000000'
    };
    _razorpay.open(options);
  }

  //
  openTripChat() {
    //
    Map<String, PeerUser> peers = {
      '${onGoingOrderTrip.userId}': PeerUser(
        id: '${onGoingOrderTrip.userId}',
        name: onGoingOrderTrip.user.name,
        image: onGoingOrderTrip.user.photo,
      ),
      '${onGoingOrderTrip.driver.id}': PeerUser(
          id: "${onGoingOrderTrip.driver.id}",
          name: onGoingOrderTrip.driver.name,
          image: onGoingOrderTrip.driver.photo),
    };
    //
    final chatEntity = ChatEntity(
      onMessageSent: ChatService.sendChatMessage,
      mainUser: peers['${onGoingOrderTrip.userId}'],
      peers: peers,
      //don't translate this
      path: 'orders/' + onGoingOrderTrip.code + "/customerDriver/chats",
      title: "Chat with driver".tr(),
    );
    //
    viewContext.navigator.pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }
}