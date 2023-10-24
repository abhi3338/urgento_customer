import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ParcelLocationPickerOptionBottomSheet extends StatelessWidget {
  const ParcelLocationPickerOptionBottomSheet();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        UiSpacer.swipeIndicator().py12(),
        "Where to pick delivery address from?".tr().text.semiBold.make(),
        UiSpacer.verticalSpace(),
        //filter result
        CustomButton(
          title: "Delivery Address List".tr(),
          onPressed: () {
            context.pop(0);
          },
        ),
        UiSpacer.verticalSpace(),
        CustomTextButton(
          title: "Directly from map".tr(),
          onPressed: () {
            context.pop(1);
          },
        ).wFull(context),
      ],
    )
        .p20()
        .box
        .color(context.theme.colorScheme.background)
        .topRounded()
        .clip(Clip.antiAlias)
        .make();
  }
}
