import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';

import '../../../../utils/ui_spacer.dart';

class TripDriverSearch extends StatelessWidget {
  const TripDriverSearch(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    Duration searchTimeDuration = Duration(seconds: vm.currentTimeInSecond);

    return Positioned(
      bottom: Vx.dp2,
      left: Vx.dp2,
      right: Vx.dp2,
      child: MeasureSize(
        onChange: (size) {
          vm.updateGoogleMapPadding(height: size.height);
        },
        child: VStack(
          [
            //cancel order button
            "Searching for a driver. Please wait...".tr().text.makeCentered(),

            _printDuration(searchTimeDuration)
                .text
                .center
                .makeCentered()
                .h(45),


          Align(
                    alignment: Alignment.center,
                    child: Image.asset( AppImages.tsearch,
                      height: 100.0,
                      width: 100.0,



                    )


                ),
            UiSpacer.vSpace(25),
            //loading indicator
            // BusyIndicator().centered().py12(),

            //only show if driver is yet to be assigned
            Visibility(
              visible: vm.onGoingOrderTrip?.canCancelTaxi ?? false,
              child: CustomButton(
                isFixedHeight: true,
                height: Vx.dp48,
                title: "Cancel Booking".tr(),
                onPressed: vm.cancelTrip,
                loading: vm.busy(vm.onGoingOrderTrip),
              ).centered(),

             /* CustomTextButton(
                title: "Cancel Booking".tr(),
                titleColor: AppColor.getStausColor("failed"),
                loading: vm.busy(vm.onGoingOrderTrip),
                onPressed: vm.cancelTrip,
              ).centered(), */
            ),
          ],
        )
            .p20()
            .box
            .color(context.theme.colorScheme.background,)
            .roundedSM
            .outerShadow2Xl
            .make(),
      ),
    );
  }
}
