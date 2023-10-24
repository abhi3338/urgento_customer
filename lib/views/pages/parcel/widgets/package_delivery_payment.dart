import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/views/pages/cart/widgets/amount_tile.dart';
import 'package:fuodz/views/pages/parcel/widgets/form_step_controller.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_delivery_discount_section.dart';
import 'package:fuodz/views/pages/parcel/widgets/parcel_order_payer.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/vendor_fees.view.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/payment_method.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PackageDeliveryPayment extends StatelessWidget {
  const PackageDeliveryPayment({this.vm, Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //info
        VStack(
          [
            UiSpacer.formVerticalSpace(),
            DottedBorder(
              dashPattern: [5, 1],
              color: AppColor.accentColor,
              child: ParcelDeliveryDiscountSection(vm)
                  .p20()
                  .box
                  .color(AppColor.accentColor.withOpacity(0.10))
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .make(),
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              padding: EdgeInsets.all(0),
            ).py12(),
            DottedLine().py12(),
            //payer
            ParcelOrderPayer(vm),
            DottedLine().py12(),

            "Payment".tr().text.xl2.semiBold.make().py12(),
            //payment details summary
            CustomVisibilty(
              visible: vm.busy(vm.packageCheckout),
              child: BusyIndicator().centered(),
            ),

            //summary error
            CustomVisibilty(
              visible: vm.hasErrorForKey(vm.packageCheckout),
              child: "${vm.error(vm.packageCheckout)}"
                  .tr()
                  .text
                  .red500
                  .makeCentered()
                  .box
                  .p12
                  .roundedSM
                  .border(color: Colors.grey[400])
                  .make()
                  .wFull(context),
            ),

            CustomVisibilty(
              visible: !vm.busy(vm.packageCheckout) &&
                  !vm.hasErrorForKey(vm.packageCheckout),
              child: VStack(
                [
                  AmountTile(
                    "Distance".tr(),
                    vm.packageCheckout.distance.numCurrency + " km",
                  ),
                  AmountTile(
                    "Delivery Charges".tr(),
                    "${vm.currencySymbol} ${vm.packageCheckout.deliveryFee}"
                        .currencyFormat(),
                  ),
                  AmountTile(
                    "Package Size Charges".tr(),
                    "${vm.currencySymbol} ${vm.packageCheckout.packageTypeFee}"
                        .currencyFormat(),
                  ),
                  DottedLine().py12(),
                  AmountTile(
                    "Subtotal".tr(),
                    "${vm.currencySymbol} ${vm.packageCheckout.subTotal ?? ''}"
                        .currencyFormat(),
                  ),
                  AmountTile(
                    "Discount".tr(),
                    "- " +
                        "${vm.currencySymbol} ${vm.packageCheckout.discount}"
                            .currencyFormat(),
                  ),
                  DottedLine().py12(),
                  AmountTile(
                    "Tax".tr() + " (${vm.packageCheckout.taxRate}%)",
                    "${vm.currencySymbol} ${vm.packageCheckout.tax ?? ''}"
                        .currencyFormat(),
                  ),
                  //fees
                  VendorFeesView(
                    fees: vm.packageCheckout.vendor.fees,
                    subTotal: vm.packageCheckout.subTotal,
                  ),
                  DottedLine().py12(),
                  //total
                  AmountTile(
                    "Total".tr(),
                    "${vm.currencySymbol} ${(vm.packageCheckout.total - vm.packageCheckout.discount) ?? ''}"
                        .currencyFormat(),
                  ),
                ],
              ),
            ),
            //
            UiSpacer.formVerticalSpace(),
            Divider(),
            UiSpacer.formVerticalSpace(),
            "Payment Methods".tr().text.semiBold.xl.make(),
            "Please select your mode of payment".tr().text.lg.make(),
            CustomGridView(
              noScrollPhysics: true,
              dataSet: vm.paymentMethods,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemBuilder: (context, index) {
                //
                final paymentMethod = vm.paymentMethods[index];
                return PaymentOptionListItem(
                  paymentMethod,
                  selected: paymentMethod == vm.selectedPaymentMethod,
                  onSelected: vm.changeSelectedPaymentMethod,
                );
              },
            ).pOnly(top: Vx.dp16),
          ],
        ).scrollVertical().expand(),

        //
        FormStepController(
          onPreviousPressed: () => vm.nextForm(5),
          nextTitle: "PLACE ORDER".tr(),
          nextBtnWidth: context.percentWidth * 45,
          onNextPressed: vm.selectedPaymentMethod != null && !vm.hasErrorForKey(vm.packageCheckout)
              ? vm.initiateOrderPayment
              : null,
        ),
      ],
    );
  }
}
