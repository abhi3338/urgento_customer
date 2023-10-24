import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/requests/cart.request.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class ServiceBookingSummaryViewModel extends CheckoutBaseViewModel {
  //
  ServiceBookingSummaryViewModel(BuildContext context, this.service) {
    this.viewContext = context;
    vendor = service.vendor;
    AppService().vendorId = vendor.id;
    fetchPaymentOptions();

    //prepare checkout
    checkout = CheckOut();
    final subTotal = double.parse(
        ((service.showDiscount ? service.discountPrice : service.price) *
            (!(service.isFixed) ? (service.selectedQty ?? 1) : 1))
            .toString());
    checkout.subTotal = subTotal;
  }
//
  CartRequest cartRequest = CartRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
  TextEditingController noteTEC = TextEditingController();
  //coupons
  bool canApplyCoupon = false;
  Coupon coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  CheckOut checkout = CheckOut();
  Service service;
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;
  //
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod selectedPaymentMethod;

  final _razorpay = Razorpay();
  bool isRazorpayLoading = false;

  void initialise() async {
    fetchPaymentOptions();
    updateTotalOrderSummary();
  }

  //get payment options
  fetchPaymentOptions({int vendorId}) async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions(
        vendorId: vendorId ?? service.vendor.id,
      );
      //
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  isSelected(PaymentMethod paymentMethod) {
    return selectedPaymentMethod != null &&
        paymentMethod.id == selectedPaymentMethod.id;
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
      coupon = await cartRequest.fetchCoupon(
        couponTEC.text,
        vendorTypeId: vendor?.vendorType?.id,
      );
      //
      if (coupon.useLeft <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon.expired) {
        throw "Coupon has expired".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      //
      if (coupon.percentage == 1) {
        checkout.discount = (coupon.discount / 100) * checkout.subTotal;
      } else {
        checkout.discount = coupon.discount;
      }
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon, error);
    }
    setBusyForObject(coupon, false);
  }

  //
  //
  placeOrder({bool ignore = false}) async {
    //
    if (isScheduled && checkout.deliverySlotDate.isEmptyOrNull) {
      //
      AlertService.error(
        title: "Schedule Date".tr(),
        text: "Please select your desire order date".tr(),
      );
    } else if (isScheduled && checkout.deliverySlotTime.isEmptyOrNull) {
      //
      AlertService.error(
        title: "Schedule Time".tr(),
        text: "Please select your desire order time".tr(),
      );
    } else if (!isPickup && service.location && deliveryAddress == null) {
      //
      AlertService.error(
        title: "Booking address".tr(),
        text: "Please select booking address".tr(),
      );
    } else if (service.location && delievryAddressOutOfRange && !isPickup) {
      //
      AlertService.error(
        title: "Booking address".tr(),
        text: "Booking address is out of vendor booking range".tr(),
      );
    } else if (selectedPaymentMethod == null) {
      AlertService.error(
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
    //
    final apiResponse = await checkoutRequest.newServiceOrder(
      checkout,
      fees: calFees,
      service: service,
      note: noteTEC.text,
    );
    //not error
    if (apiResponse.allGood) {
      //cash payment
      print("newServiceOrder====>>>>>${apiResponse.body}");
      final paymentLink = apiResponse.body["link"].toString();
      serviceBookingId = apiResponse.body["orderId"];
      if (!paymentLink.isEmptyOrNull) {
        print("paymentMethod  ${checkout.paymentMethod.name.toLowerCase()}");
        if(checkout.paymentMethod.name.toLowerCase() == "pay online"){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
            _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
            _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
          });
          await createOrder(checkout?.total);
        }else{
          viewContext.pop();
          showOrdersTab();
          openintWebpageLink(paymentLink);
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
              showOrdersTab();
              viewContext.pop(true);
              if (viewContext.navigator.canPop()) {
                viewContext.navigator.popUntil(
                      (route) {
                    return route == AppRoutes.homeRoute || route.isFirst;
                  },
                );
                viewContext.navigator.pushNamed(
                  AppRoutes.orderDetailsRoute,
                  arguments: new Order(id: serviceBookingId),
                );
              }
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
    setBusy(false);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    viewContext.pop();
    viewContext.navigator.pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: new Order(id: serviceBookingId),
    );
    //showOrdersTab(context: viewContext);
    print("orderId====>>>>${serviceBookingId}");
    UpdateOrderStatus(id: serviceBookingId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    viewContext.pop();
    showOrdersTab(context: viewContext);
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
}