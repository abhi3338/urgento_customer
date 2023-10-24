import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class SafetyView extends StatelessWidget {
  const SafetyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Icon(
          FlutterIcons.shield_alert_mco,
          color: Colors.white,
        ).p12().box.roundedFull.shadowSm.red500.makeCentered().onInkTap(
          () {
            launchUrlString("tel:${AppStrings.emergencyContact ?? 911}");
          },
        ),
        "Safety".tr().text.makeCentered().py4(),
      ],
    );
  }
}
