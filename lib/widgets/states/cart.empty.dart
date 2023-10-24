import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Image.asset(AppImages.emptyCart)
            .wh(
              context.percentWidth * 50,
              context.percentWidth * 50,
            )
            .box
            .makeCentered()
            .wFull(context),
        UiSpacer.vSpace(5),

        "Empty".tr().text.semiBold.xl.make(),
        "Sorry, you have no product in your cart".tr().text.make(),
      ],
      crossAlignment: CrossAxisAlignment.center,
      alignment: MainAxisAlignment.center,
    ).wFull(context);
  }
}
