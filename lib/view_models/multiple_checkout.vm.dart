import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dartx/dartx.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class MultipleCheckoutViewModel extends CheckoutBaseViewModel {
  List<Vendor> vendors = [];
  List<Map<String, dynamic>> orderData = [];
  double totalTax = 0;
  double totalDeliveryFee = 0;
  List<double> taxes = [];
  List<double> subtotals = [];
  final _razorpay = Razorpay();
  bool isRazorpayLoading = false;

  MultipleCheckoutViewModel(BuildContext context, CheckOut checkout) {
    this.viewContext = context;
    this.checkout = checkout;
  }

  //
  void initialise() async {
    super.initialise();
    fetchVendorsDetails();

    //
    updateTotalOrderSummary();
  }

  //
  fetchVendorsDetails() async {
    //
    vendors = CartServices.productsInCart
        .map((e) => e.product.vendor)
        .toList()
        .toSet()
        .toList();

    vendors = vendors.distinctBy((model) => model.id).toList();
    //
    setBusy(true);
    try {
      for (var i = 0; i < vendors.length; i++) {
        vendors[i] = await vendorRequest.vendorDetails(
          vendors[i].id,
          params: {
            "type": "brief",
          },
        );
      }
    } catch (error) {
      print("Error Getting Vendor Details ==> $error");
    }
    setBusy(false);
  }

  //update total/order amount summary
  updateTotalOrderSummary() async {
    //clear previous data
    checkout.tax = 0;
    checkout.deliveryFee = 0;
    orderData = [];
    totalTax = 0;
    totalDeliveryFee = 0;
    taxes = [];
    subtotals = [];

    //delivery fee
    if (!isPickup && deliveryAddress != null) {
      //selected delivery address is within range
      if (!delievryAddressOutOfRange) {
        //vendor charges per km
        setBusy(true);

        //
        for (var i = 0; i < vendors.length; i++) {
          //
          final mVendor = vendors[i];
          double mDeliveryFee = 0.0;

          //
          try {
            double orderDeliveryFee = await checkoutRequest.orderSummary(
              deliveryAddressId: deliveryAddress.id,
              vendorId: mVendor.id,
            );

            //adding base fee
            mDeliveryFee += orderDeliveryFee;
          } catch (error) {
            if (mVendor.chargePerKm != null && mVendor.chargePerKm == 1) {
              mDeliveryFee += mVendor.deliveryFee * deliveryAddress.distance;
            } else {
              mDeliveryFee += mVendor.deliveryFee;
            }

            //adding base fee
            mDeliveryFee += mVendor.baseDeliveryFee;
          }
          updateOrderData(mVendor, deliveryFee: mDeliveryFee);
          //
        }

        //
        setBusy(false);
      } else {
        checkout.deliveryFee = 0.00;
      }
    } else {
      checkout.deliveryFee = 0.00;

      for (var i = 0; i < vendors.length; i++) {
        final mVendor = vendors[i];
        updateOrderData(mVendor);
        //
      }
    }

    //total tax number
    totalTax = (totalTax / (100 * vendors.length)) * 100;
    //total
    checkout.total = (checkout.subTotal - checkout.discount) +
        totalDeliveryFee +
        checkout.tax;

    ////vendors
    for (var mVendor in vendors) {
      //vendor fees
      for (var fee in mVendor.fees) {
        if (fee.isPercentage) {
          checkout.total += fee.getRate(checkout.subTotal);
        } else {
          checkout.total += fee.value;
        }
      }
    }

    //
    updateCheckoutTotalAmount();
    updatePaymentOptionSelection();
    notifyListeners();
  }

//calcualte for each vendor and prepare jsonobject for checkout
  updateOrderData(Vendor mVendor, {double deliveryFee = 0.00}) {
    //tax
    double calTax = (double.parse(mVendor.tax ?? "0") / 100);
    double vendorSubtotal = CartServices.vendorSubTotal(mVendor.id);
    calTax = calTax * vendorSubtotal;
    checkout.tax += calTax;
    totalTax += double.parse(mVendor.tax ?? "0");
    totalDeliveryFee += deliveryFee;
    taxes.add(calTax);
    subtotals.add(vendorSubtotal);

    //
    double vendorDiscount = CartServices.vendorOrderDiscount(
      mVendor.id,
      checkout.coupon,
    );
    //total amount for that single order
    double vendorTotal = (vendorSubtotal - vendorDiscount) + deliveryFee + calTax;

    //fees
    List<Map> feesObjects = [];
    for (var fee in mVendor.fees) {
      double calFee = 0;
      String feeName = fee.name;
      if (fee.isPercentage) {
        calFee = fee.getRate(vendorSubtotal);
        feeName = "$feeName (${fee.value}%)";
      } else {
        calFee = fee.value;
      }

      //
      feesObjects.add({
        "id": fee.id,
        "name": feeName,
        "amount": calFee,
      });
      //add to total
      vendorTotal += calFee;
    }

    //
    final orderObject = {
      "vendor_id": mVendor.id,
      "delivery_fee": deliveryFee,
      "tax": calTax,
      "sub_total": vendorSubtotal,
      "discount": vendorDiscount,
      "tip": 0,
      "total": vendorTotal,
      "fees": feesObjects,
    };

    //prepare order data
    final orderDataIndex = orderData.indexWhere(
      (e) => e.containsKey("vendor_id") && e["vendor_id"] == mVendor.id,
    );
    if (orderDataIndex >= 0) {
      orderData[orderDataIndex] = orderObject;
    } else {
      orderData.add(orderObject);
    }
  }
  
  List orderIdList = [];

//
  processOrderPlacement() async {
    //process the order placement
    setBusy(true);
    //prepare order data
    orderData = orderData.map((e) {
      e.addAll({
        "products": CartServices.multipleVendorOrderPayload(e["vendor_id"]),
      });
      return e;
    }).toList();

    //set the total with discount as the new total
    checkout.total = checkout.totalWithTip;
    //
    final apiResponse = await checkoutRequest.newMultipleVendorOrder(
      checkout,
      tip: driverTipTEC.text,
      note: noteTEC.text,
      payload: {
        "data": orderData,
      },
    );
    print("1234 multivendor orderr resp=====>> ${apiResponse.body}");
    //not error
    if (apiResponse.allGood) {
      print("multivendor orderr resp=====>> ${apiResponse.body}");
      orderIdList.clear();
      orderIdList.add(apiResponse.body['orderId']);
      print("multivendor orderIdList resp=====>> ${orderIdList}");
      //any payment
      /*await AlertService.success(
        title: "Checkout".tr(),
        text: apiResponse.message,
      );*/


      // add razorpay code check pay online
      //sucess payment order api here
      if(checkout.paymentMethod.name.toLowerCase() == "pay online"){
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
              });
              print("order.total===>>>${checkout.totalWithTip}");
              print("order.id===>>>${checkout.cartItems[0].product.id}");
              print("order.id===>>>${checkout.cartItems[1].product.id}");
              // orderdetailPageOrderId = vm.order.id;
              await createOrder(checkout.totalWithTip);
              print("pay using online");
      }




      // showOrdersTab(context: viewContext);
      // if (viewContext.navigator.canPop()) {
      //   viewContext.navigator.popUntil(
      //             (route) {
      //               return route == AppRoutes.homeRoute || route.isFirst;
      //             },
      //           );
      // }
    } else {
      await AlertService.error(
        title: "Checkout".tr(),
        text: apiResponse.message,
      );
    }
    setBusy(false);
  }

  double finalAmount;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response);
    for (var value in orderIdList) {
      for(var fval in value){
        print("fval is===>>>>>>$fval");
        UpdateOrderStatus(id: fval);
      }
    }
    showOrdersTab(context: viewContext);
    if (viewContext.navigator.canPop()) {
      viewContext.navigator.popUntil(
            (route) {
          return route == AppRoutes.homeRoute || route.isFirst;
        },
      );
    }
    // checkout.cartItems.forEach((element) {
    //   print("foreach data----->>>${element.product.id}");
    //   UpdateOrderStatus(id: element.product.id);
    // });
    // print("orderId====>>>>${orderdetailPageOrderId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    toastSuccessful(response.message ?? '');
    showOrdersTab(context: viewContext);
    if (viewContext.navigator.canPop()) {
      viewContext.navigator.popUntil(
            (route) {
          return route == AppRoutes.homeRoute || route.isFirst;
        },
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    //response.walletName ?? ''
    toastSuccessful(response.walletName ?? '');
  }

  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void createOrder(double amounts) async {
    finalAmount = amounts * 100;
    print("final amt is====>>>>${finalAmount}");
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
