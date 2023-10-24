import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiOrderListItem extends StatelessWidget {
  const TaxiOrderListItem({
    this.order,
    this.onPayPressed,
    this.orderPressed,
    Key key,
  }) : super(key: key);

  final Order order;
  final Function onPayPressed;
  final Function orderPressed;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = order.taxiOrder.currency != null
        ? order.taxiOrder.currency.symbol
        : AppStrings.currencySymbol;
    //
    return VStack(
      [
        //
        VStack(
          [
            //
            HStack(
              [
                Image.asset(AppImages.pickupLocation).wh(12, 12),
                UiSpacer.horizontalSpace(space: 10),
                "${order.taxiOrder.pickupAddress}"
                    .text
                    .medium
                    .overflow(TextOverflow.ellipsis)
                    .make()
                    .expand(),
              ],
            ),
            DottedLine(
              direction: Axis.vertical,
              lineThickness: 2,
              dashGapLength: 1,
              dashColor: AppColor.primaryColor,
            ).wh(1, 15).px4(),
            HStack(
              [
                Image.asset(AppImages.dropoffLocation).wh(12, 12),
                UiSpacer.horizontalSpace(space: 10),
                "${order.taxiOrder.dropoffAddress}"
                    .text
                    .medium
                    .overflow(TextOverflow.ellipsis)
                    .make()
                    .expand(),
              ],
            ),
          ],
        ).p20(),
        UiSpacer.divider(),
        //
        HStack(
          [
            //price
            CurrencyHStack(
              [
                "$currencySymbol ".text.semiBold.xl.make(),
                "${order.total.currencyValueFormat()}".text.semiBold.xl.make()
              ],
            ).expand(),
            //status
            "${order.Taxistatus.allWordsCapitilize() ?? ''}"
                .text
                .color(AppColor.getStausColor(order.status))
                .make(),
          ],
        ).py8().px20(),
      ],
    )
        .onInkTap(orderPressed)
        .card
        .elevation(3)
        .clip(Clip.antiAlias)
        .roundedSM
        .make();
  }
}
