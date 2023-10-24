import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductOptionsHeader extends StatelessWidget {
  const ProductOptionsHeader(
      {this.iconData, this.title, this.description, Key key})
      : super(key: key);

  final IconData iconData;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        Icon(
          iconData ?? FlutterIcons.plus_circle_fea,
          size: 20,
        ).pOnly(right: Vx.dp20),
        //
        VStack(
          [
            title != null && title.isNotBlank
                ? title.text.xl.semiBold.make()
                : "Select Add Ons".tr().text.lg.semiBold.make(),
            description.isNotBlank
                ? description.text.sm.make()
                : UiSpacer.emptySpace(),
          ],
        ).expand(),
      ],
    ).px20().pOnly(top: Vx.dp20, bottom: Vx.dp12);
  }
}
