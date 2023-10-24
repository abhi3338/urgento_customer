import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/multiple_checkout.vm.dart';
import 'package:fuodz/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/multiple_vendor_order_summary.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class MultipleOrderCheckoutPage extends StatelessWidget {
   MultipleOrderCheckoutPage({this.checkout, Key key}) : super(key: key);

  final CheckOut checkout;
   final _razorpay = Razorpay();
   bool isRazorpayLoading = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MultipleCheckoutViewModel>.reactive(
      viewModelBuilder: () => MultipleCheckoutViewModel(context, checkout),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Multiple Order Checkout".tr(),
          body: VStack(
            [
              //
              UiSpacer.verticalSpace(),
              //
              CustomTextFormField(
                labelText: "Note".tr(),
                textEditingController: vm.noteTEC,
              ),

              //note
              Divider(thickness: 3).py12(),

              //pickup time slot
              ScheduleOrderView(vm),

              //its pickup
              OrderDeliveryAddressPickerView(vm),

              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              MultipleVendorOrderSummary(
                subTotal: vm.checkout.subTotal,
                discount: vm.checkout.discount,
                deliveryFee: vm.totalDeliveryFee,
                tax: vm.checkout.tax,
                taxes: vm.taxes,
                vendors: vm.vendors,
                subtotals: vm.subtotals,
                driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
                total: vm.checkout.totalWithTip,
              ),

              //show notice it driver should be paid in cash
              CheckoutDriverCashDeliveryNoticeView(vm.checkout.deliveryAddress),
              //
              CustomButton(
                title: "PLACE ORDER".tr().padRight(14),
                icon: FlutterIcons.credit_card_fea,
                onPressed: vm.placeOrder,
                // onPressed: () async{
                //   if(vm.selectedPaymentMethod.name.toLowerCase() == "pay online"){
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                //       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                //       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                //     });
                //     print("order.total===>>>${vm.checkout.totalWithTip}");
                //     print("order.id===>>>${checkout.cartItems[0].product.id}");
                //     print("order.id===>>>${checkout.cartItems[1].product.id}");
                //     // orderdetailPageOrderId = vm.order.id;
                //     await createOrder(vm.checkout.totalWithTip);
                //     print("pay using online");
                //   }else{
                //     print("pay using another method");
                //     vm.placeOrder;
                //   }
                // },
                loading: vm.isBusy,
              ).centered().py16(),
            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}
