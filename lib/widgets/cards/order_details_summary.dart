import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDetailsSummary extends StatelessWidget {
  const OrderDetailsSummary(
    this.order, {
    Key key,
  }) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppStrings.currencySymbol;
    return VStack(
      [
        "Order Summary".tr().text.semiBold.xl.make().pOnly(bottom: Vx.dp12),
        AmountTile("Subtotal".tr(), (order.subTotal ?? 0).currencyValueFormat())
            .py2(),
        AmountTile(
          "Discount".tr(),
          "- " +
              "$currencySymbol ${order.discount ?? 0}"
                  .currencyFormat(currencySymbol),
        ).py2(),
        Visibility(
          visible: order.deliveryFee != null,
          child: AmountTile(
            "Delivery Fee".tr(),
            "+ " +
                "$currencySymbol ${order.deliveryFee ?? 0}"
                    .currencyFormat(currencySymbol),
          ).py2(),
        ),
        AmountTile(
          "Tax (%s)".tr().fill(["${order.taxRate ?? 0}%"]),
          "+ " +
              " $currencySymbol ${order.tax ?? 0}"
                  .currencyFormat(currencySymbol),
        ).py2(),
        DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
        Visibility(
          visible: order.fees != null && order.fees.isNotEmpty,
          child: VStack(
            [
              ...(order.fees.map((fee) {
                return AmountTile(
                  "${fee.name}".tr(),
                  "+ " +
                      " $currencySymbol ${fee.amount ?? 0}"
                          .currencyFormat(currencySymbol),
                ).py2();
              }).toList()),
              DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
            ],
          ),
        ),
        Visibility(
          visible: order.tip != null && order.tip > 0,
          child: VStack(
            [
              AmountTile(
                "Driver Tip".tr(),
                "+ " +
                    "$currencySymbol ${order.tip ?? 0}"
                        .currencyFormat(currencySymbol),
              ).py2(),
              DottedLine(dashColor: context.textTheme.bodyLarge.color).py8(),
            ],
          ),
        ),
        AmountTile(
          "Total Amount".tr(),
          "$currencySymbol ${order.total ?? 0}".currencyFormat(currencySymbol),
        ),
      ],
    );
  }
}
