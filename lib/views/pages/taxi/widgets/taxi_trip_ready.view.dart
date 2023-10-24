import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/views/pages/order/widgets/taxi_order_trip_verification.view.dart';
import 'package:fuodz/views/pages/taxi/widgets/driver_info.view.dart';
import 'package:fuodz/views/pages/taxi/widgets/safety.view.dart';
import 'package:fuodz/widgets/buttons/call.button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiTripReadyView extends StatelessWidget {
  const TaxiTripReadyView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropColor: Colors.transparent,
      minHeight: 300,
      maxHeight: context.percentHeight * 70,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      panelBuilder: (sc) {
        return MeasureSize(
          onChange: (size) {
            vm.updateGoogleMapPadding(height: 320);
          },
          child: VStack(
            [
              //driver info
              TaxiDriverInfoView(vm.onGoingOrderTrip.driver),
              //contact info
              HStack(
                [
                  //message box
                  CustomTextFormField(
                    hintText: "Message".tr() +
                        " ${(vm.onGoingOrderTrip.driver.name)}",
                    isReadOnly: true,
                    onTap: vm.openTripChat,
                  ).expand(),
                  UiSpacer.horizontalSpace(),
                  //call button
                  CallButton(
                    null,
                    phone: vm.onGoingOrderTrip.driver.phone,
                  ),
                ],
              ).py16(),

              UiSpacer.divider().py12(),
              //trip location details
              "Pickup Location".tr().text.sm.light.make(),
              "${vm.onGoingOrderTrip.taxiOrder.pickupAddress}"
                  .text
                  .lg
                  .medium
                  .make(),
              UiSpacer.verticalSpace(),
              "Dropoff Location".tr().text.sm.light.make(),
              "${vm.onGoingOrderTrip.taxiOrder.dropoffAddress}"
                  .text
                  .lg
                  .medium
                  .make(),
              UiSpacer.divider().py12(),
              //trip codes
              TaxiOrderTripVerificationView(vm.onGoingOrderTrip),
              UiSpacer.divider().py12(),
              //emergency
              SafetyView(),
              // UiSpacer.verticalSpace(),
              UiSpacer.divider().py12(),
              //cancel order button
              //only show if driver is yet to be assigned
              Visibility(
                visible: vm.onGoingOrderTrip.canCancelTaxi,
                child: CustomTextButton(
                  title: "Cancel Booking".tr(),
                  titleColor: AppColor.getStausColor("failed"),
                  loading: vm.busy(vm.onGoingOrderTrip),
                  onPressed: vm.cancelTrip,
                ).centered(),
              ),
            ],
          )
              .p20()
              .scrollVertical(controller: sc)
              .box
              .color(context.theme.colorScheme.background,)
              .topRounded(value: 30)
              .shadow5xl
              .make(),
        );
      },
      // panel:,
      // ),
    );
  }
}
