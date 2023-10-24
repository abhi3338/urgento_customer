import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/loyalty_point_report.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class LoyaltyPointReportListItem extends StatelessWidget {
  const LoyaltyPointReportListItem(this.loyaltyPointReport, {Key key})
      : super(key: key);

  final LoyaltyPointReport loyaltyPointReport;
  @override
  Widget build(BuildContext context) {
    final stateColor =
        (loyaltyPointReport.isCredit ? Colors.green : Colors.red);
    final textColor = Utils.textColorByColor(stateColor);

    //
    return HStack(
      [
        //icon
        Icon(
          loyaltyPointReport.isCredit
              ? FlutterIcons.plus_ant
              : FlutterIcons.minus_ant,
          color: stateColor.withAlpha(255),
        ).px12(),
        //credit
        Visibility(
          visible: loyaltyPointReport.isCredit,
          child: VStack(
            [
              HStack(
                [
                  "${loyaltyPointReport.points}".text.color(textColor).semiBold.xl.make(),
                  "points".tr().text.color(textColor).semiBold.sm.make().expand(),
                ],
              ),
              ("Rewarded points".tr()).text.color(textColor).sm.make(),
            ],
          ).expand(),
        ),
        //debit
        Visibility(
          visible: !loyaltyPointReport.isCredit,
          child: VStack(
            [
              HStack(
                [
                  "${loyaltyPointReport.points}".text.color(textColor).semiBold.xl.make(),
                  "points".tr().text.color(textColor).semiBold.sm.make().expand(),
                ],
              ),
              ("Withdrawn to wallet".tr()).text.color(textColor).sm.make(),
            ],
          ).expand(),
        ),

        //
        "${DateFormat.MMMd(translator.activeLocale.languageCode).format(loyaltyPointReport.updatedAt)}"
            .text
            .color(textColor)
            .light
            .make(),
      ],
    )
        .p8()
        .box
        .outerShadow
        .color(stateColor.withAlpha(120))
        .roundedSM
        .clip(Clip.antiAlias)
        .make()
        .px2();
  }
}
