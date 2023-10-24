import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/order.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/orders.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/order.list_item.dart';
import 'package:fuodz/widgets/list_items/taxi_order.list_item.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:fuodz/widgets/states/error.state.dart';
import 'package:fuodz/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage>, WidgetsBindingObserver {
  //
  OrdersViewModel vm;
  final _razorpay = Razorpay();
  bool isRazorpayLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      vm.fetchMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return BasePage(
      body: SafeArea(
        child: ViewModelBuilder<OrdersViewModel>.reactive(
          viewModelBuilder: () => vm,
          onModelReady: (vm) => vm.initialise(),
          builder: (context, vm, child) {
            return VStack(
              [
                //

                "My Orders"
                    .tr()
                    .text
                    .xl2
                    .semiBold
                    .make()
                    .pOnly(bottom: Vx.dp10),
                //
                vm.isAuthenticated()
                    ? CustomListView(
                        canRefresh: true,
                        canPullUp: true,
                        refreshController: vm.refreshController,
                        onRefresh: vm.fetchMyOrders,
                        onLoading: () =>
                            vm.fetchMyOrders(initialLoading: false),
                        isLoading: vm.isBusy,
                        dataSet: vm.orders,
                        hasError: vm.hasError,
                        errorWidget: LoadingError(
                          onrefresh: vm.fetchMyOrders,
                        ),
                        //
                        emptyWidget: EmptyOrder(),
                        itemBuilder: (context, index) {
                          //
                          final order = vm.orders[index];
                          //for taxi tye of order
                          if (order.taxiOrder != null) {
                            return TaxiOrderListItem(
                              order: order,
                              orderPressed: () => vm.openOrderDetails(order),
                            );
                          }
                          return OrderListItem(
                            order: order,
                            onPayPressed: () async{
                              print("${order.paymentMethod.name.toLowerCase()}");
                              if(order.paymentMethod.name.toLowerCase() == "pay online"){
                                print("if pay part");
                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                                  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                                  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                                });
                                print("order.total===>>>${order.total}");
                                print("order.id===>>>${order.id}");
                                orderPageOrderId = order.id;
                                await createOrder(order.total);
                              }else{
                                print("else part");
                                OrderService.openOrderPayment(order, vm);
                              }
                            },
                            // {
                            //   if ((order?.paymentMethod?.slug ?? "offline") !=
                            //       "offline") {
                            //     vm.openWebpageLink(order.paymentLink);
                            //   } else {
                            //     vm.openExternalWebpageLink(order.paymentLink);
                            //   }
                            // },
                            orderPressed: (){
                              vm.openOrderDetails(order);
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            UiSpacer.verticalSpace(space: 2),
                      ).expand()
                    : EmptyState(
                        auth: true,
                        showAction: true,
                        actionPressed: vm.openLogin,
                      ).py12().centered().expand(),
              ],
            ).px20().pOnly(top: Vx.dp20);
          },
        ),
      ),
    );
  }
  double finalAmount;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    print("orderId====>>>>${orderPageOrderId}");
    UpdateOrderStatus(id: orderPageOrderId);
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

  @override
  bool get wantKeepAlive => true;
}
