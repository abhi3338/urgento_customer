import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiOrderScheduleView extends StatelessWidget {
  const NewTaxiOrderScheduleView(
    this.newTaxiOrderLocationEntryViewModel, {
    Key key,
  }) : super(key: key);

  final NewTaxiOrderLocationEntryViewModel newTaxiOrderLocationEntryViewModel;
  @override
  Widget build(BuildContext context) {
    //
    final TaxiViewModel vm = newTaxiOrderLocationEntryViewModel.taxiViewModel;
    //
    return CustomVisibilty(
      visible: AppStrings.canScheduleTaxiOrder ?? false,
      child: VStack(
        [
          //show schedule checkbox
          HStack(
            [
              "Schedule Order".tr().text.medium.lg.make().expand(),
              UiSpacer.hSpace(),
              //clear
              Visibility(
                visible: vm.checkout.pickupDate != null,
                child: HStack(
                  [
                    Icon(
                      FlutterIcons.x_fea,
                      color: Colors.red,
                      size: 20,
                    ).onInkTap(newTaxiOrderLocationEntryViewModel
                        .clearScheduleSelection),
                    UiSpacer.hSpace(10),
                  ],
                ),
              ),

              ///selected date
              HStack(
                [
                  Icon(
                    FlutterIcons.calendar_ant,
                    size: 18,
                  ),
                  UiSpacer.hSpace(5),
                  (vm.checkout.pickupDate != null
                          ? Jiffy("${vm.checkout.pickupDate} ${vm.checkout.pickupTime}")
                              .format("d MMM, y h:m a")
                          : "Now".tr())
                      .text
                      .sm
                      .semiBold
                      .make(),
                ],
                crossAlignment: CrossAxisAlignment.center,
                alignment: MainAxisAlignment.center,
              )
                  .box
                  .roundedSM
                  .padding(EdgeInsets.symmetric(vertical: 5, horizontal: 10))
                  .border(
                    color: AppColor.primaryColor,
                    width: 0.88,
                  )
                  .color(context.theme.colorScheme.background)
                  .shadowXs
                  .make(),
            ],
          ).onTap(newTaxiOrderLocationEntryViewModel.showSchedulePeriodPicker),
          UiSpacer.vSpace(10),
        ],
      ),
    );
  }
}
