import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchTypeTag extends StatelessWidget {
  const SearchTypeTag({
    @required this.title,
    this.selected = false,
    this.borderColor,
    this.color,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final bool selected;
  final String title;
  final Color borderColor;
  final Color color;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return "$title"
        .text
        .color(selected ? Colors.white : context.textTheme.bodyLarge.color)
        .make()
        .py4()
        .px12()
        .onInkTap(onPressed)
        .material(
            color: selected
                ? AppColor.primaryColor
                : context.theme.colorScheme.background)
        .box
        .roundedLg
        .outerShadowSm
        .clip(Clip.antiAlias)
        .makeCentered()
        .pOnly(
          right: AppService.isDirectionRTL(context) ? Vx.dp0 : Vx.dp12,
          left: AppService.isDirectionRTL(context) ? Vx.dp12 : Vx.dp0,
        );
  }
}
