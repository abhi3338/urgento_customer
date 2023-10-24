import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class MultipleVendorOrderSummary extends StatelessWidget {
  const MultipleVendorOrderSummary({
    this.subTotal,
    this.discount,
    this.deliveryFee,
    this.tax,
    this.vendorTax,
    this.total,
    this.driverTip = 0.00,
    this.mCurrencySymbol,
    this.taxes,
    this.vendors,
    this.subtotals,
    Key key,
  }) : super(key: key);

  final double subTotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final String vendorTax;
  final double total;
  final double driverTip;
  final String mCurrencySymbol;
  final List<dynamic> taxes;
  final List<dynamic> vendors;
  final List<double> subtotals;
  @override
  Widget build(BuildContext context) {
    final currencySymbol =
        mCurrencySymbol != null ? mCurrencySymbol : AppStrings.currencySymbol;
    return VStack(
      [
        "Order Summary".tr().text.semiBold.xl.make().pOnly(bottom: Vx.dp12),
        AmountTile("Subtotal".tr(), (subTotal ?? 0).currencyValueFormat())
            .py2(),
        AmountTile(
          "Discount".tr(),
          "- " + "$currencySymbol ${discount ?? 0}".currencyFormat(),
        ).py2(),
        AmountTile(
          "Delivery Fee".tr(),
          "+ " + "$currencySymbol ${deliveryFee ?? 0}".currencyFormat(),
        ).py2(),
        //
        "Note: Delivery fee for each vendor is sum up to get the total delivery fee"
            .tr()
            .text
            .sm
            .gray600
            .italic
            .make(),
        DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
        // AmountTile(
        //   "Tax".tr(),
        //   "+ " + " $currencySymbol ${tax ?? 0}".currencyFormat(),
        // ).py2(),
        //vendor fees like tax summary
        ...vendorAmounts(context, taxes, vendors, subtotals),

        DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
        Visibility(
          visible: driverTip != null && driverTip > 0,
          child: VStack(
            [
              AmountTile(
                "Driver Tip".tr(),
                "+ " + "$currencySymbol ${driverTip ?? 0}".currencyFormat(),
              ).py2(),
              DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
            ],
          ),
        ),
        AmountTile(
          "Total Amount".tr(),
          "$currencySymbol ${total ?? 0}".currencyFormat(),
        ),
      ],
    );
  }

  List<Widget> vendorAmounts(
    BuildContext context,
    List<dynamic> taxes,
    List<dynamic> vendors,
    List<double> subtotals,
  ) {
    final currencySymbol =
        mCurrencySymbol != null ? mCurrencySymbol : AppStrings.currencySymbol;
    List<Widget> items = [];
    for (var i = 0; i < taxes.length; i++) {
      final vendor = vendors[i] as Vendor;
      double vendorSumTotalFees = 0;
      double vendorSubtotal = subtotals[i];
      double vendorCalTax = taxes[i];
      vendorSumTotalFees += subtotals[i] ?? 0;
      vendorSumTotalFees += vendorCalTax;

      Widget widget = VStack(
        [
          "${vendor.name}".text.semiBold.xl.make(),
          AmountTile(
            "Subtotal".tr(),
            " $currencySymbol ${vendorSubtotal ?? 0}".currencyFormat(),
          ).py1(),
          AmountTile(
            "Tax (%s)".tr().fill(["${vendor.tax}%"]),
            " $currencySymbol ${vendorCalTax ?? 0}"
                .currencyFormat(currencySymbol),
          ).py1(),
          ...(vendor.fees.map((fee) {
            //fixed
            if ((fee.percentage != 1)) {
              //
              vendorSumTotalFees += fee.value;
              //
              return AmountTile(
                "${fee.name}".tr(),
                "$currencySymbol ${fee.value ?? 0}"
                    .currencyFormat(currencySymbol),
              ).py1();
            } else {
              //
              vendorSumTotalFees += fee.getRate(vendorSubtotal);
              //percentage
              return AmountTile(
                "${fee.name} (%s)".tr().fill(["${fee.value ?? 0}%"]),
                "$currencySymbol ${fee.getRate(vendorSubtotal) ?? 0}"
                    .currencyFormat(currencySymbol),
              ).py1();
            }
          }).toList()),
          //
          DottedLine(
              dashColor: context.textTheme.bodyLarge.color.withOpacity(0.3)),
          AmountTile(
            "",
            " $currencySymbol ${vendorSumTotalFees ?? 0}"
                .currencyFormat(currencySymbol),
          ).py1(),
          DottedLine(
              dashColor: context.textTheme.bodyLarge.color.withOpacity(0.3)),
        ],
      ).box.p8.border(color: Utils.textColorByTheme()).roundedSM.make().py2();
      items.add(widget);
    }
    return items;
  }
}
