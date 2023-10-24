import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/order_stop.dart';
import 'package:fuodz/models/package_checkout.dart';
import 'package:fuodz/models/package_type.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/requests/cart.request.dart';
import 'package:fuodz/requests/checkout.request.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/requests/package.request.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/parcel_vendor.service.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/widgets/bottomsheets/parcel_location_picker_option.bottomsheet.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class NewParcelViewModel extends PaymentViewModel {
  //
  PackageRequest packageRequest = PackageRequest();
  CartRequest cartRequest = CartRequest();
  VendorRequest vendorRequest = VendorRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
  CheckoutRequest checkoutRequest = CheckoutRequest();
  Function onFinish;
  VendorType vendorType;

  //Step 1
  List<PackageType> packageTypes = [];
  PackageType selectedPackgeType;

  //Step 2
  List<Vendor> vendors = [];
  Vendor selectedVendor;
  bool requireParcelInfo = false;

  //Step 3
  DeliveryAddress pickupLocation;
  DeliveryAddress dropoffLocation;
  DateTime selectedPickupDate;
  String pickupDate;
  TimeOfDay selectedPickupTime;
  String pickupTime;

  final deliveryInfoFormKey = GlobalKey<FormState>();
  TextEditingController fromTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();
  List<TextEditingController> toTECs = [];
  TextEditingController dateTEC = TextEditingController();
  TextEditingController timeTEC = TextEditingController();
  bool isScheduled = false;
  List<String> availableTimeSlots = [];

  //step 4
  //receipents
  int openedRecipientFormIndex = 0;
  final recipientInfoFormKey = GlobalKey<FormState>();
  List<TextEditingController> recipientNamesTEC = [TextEditingController()];
  List<TextEditingController> recipientPhonesTEC = [TextEditingController()];
  List<TextEditingController> recipientNotesTEC = [TextEditingController()];

  //step 5
  final packageInfoFormKey = GlobalKey<FormState>();
  TextEditingController packageWeightTEC = TextEditingController();
  TextEditingController packageHeightTEC = TextEditingController();
  TextEditingController packageWidthTEC = TextEditingController();
  TextEditingController packageLengthTEC = TextEditingController();
  TextEditingController noteTEC = TextEditingController();

  //packageCheckout
  PackageCheckout packageCheckout = PackageCheckout();
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod selectedPaymentMethod;
  //
  bool canApplyCoupon = false;
  Coupon coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  int activeStep = 0;
  PageController pageController = PageController();
  StreamSubscription currentLocationChangeStream;

  //
  NewParcelViewModel(BuildContext context, this.onFinish, this.vendorType) {
    this.viewContext = context;
  }

  bool isRazorpayLoading = false;
  final _razorpay = Razorpay();

  void initialise() async {
    //clear cart
    await CartServices.clearCart();
    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
              (location) async {
            //

            deliveryaddress.address = location.addressLine;
            deliveryaddress.latitude = location.coordinates.latitude;
            deliveryaddress.longitude = location.coordinates.longitude;
            //get city, state & country
            deliveryaddress = await getLocationCityName(deliveryaddress);
            notifyListeners();
          },
        );
    //
    if (AppStrings.enableParcelMultipleStops) {
      packageCheckout.stopsLocation = [];
      addNewStop();
    }
    await fetchParcelTypes();
    await fetchPaymentOptions();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream.cancel();
  }

  //
  fetchParcelTypes() async {
    //
    setBusyForObject(packageTypes, true);
    try {
      packageTypes = await packageRequest.fetchPackageTypes();
      clearErrors();
    } catch (error) {
      setErrorForObject(packageTypes, error);
    }
    setBusyForObject(packageTypes, false);
  }

  fetchParcelVendors() async {
    //
    vendors = [];
    selectedVendor = null;
    setBusyForObject(vendors, true);
    try {
      //
      List<OrderStop> allStops = getAllStops();
      vendors = await vendorRequest.fetchParcelVendors(
        vendorTypeId: vendorType.id,
        packageTypeId: selectedPackgeType.id,
        stops: allStops,
      );

      //
      if (AppStrings.enableSingleVendor &&
          vendors != null &&
          vendors.length > 0) {
        changeSelectedVendor(vendors.first);
      }
      clearErrors();
    } catch (error) {
      setErrorForObject(vendors, error);
    }
    setBusyForObject(vendors, false);
  }

  //
  fetchPaymentOptions() async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions();
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  ///FORM MANIPULATION
  nextForm(int index) {
    activeStep = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  //
  void changeSelectedPackageType(PackageType packgeType) async {
    selectedPackgeType = packgeType;
    packageCheckout.packageType = selectedPackgeType;
    notifyListeners();
  }

  void showNoVendorSelectedError() {
    toastError("No vendor for the selected package type.".tr());
    if (kDebugMode) {
      toastError(
        "DEBUG: Ensure you have at least one vendor under the package type. Also if you are using single mode, make sure the package types are attached to the active vendor."
            .tr(),
      );
    }
  }

  changeSelectedVendor(Vendor vendor) {
    selectedVendor = vendor;
    packageCheckout.vendor = selectedVendor;
    final vendorPackagePricing = selectedVendor.packageTypesPricing.firstWhere(
          (e) => e.packageTypeId == selectedPackgeType.id,
      orElse: () => null,
    );

    if (vendorPackagePricing != null) {
      requireParcelInfo = vendorPackagePricing.fieldRequired ?? true;
    }
    notifyListeners();
  }

  //
  changePickupAddress() async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      final result =
      await viewContext.navigator.pushNamed(AppRoutes.loginRoute);
      paymentOptionRequest = PaymentMethodRequest();
      if (result == null || !result) {
        return;
      }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      pickupLocation = result;
      fromTEC.text = pickupLocation.address;
      //
      packageCheckout.pickupLocation = pickupLocation;
      notifyListeners();
    }
  }

  //
  changeDropOffAddress() async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      final result =
      await viewContext.navigator.pushNamed(AppRoutes.loginRoute);
      paymentOptionRequest = PaymentMethodRequest();
      if (result == null || !result) {
        return;
      }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      dropoffLocation = result;
      toTEC.text = dropoffLocation.address;
      //
      packageCheckout.dropoffLocation = dropoffLocation;
      notifyListeners();
    }
  }

  //
  changeStopDeliveryAddress(int index) async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      final result =
      await viewContext.navigator.pushNamed(AppRoutes.loginRoute);
      paymentOptionRequest = PaymentMethodRequest();
      if (result == null || !result) {
        return;
      }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      dropoffLocation = result;
      toTECs[index].text = dropoffLocation.address;
      //
      packageCheckout.stopsLocation[index] = new OrderStop();
      packageCheckout.stopsLocation[index].deliveryAddress = dropoffLocation;
      notifyListeners();
    }
  }

  manualChangeStopDeliveryAddress(
      int index,
      DeliveryAddress deliveryAddress,
      ) async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      final result =
      await viewContext.navigator.pushNamed(AppRoutes.loginRoute);
      paymentOptionRequest = PaymentMethodRequest();
      if (result == null || !result) {
        return;
      }
    }

    dropoffLocation = deliveryAddress;
    toTECs[index].text = dropoffLocation.address;
    //
    packageCheckout.stopsLocation[index] = new OrderStop();
    packageCheckout.stopsLocation[index].deliveryAddress = dropoffLocation;
    notifyListeners();
  }

  ///
  handlePickupStop() async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changePickupAddress();
    } else if (result is DeliveryAddress) {
      pickupLocation = result;
      pickupLocation.name = pickupLocation.address;
      fromTEC.text = pickupLocation.address;
      //
      packageCheckout.pickupLocation = pickupLocation;
      notifyListeners();
    }
  }

  handleDropoffStop() async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changeDropOffAddress();
    } else if (result is DeliveryAddress) {
      dropoffLocation = result;
      toTEC.text = dropoffLocation.address;
      //
      packageCheckout.dropoffLocation = dropoffLocation;
      notifyListeners();
    }
  }

  handleOtherStop(int index) async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changeStopDeliveryAddress(index);
    } else if (result is DeliveryAddress) {
      manualChangeStopDeliveryAddress(index, result);
    }
  }

  ///

  //location/delivery address picker options
  Future<dynamic> showLocationPickerOptionBottomsheet() async {
    final result = await showModalBottomSheet(
      context: viewContext,
      builder: (ctx) {
        return ParcelLocationPickerOptionBottomSheet();
      },
    );

    //
    if (result != null && (result is int)) {
      //map address picker
      if (result == 1) {
        return await pickFromMap();
      } else {
        return true;
      }
    }
    return false;
  }

  Future<DeliveryAddress> pickFromMap() async {
    //
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      DeliveryAddress deliveryAddress = DeliveryAddress();
      deliveryAddress.name = locationResult.formattedAddress;
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
      deliveryAddress.state = addresses.first.adminArea;
      deliveryAddress.country = addresses.first.countryName;
      setBusy(false);
      //
      return deliveryAddress;
    } else if (result is Address) {
      Address locationResult = result;
      DeliveryAddress deliveryAddress = DeliveryAddress();
      deliveryAddress.name = locationResult.addressLine;
      deliveryAddress.address = locationResult.addressLine;
      deliveryAddress.latitude = locationResult.coordinates.latitude;
      deliveryAddress.longitude = locationResult.coordinates.longitude;
      deliveryAddress.city = locationResult.locality;
      deliveryAddress.state = locationResult.adminArea;
      deliveryAddress.country = locationResult.countryName;
      //
      return deliveryAddress;
    }

    return null;
  }

  //

  //
  toggleScheduledOrder(bool value) {
    isScheduled = value;
    packageCheckout.isScheduled = isScheduled;
    //remove delivery address if pickup
    packageCheckout.date = null;
    packageCheckout.deliverySlotDate = null;
    packageCheckout.time = null;
    packageCheckout.deliverySlotTime = null;
    notifyListeners();
  }

  //start of schedule related
  changeSelectedDeliveryDate(String string, int index) {
    packageCheckout.deliverySlotDate = string;
    packageCheckout.date = string;
    pickupDate = string;
    availableTimeSlots = selectedVendor.deliverySlots[index].times;
    notifyListeners();
  }

  changeSelectedDeliveryTime(String time) {
    packageCheckout.deliverySlotTime = time;
    packageCheckout.time = time;
    pickupTime = time;
    notifyListeners();
  }

  //
  changeDropOffDate() async {
    final result = await showDatePicker(
      context: viewContext,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(
          days: selectedVendor.packageTypesPricing.first.maxBookingDays ?? 7,
        ),
      ),
      initialDate: selectedPickupDate ?? DateTime.now(),
    );

    //
    if (result != null) {
      selectedPickupDate = result;
      pickupDate =
          Jiffy.unixFromMillisecondsSinceEpoch(result.millisecondsSinceEpoch)
              .format("yyyy-MM-dd");
      dateTEC.text =
          Jiffy.unixFromMillisecondsSinceEpoch(result.millisecondsSinceEpoch)
              .yMMMMd;
      packageCheckout.date = pickupDate;
      notifyListeners();
    }
  }

  changeDropOffTime() async {
    final result = await showTimePicker(
      context: viewContext,
      initialTime: selectedPickupTime ?? TimeOfDay.now(),
    );

    //
    if (result != null) {
      selectedPickupTime = result;
      pickupTime = result.format(viewContext);
      timeTEC.text = pickupTime;

      try {
        packageCheckout.time = "${result.hour}:${result.minute}";
      } catch (error) {
        packageCheckout.time = "$pickupTime";
      }
      notifyListeners();
    }
  }

  changeSelectedPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    packageCheckout.paymentMethod = paymentMethod;
    notifyListeners();
  }

  //Form validationns
  validateDeliveryInfo() async {
    if (deliveryInfoFormKey.currentState.validate()) {
      //
      //
      if (AppStrings.enableSingleVendor) {
        setBusyForObject(selectedVendor, true);
        await fetchParcelVendors();
        setBusyForObject(selectedVendor, false);
        //
        if (AppStrings.enableSingleVendor && selectedVendor == null) {
          showNoVendorSelectedError();
        } else {
          nextForm(2);
        }
      } else {
        nextForm(2);
        fetchParcelVendors();
      }
    }
  }

  // Recipient
  validateRecipientInfo() {
    //
    recipientInfoFormKey.currentState.validate();
    bool dataRequired = false;
    //loop throug the recipents
    recipientNamesTEC.forEachIndexed((index, element) {
      if (element.text.isEmpty) {
        dataRequired = true;
        return;
      }
    });

    recipientPhonesTEC.forEachIndexed((index, element) {
      if (element.text.isEmpty ||
          FormValidator.validatePhone(element.text) != null) {
        dataRequired = true;
        return;
      }
    });

    if (dataRequired) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.warning,
        title: "Fill Contact Info".tr(),
        text:
        "Please ensure you fill in contact info for all added stops. Thank you"
            .tr(),
        onConfirmBtnTap: () {
          //hide keyboard
          FocusScope.of(viewContext).requestFocus(FocusNode());
          viewContext.pop();
        },
      );

      return;
    }

    //
    if (recipientInfoFormKey.currentState.validate()) {
      //loop through recipients
      // recipientNamesTEC

      // packageCheckout.recipientName = recipientNameTEC.text;
      // packageCheckout.recipientPhone = recipientPhoneTEC.text;
      nextForm(!requireParcelInfo ? 5 : 4);
    }
  }

  validateDeliveryParcelInfo() {
    if (packageInfoFormKey.currentState.validate()) {
      //
      packageCheckout.weight = packageWeightTEC.text;
      packageCheckout.width = packageWidthTEC.text;
      packageCheckout.length = packageLengthTEC.text;
      packageCheckout.height = packageHeightTEC.text;
      //hide keyboard
      FocusScope.of(viewContext).unfocus();
      nextForm(5);
    }
  }

  validateSelectedVendor() {
    print("Date: ${packageCheckout.deliverySlotDate}");
    print("Time: ${packageCheckout.deliverySlotTime}");
    //
    if (!selectedVendor.isOpen &&
        (packageCheckout.deliverySlotDate == null ||
            packageCheckout.deliverySlotTime == null ||
            packageCheckout.deliverySlotDate.isEmpty ||
            packageCheckout.deliverySlotTime.isEmpty)) {
      if (selectedVendor.allowScheduleOrder) {
        AlertService.error(
            text: "Vendor is not open. Please schedule order".tr());
      } else {
        AlertService.error(text: "Vendor is not open".tr());
      }
    } else {
      FocusScope.of(viewContext).unfocus();
      nextForm(3);
    }
  }

  //Submit form
  prepareOrderSummary() async {
    //
    nextForm(6);
    clearErrors();
    setBusyForObject(packageCheckout, true);
    try {
      List<OrderStop> allStops = getAllStops();

      //loop through deleivery addresses and create the onces that were selected from map directly
      for (var i = 0; i < allStops.length; i++) {
        final stop = allStops[i];
        //
        if (stop.deliveryAddress.id == null) {
          DeliveryAddressRequest dARequest = DeliveryAddressRequest();
          final apiResposne =
          await dARequest.saveDeliveryAddress(stop.deliveryAddress);
          //
          if (apiResposne.allGood) {
            allStops[i].deliveryAddress = DeliveryAddress.fromJson(
              (apiResposne.body as Map)["data"],
            );
          } else {
            toastError("${apiResposne.message}");
          }
        }
      }

      //
      recipientNamesTEC.forEachIndexed((index, element) {
        allStops[index].stopId = allStops[index].deliveryAddress.id;
        allStops[index].name = element.text;
        allStops[index].phone = recipientPhonesTEC[index].text;
        allStops[index].note = recipientNotesTEC[index].text;
      });

      //
      packageCheckout.allStops = allStops;

      //
      final mPackageCheckout = await packageRequest.parcelSummary(
        vendorId: selectedVendor.id,
        packageTypeId: selectedPackgeType.id,
        stops: allStops,
        packageWeight: packageWeightTEC.text,
        couponCode: couponTEC.text,
      );

      //
      packageCheckout.copyWith(packageCheckout: mPackageCheckout);
      //
    } catch (error) {
      print("Package error ==> $error");
      toastError("$error");
    }
    setBusyForObject(packageCheckout, false);
  }

  couponCodeChange(String code) {
    canApplyCoupon = code.isNotBlank;
    notifyListeners();
  }

  //
  applyCoupon() async {
    //
    setBusyForObject(coupon, true);
    try {
      await prepareOrderSummary();
    } catch (error) {
      print("error ==> $error");
      toastError("$error");
    }
    setBusyForObject(coupon, false);
  }

  clearCoupon() {
    coupon = null;
    couponTEC.text = "";
    notifyListeners();
    applyCoupon();
  }

  //Submit form
  //Submit form
  initiateOrderPayment() async {
    //show loading dialog
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      barrierDismissible: false,
      title: "Checkout".tr(),
      text: "Processing order. Please wait...".tr(),
    );

    try {
      //coupon
      packageCheckout.coupon = coupon;
      //
      final apiResponse = await checkoutRequest.newPackageOrder(
        packageCheckout,
        note: noteTEC.text,
      );

      //close loading dialog
      viewContext.pop();

      //not error
      if (apiResponse.allGood) {
        //cash payment
        print("apiResponse.body parcel ====>>>>>${apiResponse.body}");
        final paymentLink = apiResponse.body["link"].toString();
        parcelOrderId = apiResponse.body["orderId"];
        if (!paymentLink.isEmpty) {
          print("selectedPaymentMethod is===>>>>${selectedPaymentMethod.name.toLowerCase()}");
          if(selectedPaymentMethod.name.toLowerCase() == "pay online"){
            print("if part");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
              _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
              _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
            });
            double totalAmt = packageCheckout.total - packageCheckout.discount;
            print("total===>>>${totalAmt.toStringAsFixed(2)}");
            await createOrder(totalAmt);
          }else{
            showOrdersTab();
            openWebpageLink(paymentLink);
          }
        }
        //cash payment
        else {
          CoolAlert.show(
              context: viewContext,
              type: CoolAlertType.success,
              title: "Checkout".tr(),
              text: apiResponse.message,
              barrierDismissible: false,
              onConfirmBtnTap: () {
                viewContext.pop();
                if (viewContext.navigator.canPop()) {
                  viewContext.navigator.popUntil(
                        (route) {
                      return route == AppRoutes.homeRoute || route.isFirst;
                    },
                  );
                }
                viewContext.navigator.pushNamed(
                  AppRoutes.orderDetailsRoute,
                  arguments: new Order(id: parcelOrderId),
                );
                //showOrdersTab();
              });
        }
      } else {
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Checkout".tr(),
          text: apiResponse.message,
        );
      }
    } catch (error) {
      print("Error ==> $error");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    viewContext.pop();
    if (viewContext.navigator.canPop()) {
      viewContext.navigator.popUntil(
            (route) {
          return route == AppRoutes.homeRoute || route.isFirst;
        },
      );
    }
    viewContext.navigator.pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: new Order(id: parcelOrderId),
    );
    //showOrdersTab();
    print("orderId====>>>>${parcelOrderId}");
    UpdateOrderStatus(id: parcelOrderId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    viewContext.pop();
    showOrdersTab();
    toastSuccessful(response.message ?? '');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
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
  showOrdersTab() {
    //
    viewContext.pop();
    //switch tab to orders
    AppService().changeHomePageIndex(index: 1);
  }

  addNewStop() {
    if (AppStrings.maxParcelStops > (toTECs.length - 1)) {
      final toTEC = TextEditingController();
      toTECs.add(toTEC);
      //
      recipientNamesTEC.add(TextEditingController());
      recipientPhonesTEC.add(TextEditingController());
      recipientNotesTEC.add(TextEditingController());
      //
      packageCheckout.stopsLocation.add(null);
      notifyListeners();
    }
  }

  removeStop(int index) {
    toTECs.removeAt(index);
    recipientNamesTEC.removeAt(index);
    recipientPhonesTEC.removeAt(index);
    recipientNotesTEC.removeAt(index);
    packageCheckout.stopsLocation.removeAt(index);
    notifyListeners();
  }

  List<OrderStop> getAllStops() {
    List<OrderStop> allStops = [];
    if (packageCheckout.pickupLocation != null) {
      allStops.add(OrderStop(deliveryAddress: packageCheckout.pickupLocation));
    }

    if (packageCheckout.stopsLocation != null &&
        packageCheckout.stopsLocation.isNotEmpty) {
      allStops.addAll(packageCheckout.stopsLocation);
    }
    if (packageCheckout.dropoffLocation != null) {
      allStops.add(OrderStop(deliveryAddress: packageCheckout.dropoffLocation));
    }

    return allStops;
  }
}