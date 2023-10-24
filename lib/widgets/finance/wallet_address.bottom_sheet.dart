import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletAddressBottomSheet extends StatelessWidget {
  const WalletAddressBottomSheet(this.apiResponse, {Key key}) : super(key: key);

  final ApiResponse apiResponse;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        UiSpacer.swipeIndicator(),
        UiSpacer.verticalSpace(),
        UiSpacer.verticalSpace(),
        "My Wallet Address".tr().text.xl2.semiBold.makeCentered(),
        UiSpacer.verticalSpace(),
        //
        QrImage(
          data: jsonEncode(apiResponse.body),
          version: QrVersions.auto,
          size: context.percentWidth * 70,
        ).box.white.makeCentered(),

        UiSpacer.verticalSpace(),
        CustomTextButton(
          title: "Close".tr(),
          onPressed: () {
            context.pop();
          },
        ).centered(),
        UiSpacer.verticalSpace(),
      ],
    )
        .p20()
        .hTwoThird(context)
        .box
        .color(context.theme.colorScheme.background)
        .roundedLg
        .make();
  }
}
