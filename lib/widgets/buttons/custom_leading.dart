import 'package:flutter/cupertino.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomLeading extends StatelessWidget {
  const CustomLeading({
    this.size,
    this.color,
    this.padding,
    this.bgColor,
    Key key,
    this.iconColor
  }) : super(key: key);

  final double size;
  final Color color;
  final Color bgColor;
  final double padding;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      child: Icon(
        Utils.isArabic
            ? CupertinoIcons.chevron_right
            : CupertinoIcons.chevron_left,
        size: size ?? 20,
        color: iconColor ?? Utils.textColorByTheme(),
      )
          .p(padding ?? 4)
          .onInkTap(() {
            context.pop();
          })
          .box
          .shadowSm
          .roundedFull
          .clip(Clip.antiAlias)
          .color(bgColor ?? AppColor.primaryColor)
          .make(),
    );
  }
}
