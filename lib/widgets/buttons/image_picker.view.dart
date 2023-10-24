import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ImagePickerView extends StatelessWidget {
  const ImagePickerView(this.image, this.onPickPressed, this.onRemovePressed,
      {Key key})
      : super(key: key);

  final File image;
  final Function onPickPressed;
  final Function onRemovePressed;
  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: image == null
          ? "Select Image".tr().text.makeCentered()
          : VStack(
              [
                //
                Image.file(
                  image,
                ).wFull(context).h(Vx.dp64 * 3),

                //
                CustomButton(
                  title: "Remove".tr(),
                  color: Colors.red,
                  onPressed: onRemovePressed,
                ),
              ],
            ),
    )
        .p12
        .color(context.theme.colorScheme.background)
        .shadowMd
        .border(color: context.theme.highlightColor)
        .roundedSM
        .make()
        .wFull(context)
        .onInkTap(onPickPressed);
  }
}
