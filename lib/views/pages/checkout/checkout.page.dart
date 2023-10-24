import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/checkout.vm.dart';
import 'package:fuodz/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/order_summary.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter/services.dart';

import 'widgets/delivery_tip.view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({this.checkout, Key key}) : super(key: key);

  final CheckOut checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(context, checkout),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        final currencySymbol =  AppStrings.currencySymbol;
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Checkout".tr(),
          body: VStack([

            VStack([

              ScheduleOrderView(vm),

              OrderDeliveryAddressPickerView(vm),

              "Tip Your Deliver Partner".text.semiBold.xl.color(Utils.textColorByBrightness(context)).make(),
            UiSpacer.verticalSpace(space: 10),
              
              ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: vm.tipsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return DeliveryTipView(
                    value: vm.tipsList[index],
                    model: vm,
                    selectedValue: vm.selectedTip,
                  ).onTap(() => vm.onTipSelect(vm.tipsList[index]));
                },
              ).h(34.0),

              SizedBox(height: 20.0,),

              Visibility(
                visible: ((!vm.isPickup ?? true) && (vm.selectedTip != null && vm.selectedTip.toLowerCase() == "custom")),
                child: CustomTextFormField(
                  labelText:
                  "Enter custom tip ".tr() + " (${AppStrings.currencySymbol})",
                  textEditingController: vm.driverTipTEC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => vm.updateCheckoutTotalAmount(),
                ).pOnly(bottom: Vx.dp20),
              ),

              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),
              SizedBox(height: 20.0,),
              CustomTextFormField(
                labelText: "Enter instructions to delivery partner".tr(),
                textEditingController: vm.noteTEC,
              ),
              SizedBox(height: 20.0,),
              // Divider(thickness: 3).py12(),

              OrderSummary(
                subTotal: vm.checkout.subTotal,
                discount: vm.checkout.discount,
                deliveryFee: vm.checkout.deliveryFee,
                tax: vm.checkout.tax,
                vendorTax: vm.vendor.tax,
                driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
                total: vm.checkout.totalWithTip,
                fees: vm.vendor.fees,
                isAdditionalExpanded: vm.isExpanded,
                onToggleExpanded: vm.expandedToggle,
              ),

              CheckoutDriverCashDeliveryNoticeView(vm.checkout.deliveryAddress),

              vm.isRazorpayLoading
              ? Center(child: CircularProgressIndicator(color: Vx.white))
              : SizedBox()

            ], axisSize: MainAxisSize.max, crossAlignment: CrossAxisAlignment.start,)
            .p20()
            .scrollVertical()
            .expand(),

            HStack([

              //"$currencySymbol ${subTotal ?? 0}".currencyFormat(currencySymbol)

              HStack([

                "Total".text.semiBold.xl.make(),

                UiSpacer.horizontalSpace(),

                "+ $currencySymbol ${vm.checkout.totalWithTip}".currencyFormat(currencySymbol).text.semiBold.xl.make(),
              
              ])
              .w(140.0),

              UiSpacer.horizontalSpace(),
              (vm.deliveryAddress != null)?CustomButton(
                title: "Confirm Order".tr().padRight(14),
                onPressed: vm.placeOrder,
                loading: vm.isBusy,
              )
                  .expand(flex: 1):CustomButton(
                title: "Select Address".tr(),
                onPressed: vm.showDeliveryAddressPicker,
              ).expand(flex: 1)

            ])
            .safeArea()
            .wFull(context)
            .p12()
          ]),
          // body: VStack([
          //
          //   ScheduleOrderView(vm),
          //
          //   OrderDeliveryAddressPickerView(vm),
          //
          //   Visibility(
          //     visible: !vm.isPickup ?? true,
          //     child: CustomTextFormField(
          //       labelText:
          //       "Tip your delivery partner Ex:10,20,30,50,100,150.. ".tr() + " (${AppStrings.currencySymbol})",
          //       textEditingController: vm.driverTipTEC,
          //       keyboardType: TextInputType.number,
          //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //       onChanged: (value) => vm.updateCheckoutTotalAmount(),
          //     ).pOnly(bottom: Vx.dp20),
          //   ),
          //
          //   Visibility(
          //     visible: vm.canSelectPaymentOption,
          //     child: PaymentMethodsView(vm),
          //   ),
          //
          //   CustomTextFormField(
          //     labelText: "Enter instructions to delivery partner".tr(),
          //     textEditingController: vm.noteTEC,
          //   ),
          //
          //   Divider(thickness: 3).py12(),
          //
          //   OrderSummary(
          //     subTotal: vm.checkout.subTotal,
          //     discount: vm.checkout.discount,
          //     deliveryFee: vm.checkout.deliveryFee,
          //     tax: vm.checkout.tax,
          //     vendorTax: vm.vendor.tax,
          //     driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
          //     total: vm.checkout.totalWithTip,
          //     fees: vm.vendor.fees,
          //     isAdditionalExpanded: vm.isExpanded,
          //     onToggleExpanded: vm.expandedToggle,
          //   ),
          //
          //   CheckoutDriverCashDeliveryNoticeView(vm.checkout.deliveryAddress),
          //
          //   vm.isRazorpayLoading
          //   ? Center(child: CircularProgressIndicator(color: Vx.white))
          //   : SizedBox()
          //   ,
          // ]).p20().scrollVertical(),
          //
          //
          // bottomNavigationBar: Material(
          //   child:SafeArea(
          //     child:
          //
          //     CustomButton(
          //       title: "Confirm Order".tr().padRight(14),
          //       onPressed: vm.placeOrder,
          //       loading: vm.isBusy,
          //     ).py16(),
          //
          //
          //
          //   )
          //
          //
          // ),


        );
      },


    );
  }
}
