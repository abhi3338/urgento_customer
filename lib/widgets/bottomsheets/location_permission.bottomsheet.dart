import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({Key key, this.onResult}) : super(key: key);

  //
  final Function(bool) onResult;

  //
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Location Permission Request".tr().text.semiBold.xl.make().py12(),
          "Thank you for using %s. To provide you with the best experience possible, our app needs access to your location. We use your location data to show you nearby vendors, enable you to set up a delivery address or location during checkout, and provide live tracking of your order and delivery persons. Your privacy is important to us, and we will never share your location data with third parties."
              .tr()
              .fill([AppStrings.appName])
              .text
              .make(),
          UiSpacer.verticalSpace(),
          CustomButton(
            title: "Next".tr(),
            onPressed: () {
              onResult(true);
              AppService().navigatorKey.currentContext.pop();
            },
          ).py12(),
          Visibility(
            visible: !Platform.isIOS,
            child: CustomButton(
              title: "Cancel".tr(),
              color: Colors.grey[400],
              onPressed: () {
                onResult(false);
                AppService().navigatorKey.currentContext.pop();
              },
            ),
          ),
        ],
      ).p20().wFull(context).scrollVertical(), //.hTwoThird(context),
    );
  }
}
