import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchCustomTabbar extends StatelessWidget {
  const SearchCustomTabbar({
    this.title,
    this.active = false,
    this.show = true,
    Key key,
  }) : super(key: key);

  final String title;
  final bool active;
  final bool show;
  @override
  Widget build(BuildContext context) {
    final bgColor =
        active ? AppColor.primaryColor : context.theme.colorScheme.background;
    return show
        ? '$title'
            .text
            .color(Utils.textColorByColor(bgColor))
            .make()
            .px(10)
            .py(10)
            .box
            .color(bgColor)
            .roundedSM
            .outerShadowSm
            .make()
        : UiSpacer.emptySpace();
  }
}
