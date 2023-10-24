import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/tax_order_location.history.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiOrderHistoryListItem extends StatelessWidget {
  const TaxiOrderHistoryListItem(this.taxiOrderLocationHistory,
      {Key key, this.onPressed})
      : super(key: key);

  final TaxiOrderLocationHistory taxiOrderLocationHistory;
  final Function(TaxiOrderLocationHistory) onPressed;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        Icon(
          FlutterIcons.location_pin_ent,
          size: 24,
          color: Colors.grey.shade600,
        ),
        VStack(
          [
            "${taxiOrderLocationHistory.address}"
                .text
                .semiBold
                .lg
                .maxLines(1)
                .ellipsis
                .make(),
            UiSpacer.vSpace(3),
            "${taxiOrderLocationHistory.latitude},${taxiOrderLocationHistory.longitude}"
                .text
                .maxLines(1)
                .ellipsis
                .sm
                .make(),
          ],
        ).px12().expand(),
        Icon(
          Utils.isArabic
              ? FlutterIcons.chevron_left_ent
              : FlutterIcons.chevron_right_ent,
          size: 18,
          color: Colors.grey.shade300,
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).py8().onInkTap(
      () {
        onPressed(taxiOrderLocationHistory);
      },
    ).material(color: context.theme.colorScheme.background);
  }
}


