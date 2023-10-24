import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_taxi_settings.dart';
import 'package:fuodz/models/order.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiOrderTripVerificationView extends StatelessWidget {
  TaxiOrderTripVerificationView(this.order, {Key key}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    //
    return Visibility(
        visible: !order.isCompleted && AppTaxiSettings.requiredBookingCode,
        child: VxBox(
          child: VStack(
            [
              "Booking/Verification Code".tr().text.light.italic.lg.make(),
              "${order.verificationCode}".text.xl2.semiBold.make(),
            ],
            crossAlignment: CrossAxisAlignment.center,
          ).px20().py12(),
        )
            .shadowXs
            .color(context.theme.colorScheme.background)
            .make()
            .wFull(context));
  }
}
