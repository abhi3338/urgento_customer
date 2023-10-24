import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/fee.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    this.subTotal,
    this.discount,
    this.deliveryFee,
    this.tax,
    this.vendorTax,
    this.fees,
    this.total,
    this.driverTip = 0.00,
    this.mCurrencySymbol,
    Key key,
    this.isAdditionalExpanded = false,
    this.onToggleExpanded
  }) : super(key: key);

  final double subTotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final String vendorTax;
  final double total;
  final double driverTip;
  final String mCurrencySymbol;
  final List<Fee> fees;
  final bool isAdditionalExpanded;
  final VoidCallback onToggleExpanded;
  @override
  Widget build(BuildContext context) {
    final currencySymbol = mCurrencySymbol != null ? mCurrencySymbol : AppStrings.currencySymbol;

    double appliedTaxes = 0.0;
    appliedTaxes += tax ?? 0.0;
    if (fees != null && fees.isNotEmpty) {
      fees.forEach((element) {
        if (element.percentage != 1) {
          appliedTaxes += element.value;
        } else {
          appliedTaxes += element.getRate(subTotal) ?? 0;
        }
      });
    }

    return VStack([

      "Order Summary".tr().text.semiBold.xl.make().pOnly(bottom: Vx.dp12),

      AmountTile(
        "Subtotal".tr(),
        "$currencySymbol ${subTotal ?? 0}".currencyFormat(currencySymbol),
      ).py2(),

      AmountTile(
        "Discount".tr(),
        "- " + "$currencySymbol ${discount ?? 0}".currencyFormat(currencySymbol),
      ).py2(),

      Visibility(
        visible: deliveryFee != null,
        child: AmountTile(
          "Delivery Fee".tr(),
          (deliveryFee ?? 0) <= 0
              ? "Free"
              : "+ " + "$currencySymbol ${(deliveryFee ?? 0).round()}".currencyFormat(currencySymbol),
        ).py2(),
      ),

      HStack([

        "Applied Taxes".text.make().expand(),

        UiSpacer.horizontalSpace(),

        "+ $currencySymbol ${(appliedTaxes ?? 0).toInt()}".currencyFormat(currencySymbol).text.semiBold.xl.make(),

        UiSpacer.horizontalSpace(space: 12),

        Icon(Icons.keyboard_arrow_down, color: AppColor.iconHintColor,)

      ])
          .onInkTap(() {
        if (onToggleExpanded != null) {
          onToggleExpanded();
        }
      })
          .py2(),

      if (isAdditionalExpanded)
        VStack([

          DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),

          AmountTile(
            "Tax (%s)".tr().fill(["${vendorTax ?? 0}%"]),
            "+ " + " $currencySymbol ${(tax ?? 0)}".currencyFormat(currencySymbol),
          ).py2(),

          Visibility(
            visible: fees != null && fees.isNotEmpty,
            child: VStack([
              ...((fees ?? []).map((fee) {

                if ((fee.percentage != 1)) {

                  return AmountTile(
                    "${fee.name}".tr(),
                    "+ " + " $currencySymbol ${(fee.value ?? 0)}".currencyFormat(currencySymbol),
                  ).py2();

                } else {

                  return AmountTile(
                    "${fee.name} (%s)".tr().fill(["${(fee.value ?? 0).round()}%"]),
                    "+ " + " $currencySymbol ${fee.getRate(subTotal) ?? 0}".currencyFormat(currencySymbol),
                  ).py2();

                }
              }).toList()),

            ]),
          ),

          DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),

        ]),

      // AmountTile(
      //   "Tax (%s)".tr().fill(["${vendorTax ?? 0}%"]),
      //   "+ " + " $currencySymbol ${tax ?? 0}".currencyFormat(currencySymbol),
      // ).py2(),

      // DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),

      // Visibility(
      //   visible: fees != null && fees.isNotEmpty,
      //   child: VStack([
      //     ...((fees ?? []).map((fee) {

      //       if ((fee.percentage != 1)) {

      //         return AmountTile(
      //           "${fee.name}".tr(),
      //           "+ " + " $currencySymbol ${fee.value ?? 0}".currencyFormat(currencySymbol),
      //         ).py2();

      //       } else {

      //         return AmountTile(
      //           "${fee.name} (%s)".tr().fill(["${fee.value ?? 0}%"]),
      //           "+ " + " $currencySymbol ${fee.getRate(subTotal) ?? 0}".currencyFormat(currencySymbol),
      //         ).py2();

      //       }
      //     }).toList()),

      //     DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),

      //   ]),
      // ),

      Visibility(
        visible: driverTip != null && driverTip > 0,
        child: VStack([

          AmountTile(
            "Driver Tip".tr(),
            "+ " + "$currencySymbol ${driverTip ?? 0}".currencyFormat(currencySymbol),
          ).py2(),

          DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),

        ]),
      ),

      AmountTile(
        "Total Amount".tr(),
        "$currencySymbol ${(total ?? 0)}".currencyFormat(currencySymbol),
      ),
    ]);
  }
}

