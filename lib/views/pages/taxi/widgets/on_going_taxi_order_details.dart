import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class OnGoingTaxiOrderDetails extends StatelessWidget {
  const OnGoingTaxiOrderDetails(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: MeasureSize(
        onChange: (size) {
          vm.updateGoogleMapPadding(height: size.height);
        },
        child: VStack(
          [
            //

            //cancel order button
            //only show if driver is yet to be assigned
            Visibility(
              visible: vm.onGoingOrderTrip.canCancelTaxi,
              child: CustomTextButton(
                title: "Cancel Booking".tr(),
                titleColor: AppColor.getStausColor("failed"),
              ).centered(),
            ),
          ],
        )
            .p20()
            .scrollVertical()
            .box
            .color(context.theme.colorScheme.background,)
            .topRounded(value: 30)
            .shadow5xl
            .make(),
      ),
    );
  }
}
