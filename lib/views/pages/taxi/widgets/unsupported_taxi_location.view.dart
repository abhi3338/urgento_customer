import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class UnSupportedTaxiLocationView extends StatelessWidget {
  const UnSupportedTaxiLocationView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: vm.currentStep(0),
      child: Positioned(
        bottom: Vx.dp20,
        left: Vx.dp20,
        right: Vx.dp20,
        child: MeasureSize(
          onChange: (size) {
            vm.updateGoogleMapPadding(height: size.height + Vx.dp20 + Vx.dp20);
          },
          child: vm.isBusy
              ? BusyIndicator().centered()
              : VStack(
                  [
                    //
                    "Not available".tr().text.semiBold.xl.make(),
                    "Taxi booking is currently not available in the selected location. Please another location"
                        .tr()
                        .text
                        .sm
                        .light
                        .make()
                        .py4(),
                    UiSpacer.vSpace(10),
                    SafeArea(
                      top: false,
                      child: CustomButton(
                        child: "Try another location".tr().text.makeCentered(),
                        onPressed: () => vm.closeOrderSummary(clear: true),
                      ).wFull(context),
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
      ),
    );
  }
}
