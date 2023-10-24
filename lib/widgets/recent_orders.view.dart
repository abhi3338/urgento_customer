import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/recent_order.vm.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/order.list_item.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class RecentOrdersView extends StatelessWidget {
   RecentOrdersView({Key key, this.vendorType}) : super(key: key);

  final VendorType vendorType;
  bool isRazorpayLoading = false;
  final _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecentOrderViewModel>.reactive(
      viewModelBuilder: () => RecentOrderViewModel(
        context,
        vendorType: vendorType,
      ),
      onModelReady: (vm) => vm.fetchMyOrders(),
      builder: (context, vm, child) {
        return VStack(
          [
            //
            if (!vm.isBusy && vm.orders != null && vm.orders.isNotEmpty) ...[
              "Recent Orders".tr().text.make(),
              UiSpacer.verticalSpace(),
            ],
            //orders
            vm.isAuthenticated()
                ? CustomListView(
                    isLoading: vm.isBusy,
                    noScrollPhysics: true,
                    dataSet: vm.orders,
                    itemBuilder: (context, index) {
                      //
                      final order = vm.orders[index];
                      return OrderListItem(
                        order: order,
                        orderPressed: (){
                          vm.openOrderDetails(order);
                        },
                        onPayPressed: () async{
                          if(order.paymentMethod.name.toLowerCase() == "pay online"){
                            print("order.total====>>>${order.total}");
                            print("order.id====>>>${order.id}");
                            recentUserId = order.id;
                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                              _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                              _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                            });
                            await createOrder(order.total.toDouble());
                          }else{
                            vm.openExternalWebpageLink(order.paymentLink);
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 2),
                  )
                : EmptyState(
                    auth: true,
                    showAction: true,
                    actionPressed: vm.openLogin,
                  ).py12().centered(),
          ],
        ).px20();
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    UpdateOrderStatus(id: recentUserId);
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
