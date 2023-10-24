import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    this.title,
    this.child,
    this.divider = true,
    this.topDivider = false,
    this.suffix,
    this.onPressed,
    this.ic,
    Key key,
  }) : super(key: key);

  //
  final String title;
  final Widget child;
  final bool divider;
  final bool topDivider;
  final Widget suffix;
  final Function onPressed;
  final String ic;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0.6,
      color: context.theme.colorScheme.background,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: HStack(
        [
          //
          CustomVisibilty(
            visible: ic != null,
            child: HStack(
              [
                //
                Image.asset(
                  ic ?? AppImages.appLogo,
                  width: 24,
                  height: 24,
                ),
                //
                UiSpacer.horizontalSpace(),
              ],
            ),
          ),
          //
          (child ?? title.text.lg.light.make()).expand(),
          //
          suffix ??
              Icon(
                FlutterIcons.right_ant,
                size: 16,
              ),
        ],
      ),
    ).pOnly(bottom: Vx.dp3);
  }
}
