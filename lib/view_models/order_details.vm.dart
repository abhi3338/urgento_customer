import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/requests/order.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/chat.service.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:fuodz/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:fuodz/widgets/bottomsheets/driver_rating.bottomsheet.dart';
import 'package:fuodz/widgets/bottomsheets/order_cancellation.bottomsheet.dart';
import 'package:fuodz/widgets/bottomsheets/vendor_rating.bottomsheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/view_models/order_tracking.vm.dart';


class OrderDetailsViewModel extends CheckoutBaseViewModel {
  //
  Order order;
  OrderRequest orderRequest = OrderRequest();

  //
  OrderDetailsViewModel(BuildContext context, this.order) {
    this.viewContext = context;
    this.profileViewModel = new ProfileViewModel(context);
    this.profileViewModel.initialise();
    this.orderTrackingViewModel = new OrderTrackingViewModel(context, this.order);
    this.orderTrackingViewModel.initialise();


  }

  ProfileViewModel profileViewModel;
  OrderTrackingViewModel orderTrackingViewModel;


  initialise() {
    fetchOrderDetails();
    fetchPaymentOptions();
  }

  void callVendor() {
    launchUrlString("tel:${order.vendor.phone}");
  }

  void callsup() {
    launchUrlString("tel:${AppStrings.emergencyContact}");
  }

  void callDriver() {
    launchUrlString("tel:${order.driver.phone}");
  }

  void callRecipient() {
    launchUrlString("tel:${order.recipientPhone}");
  }

  chatVendor() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      'vendor_${order.vendor.id}': PeerUser(
        id: "vendor_${order.vendor.id}",
        name: order.vendor.name,
        image: order.vendor.logo,
      ),
    };
    //
    final chatEntity = ChatEntity(
      onMessageSent: ChatService.sendChatMessage,
      mainUser: peers['${order.userId}'],
      peers: peers,
      //don't translate this
      path: 'orders/' + order.code + "/customerVendor/chats",
      title: "Chat with vendor".tr(),
    );
    //
    viewContext.navigator.pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  chatDriver() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      '${order.driver.id}': PeerUser(
          id: "${order.driver.id}",
          name: order.driver.name,
          image: order.driver.photo),
    };
    //
    final chatEntity = ChatEntity(
      mainUser: peers['${order.userId}'],
      peers: peers,
      //don't translate this
      path: 'orders/' + order.code + "/customerDriver/chats",
      title: "Chat with driver".tr(),
      onMessageSent: ChatService.sendChatMessage,
    );
    //
    viewContext.navigator.pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  void fetchOrderDetails() async {
    if (refreshController != null) {
      refreshController.refreshCompleted();
      notifyListeners();
    }
    setBusy(true);
    try {
      order = await orderRequest.getOrderDetails(id: order.id);
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }

  refreshDataSet() {
    fetchOrderDetails();
  }

  //
  rateVendor() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return VendorRatingBottomSheet(
          order: order,
          onSubmitted: () {
            //
            viewContext.pop();
            fetchOrderDetails();
          },
        );
      },
    );
  }

  //
  rateDriver() async {
    await viewContext.push(
      (context) => DriverRatingBottomSheet(
        order: order,
        onSubmitted: () {
          //
          viewContext.pop();
          fetchOrderDetails();
        },
      ),
    );
  }

  //
  trackOrder() {
    viewContext.navigator
        .pushNamed(AppRoutes.orderTrackingRoute, arguments: order);
  }

  cancelOrder() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return OrderCancellationBottomSheet(
          onSubmit: (String reason) {
            viewContext.pop();
            processOrderCancellation(reason);
          },
        );
      },
    );
  }

  //
  processOrderCancellation(String reason) async {
    setBusyForObject(order, true);
    try {
      final responseMessage = await orderRequest.updateOrder(
        id: order.id,
        status: "cancelled",
        reason: reason,
      );
      //
      order.status = "cancelled";
      //message
      viewContext.showToast(
        msg: responseMessage,
        bgColor: Colors.green,
        textColor: Colors.white,
      );

      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
    setBusyForObject(order, false);
  }

  void showVerificationQRCode() async {
    showDialog(
      context: viewContext,
      builder: (context) {
        return Dialog(
          child: VStack(
            [
              QrImage(
                data: order.verificationCode,
                version: QrVersions.auto,
                size: viewContext.percentWidth * 40,
              ).box.makeCentered(),
              "${order.verificationCode}".text.medium.xl2.makeCentered().py4(),
              "Verification Code".tr().text.light.sm.makeCentered().py8(),
            ],
          ).p20(),
        );
      },
    );
  }

  void shareOrderDetails() async {
    Share.share(
        "%s is sharing an order code with you. Track order with this code: %s"
            .tr()
            .fill(
      [
        order.user.name,
        order.code,
      ],
    ));
  }

  openPaymentMethodSelection() async {
    //
    setBusyForObject(order.paymentStatus, true);
    await fetchPaymentOptions(vendorId: order.vendorId);
    setBusyForObject(order.paymentStatus, false);
    await
        //
        showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (contex) {
        return PaymentMethodsView(this)
            .p20()
            .scrollVertical()
            .box
            .color(contex.backgroundColor)
            .topRounded()
            .make();
      },
    );
  }

  changeSelectedPaymentMethod(
    PaymentMethod paymentMethod, {
    bool callTotal = true,
  }) async {
    //
    viewContext.pop();
    setBusyForObject(order.paymentStatus, true);
    try {
      //
      ApiResponse apiResponse = await orderRequest.updateOrderPaymentMethod(
        id: order.id,
        paymentMethodId: paymentMethod.id,
        status: "pending",
      );

      //
      order = Order.fromJson(apiResponse.body["order"]);
      if (!["wallet", "cash"].contains(paymentMethod.slug)) {
        if (paymentMethod.slug == "offline") {
          openWebpageLink(order.paymentLink);
        } else {
          openWebpageLink(order.paymentLink);
        }
      } else {
        toastSuccessful("${apiResponse.body['message']}");
      }

      //notify wallet view to update, just incase wallet was use for payment
      AppService().refreshWalletBalance.add(true);
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(order.paymentStatus, false);
  }
}
