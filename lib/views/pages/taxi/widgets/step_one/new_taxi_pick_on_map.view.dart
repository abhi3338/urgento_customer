import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiPickOnMapButton extends StatelessWidget {
  const NewTaxiPickOnMapButton({
    Key key,
    @required this.taxiNewOrderViewModel,
  }) : super(key: key);

  final NewTaxiOrderLocationEntryViewModel taxiNewOrderViewModel;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: taxiNewOrderViewModel.showChooseOnMap,
      child: HStack(
        [
          Icon(
            FlutterIcons.map_ent,
            color: AppColor.primaryColor,
          ),
          "Choose a place on the map"
              .tr()
              .text
              .lg
              .medium
              .make()
              .px16()
              .expand(),
          Icon(
            Utils.isArabic
                ? FlutterIcons.chevron_left_ent
                : FlutterIcons.chevron_right_ent,
            color: Colors.grey.shade300,
          )
        ],
      )
          .p12()
          .box
          .color(Utils.textColorByBrightness(context, true))
          .shadowSm
          .make()
          .onInkTap(taxiNewOrderViewModel.handleChooseOnMap),
    );
  }
}
