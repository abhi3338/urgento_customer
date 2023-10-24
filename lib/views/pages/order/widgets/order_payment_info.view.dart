import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/order.service.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class OrderPaymentInfoView extends StatelessWidget {
   OrderPaymentInfoView(this.vm, {Key key}) : super(key: key);
  final OrderDetailsViewModel vm;
  final _razorpay = Razorpay();
  bool isRazorpayLoading = false;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //payment is pending

        CustomVisibilty(
          visible: vm.order.isPaymentPending,
          child: CustomButton(
            title: "PAY FOR ORDER".tr(),
            titleStyle: context.textTheme.bodyLarge.copyWith(
              color: Colors.white,
            ),
            icon: FlutterIcons.credit_card_fea,
            iconSize: 18,
            onPressed: () async{
              print(vm.order.paymentMethod.name.toLowerCase());
              if(vm.order.paymentMethod.name.toLowerCase() == "pay online"){
                print("if part");
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                });
                print("order.total===>>>${vm.order.total}");
                print("order.id===>>>${vm.order.id}");
                orderdetailPageOrderId = vm.order.id;
                await createOrder(vm.order.total);
              }else{
                OrderService.openOrderPayment(vm.order, vm);
              }
            },
            //  {
            //   if ((vm.order?.paymentMethod?.slug ?? "offline") != "offline") {
            //     vm.openWebpageLink(vm.order.paymentLink);
            //   } else {
            //     vm.openExternalWebpageLink(vm.order.paymentLink);
            //   }
            // },
          ).p20().pOnly(bottom: Vx.dp20),
        ),
        //request payment
        CustomVisibilty(
          visible: (vm.order.paymentStatus == "request" && ["pending"].contains(vm.order.status)),
          child: CustomButton(
            title: "PAY FOR ORDER".tr(),
            titleStyle: context.textTheme.bodyLarge.copyWith(
              color: Colors.white,
            ),
            icon: FlutterIcons.credit_card_fea,
            iconSize: 18,
            loading: vm.busy(vm.order.paymentStatus),
            onPressed: () async{
              print(vm.order.paymentMethod.name.toLowerCase());
              if(vm.order.paymentMethod.name.toLowerCase() == "pay online"){
                print("if part");
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                });
                print("order.total===>>>${vm.order.total}");
                print("order.id===>>>${vm.order.id}");
                orderdetailPageOrderId = vm.order.id;
                await createOrder(vm.order.total);
              }else{
                vm.openPaymentMethodSelection;
              }
            },

          ).wFull(context).p20().pOnly(bottom: Vx.dp20),
        ),
      ],
    );
  }

   double finalAmount;

   void _handlePaymentSuccess(PaymentSuccessResponse response) {
     // Do something when payment succeeds
     // print(response);
     print("orderId====>>>>${orderdetailPageOrderId}");
     UpdateOrderStatus(id: orderdetailPageOrderId);
   }

   void _handlePaymentError(PaymentFailureResponse response) {
     print(response);
     // Do something when payment fails
     toastSuccessful(response.message ?? '');
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
