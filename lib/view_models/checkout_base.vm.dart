import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/requests/checkout.request.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/views/pages/order/taxi_order_details.page.dart';
import 'package:fuodz/widgets/bottomsheets/delivery_address_picker.bottomsheet.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class CheckoutBaseViewModel extends PaymentViewModel {
  //
  CheckoutRequest checkoutRequest = CheckoutRequest();
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();

  VendorRequest vendorRequest = VendorRequest();
  TextEditingController driverTipTEC = TextEditingController();
  TextEditingController noteTEC = TextEditingController();
  DeliveryAddress deliveryAddress;
  bool isPickup = false;
  bool isScheduled = false;
  List<String> availableTimeSlots = [];
  bool delievryAddressOutOfRange = false;
  bool canSelectPaymentOption = true;
  Vendor vendor;
  CheckOut checkout;
  bool calculateTotal = true;
  List<Map> calFees = [];
  bool isPayUsingRazorpay = false;
  bool isRazorpayLoading = false;

  List<String> tipsList = ["20" , "30" , "50", "Custom"];
  String selectedTip;
  //
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod selectedPaymentMethod;
  bool isExpanded = false;

  void expandedToggle() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
  final _razorpay = Razorpay();

  void initialise() async {
    fetchVendorDetails();
    prefetchDeliveryAddress();
    fetchPaymentOptions();
    updateTotalOrderSummary();
  }

  //
  fetchVendorDetails() async {
    //
    vendor = CartServices.productsInCart[0].product.vendor;

    //
    setBusy(true);
    try {
      vendor = await vendorRequest.vendorDetails(
        vendor.id,
        params: {
          "type": "brief",
        },
      );
      isScheduled = vendor.allowScheduleOrder;
      setVendorRequirement();
    } catch (error) {
      print("Error Getting Vendor Details ==> $error");
    }
    setBusy(false);
  }

  setVendorRequirement() {
    if (vendor.allowOnlyDelivery) {
      isPickup = false;
    } else if (vendor.allowOnlyPickup) {
      isPickup = true;
    }
  }

  //start of schedule related
  changeSelectedDeliveryDate(String string, int index) {
    checkout.deliverySlotDate = string;
    availableTimeSlots = vendor.deliverySlots[index].times;
    notifyListeners();
  }

  changeSelectedDeliveryTime(String time) {
    checkout.deliverySlotTime = time;
    notifyListeners();
  }

  //end of schedule related
  //
  prefetchDeliveryAddress() async {
    setBusyForObject(deliveryAddress, true);
    //
    try {
      //
      checkout.deliveryAddress = deliveryAddress =
      await deliveryAddressRequest.preselectedDeliveryAddress(
        vendorId: vendor.id,
      );

      if (checkout.deliveryAddress != null) {
        //
        checkDeliveryRange();
        updateTotalOrderSummary();
      }
    } catch (error) {
      print("Error Fetching preselected Address ==> $error");
    }
    setBusyForObject(deliveryAddress, false);
  }

  //
  fetchPaymentOptions({int vendorId}) async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions(
        vendorId: vendorId != null ? vendorId : vendor?.id,
      );
      //
      updatePaymentOptionSelection();
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  //
  fetchTaxiPaymentOptions() async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getTaxiPaymentOptions();
      //
      updatePaymentOptionSelection();
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  updatePaymentOptionSelection() {
    if (checkout != null && checkout.total <= 0.00) {
      canSelectPaymentOption = false;
    } else {
      canSelectPaymentOption = true;
    }
    //
    if (!canSelectPaymentOption) {
      final selectedPaymentMethod = paymentMethods.firstWhere(
            (e) => e.isCash == 1,
        orElse: () => null,
      );
      if (selectedPaymentMethod != null) {
        changeSelectedPaymentMethod(selectedPaymentMethod, callTotal: false);
      }
    }
  }

  //
  showDeliveryAddressPicker() async {
    //
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeliveryAddressPicker(
          onSelectDeliveryAddress: (deliveryAddress) {
            this.deliveryAddress = deliveryAddress;
            checkout.deliveryAddress = deliveryAddress;
            //
            checkDeliveryRange();
            updateTotalOrderSummary();
            //
            notifyListeners();
            viewContext.pop();
          },
        );
      },
    );
    return null;
  }

  //
  togglePickupStatus(bool value) {
    //
    if (vendor.allowOnlyPickup) {
      value = true;
    } else if (vendor.allowOnlyDelivery) {
      value = false;
    }
    isPickup = value;
    //remove delivery address if pickup
    if (isPickup) {
      checkout.deliveryAddress = null;
    } else {
      checkout.deliveryAddress = deliveryAddress;
    }

    updateTotalOrderSummary();
    notifyListeners();
  }

  //
  toggleScheduledOrder(bool value) async {
    //isScheduled = value;
    isScheduled = true;
    checkout.isScheduled = isScheduled;
    //remove delivery address if pickup
    checkout.pickupDate = null;
    checkout.deliverySlotDate = "";
    checkout.pickupTime = null;
    checkout.deliverySlotTime = "";

    await Jiffy.locale(translator.activeLocale.languageCode);

    notifyListeners();
  }

  //
  void checkDeliveryRange() {
    delievryAddressOutOfRange =
        vendor.deliveryRange < (deliveryAddress.distance ?? 0);
    if (deliveryAddress.can_deliver != null) {
      delievryAddressOutOfRange = !deliveryAddress.can_deliver;
    }
    notifyListeners();
  }

  //
  isSelected(PaymentMethod paymentMethod) {
    return selectedPaymentMethod != null && paymentMethod.id == selectedPaymentMethod.id;
  }

  changeSelectedPaymentMethod(PaymentMethod paymentMethod, {bool callTotal = true}) {
    selectedPaymentMethod = paymentMethod;
    print("dfdfdfdfdffdf   ${selectedPaymentMethod.name}" );
    if(selectedPaymentMethod.name.toLowerCase() == "pay online"){
      isPayUsingRazorpay = true;
    }else{
      isPayUsingRazorpay = false;
    }
    checkout.paymentMethod = paymentMethod;
    if (callTotal) {
      updateTotalOrderSummary();
    }
    notifyListeners();
  }



  aaa(PaymentMethod paymentMethod, {bool callTotal = true}){
    print("dfdfdfdfdffdf  in aaa" );
    selectedPaymentMethod = paymentMethod;
    print("dfdfdfdfdffdf   ${selectedPaymentMethod.name}" );
    if(selectedPaymentMethod.name.toLowerCase() == "pay online"){
      isPayUsingRazorpay = true;
    }else{
      isPayUsingRazorpay = false;
    }
    /* checkout.paymentMethod = paymentMethod;
    if (callTotal) {
      updateTotalOrderSummary();
    }*/
    notifyListeners();
  }
  //update total/order amount summary
  updateTotalOrderSummary() async {
    //delivery fee
    if (!isPickup && deliveryAddress != null) {
      //selected delivery address is within range
      if (!delievryAddressOutOfRange) {
        //vendor charges per km
        setBusy(true);
        try {
          double orderDeliveryFee = await checkoutRequest.orderSummary(
            deliveryAddressId: deliveryAddress.id,
            vendorId: vendor.id,
          );

          //adding base fee
          checkout.deliveryFee = orderDeliveryFee;
        } catch (error) {
          if (vendor.chargePerKm != null && vendor.chargePerKm == 1) {
            checkout.deliveryFee =
                vendor.deliveryFee * deliveryAddress.distance;
          } else {
            checkout.deliveryFee = vendor.deliveryFee;
          }

          //adding base fee
          checkout.deliveryFee += vendor.baseDeliveryFee;
        }

        //
        setBusy(false);
      } else {
        checkout.deliveryFee = 0.00;
      }
    } else {
      checkout.deliveryFee = 0.00;
    }

    //tax
    checkout.tax = (double.parse(vendor.tax ?? "0") / 100) * checkout.subTotal;
    checkout.total = (checkout.subTotal - checkout.discount) +
        checkout.deliveryFee +
        checkout.tax;
    //vendor fees
    calFees = [];
    for (var fee in vendor.fees) {
      double calFee = 0;
      if (fee.isPercentage) {
        checkout.total += calFee = fee.getRate(checkout.subTotal);
      } else {
        checkout.total += calFee = fee.value;
      }

      calFees.add({
        "id": fee.id,
        "name": fee.name,
        "amount": calFee,
      });
    }
    //
    updateCheckoutTotalAmount();
    updatePaymentOptionSelection();
    notifyListeners();
  }

  //
  bool pickupOnlyProduct() {
    //
    final product = CartServices.productsInCart.firstWhere(
          (e) => !e.product.canBeDelivered,
      orElse: () => null,
    );

    return product != null;
  }

  //
  updateCheckoutTotalAmount() {
    checkout.totalWithTip =
        checkout.total.toDouble() + (driverTipTEC.text.toDouble() ?? 0);
  }

  //
  placeOrder({bool ignore = false}) async {
    //
    if (isScheduled && checkout.deliverySlotDate.isEmptyOrNull) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery Date".tr(),
        text: "Please select your desire order date".tr(),
      );
    } else if (isScheduled && checkout.deliverySlotTime.isEmptyOrNull) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery Time".tr(),
        text: "Please select your desire order time".tr(),
      );
    } else if (!isPickup && pickupOnlyProduct()) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Product".tr(),
        text:
        "There seems to be products that can not be delivered in your cart"
            .tr(),
      );
    } else if (!isPickup && deliveryAddress == null) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery address".tr(),
        text: "Please select delivery address".tr(),
      );
    } else if (delievryAddressOutOfRange && !isPickup) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery address".tr(),
        text: "Delivery address is out of vendor delivery range".tr(),
      );
    } else if (selectedPaymentMethod == null) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Payment Methods".tr(),
        text: "Please select a payment method".tr(),
      );
    } else if (!ignore && !verifyVendorOrderAmountCheck()) {
      print("Failed");
    }
    //process the new order
    else {
      processOrderPlacement();
    }
  }

  //
  processOrderPlacement() async {
    //process the order placement
    setBusy(true);
    //set the total with discount as the new total
    checkout.total = checkout.totalWithTip;

    if (selectedTip != null) {
      driverTipTEC.text = selectedTip;
    }
    //
    final apiResponse = await checkoutRequest.newOrder(
      checkout,
      tip: driverTipTEC.text,
      note: noteTEC.text,
      fees: calFees ?? [],
    );

    //notify wallet view to update, just incase wallet was use for payment
    AppService().refreshWalletBalance.add(true);

    //not error
    if (apiResponse.allGood) {
      //cash payment
      log("body dsffdfdfdf====>>>>${apiResponse.body}");
      log("body res====>>>>${apiResponse.body}");

      final paymentLink = apiResponse.body["link"].toString();
      orderId = apiResponse.body["orderId"];
      if (!paymentLink.isEmptyOrNull) {
        if(selectedPaymentMethod.name.toLowerCase() != "pay online"){
          viewContext.pop();
          showOrdersTab(context: viewContext);
        }

        dynamic result;
        // if (["offline", "razorpay"]
        if (["offline"].contains(checkout?.paymentMethod?.slug ?? "offline")) {
          result = await openExternalWebpageLink(paymentLink);
          print("here is pay offline click========");
          print("here is pay offline paymentLink========$paymentLink");
        } else {
          print("here is pay online click========");
          print("here is pay online paymentLink========$paymentLink");
          if(isPayUsingRazorpay){
            print("aaaaa here is pay online click========");
            print("here is pay online paymentLink========$paymentLink");
            print("here is pay online total========${checkout?.total}");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
              _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
              _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
            });
            await createOrder(checkout?.total);
          }
          else{
            print("2323====else part");
            result = await openintWebpageLink(paymentLink);
          }
        }
        print("Result from payment ==> $result");
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
              viewContext.pop(true);
              //showOrdersTab(context: viewContext);
              if (viewContext.navigator.canPop()) {
                viewContext.navigator.popUntil(
                      (route) {
                    return route == AppRoutes.homeRoute || route.isFirst;
                  },
                );

                viewContext.navigator.pushNamed(
                  AppRoutes.orderDetailsRoute,
                  arguments: new Order(id: orderId),
                );
              }
            });
      }
    } else {
      log("body dsffdfdfdf====>>>> in else");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Checkout".tr(),
        text: apiResponse.message,
      );
    }
    setBusy(false);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    viewContext.pop();
    viewContext.navigator.pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: new Order(id: orderId),
    );
    //showOrdersTab(context: viewContext);
    print("orderId====>>>>${orderId}");
    UpdateOrderStatus(id: orderId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    toastSuccessful(response.message ?? '');
    viewContext.pop();
    showOrdersTab(context: viewContext);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    //response.walletName ?? ''
    toastSuccessful(response.walletName ?? '');
  }

  double finalAmount;

  void createOrder(double amounts) async {
    finalAmount = amounts * 100;
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
  showOrdersTab({BuildContext context}) {
    //clear cart items
    CartServices.clearCart();
    //switch tab to orders
    AppService().changeHomePageIndex(index: 1);
    //pop until home page
    if (context != null) {
      context.navigator.popUntil(
            (route) {
          return route == AppRoutes.homeRoute || route.isFirst;
        },
      );
    }
  }

  //
  bool verifyVendorOrderAmountCheck() {
    //if vendor set min/max order
    final orderVendor = checkout?.cartItems?.first?.product?.vendor ?? vendor;
    //if order is less than the min allowed order by this vendor
    //if vendor is currently open for accepting orders

    if (!vendor.isOpen &&
        !(checkout.isScheduled ?? false) &&
        !(checkout.isPickup ?? false)) {
      //vendor is closed
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Vendor is not open".tr(),
        text: "Vendor is currently not open to accepting order at the moment"
            .tr(),
      );
      return false;
    } else if (orderVendor.minOrder != null &&
        orderVendor.minOrder > checkout.subTotal) {
      ///
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Minimum Order Value".tr(),
        text: "Order value/amount is less than vendor accepted minimum order"
            .tr() +
            "${AppStrings.currencySymbol} ${orderVendor.minOrder}"
                .currencyFormat(),
      );
      return false;
    }
    //if order is more than the max allowed order by this vendor
    else if (orderVendor.maxOrder != null &&
        orderVendor.maxOrder < checkout.subTotal) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Maximum Order Value".tr(),
        text: "Order value/amount is more than vendor accepted maximum order"
            .tr() +
            "${AppStrings.currencySymbol} ${orderVendor.maxOrder}"
                .currencyFormat(),
      );
      return false;
    }
    return true;
  }
}