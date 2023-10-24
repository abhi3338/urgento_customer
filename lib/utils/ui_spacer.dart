import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class UiSpacer {
  static Widget hSpace([double space = 20]) => SizedBox(width: space);
  static Widget vSpace([double space = 20]) => SizedBox(height: space);

  //space between widgets vertically
  static Widget verticalSpace({double space = 20}) => SizedBox(height: space);

  //space between widgets horizontally
  static Widget horizontalSpace({double space = 20}) => SizedBox(width: space);
  static Widget smHorizontalSpace({double space = 5}) => SizedBox(width: space);

  static Widget formVerticalSpace({double space = 15}) =>
      SizedBox(height: space);

  static Widget emptySpace() => SizedBox(width: 0, height: 0);
  static Widget expandedSpace() => Expanded(
        child: SizedBox.shrink(),
      );

  static Widget divider({double height = 1, double thickness = 1}) => Divider(
        height: height,
        thickness: thickness,
      );

  static Widget swipeIndicator() => Divider(
        height: 4,
        thickness: 4,
      ).w(40).box.rounded.clip(Clip.antiAlias).make().centered();

  //
  static Widget cutDivider({Color color}) => ClipPath(
        clipper: MultiplePointsClipper(Sides.bottom,
            heightOfPoint: 5, numberOfPoints: 40),
        child: SizedBox(
          height: 8,
          width: double.infinity,
        ).box.color(color ?? Vx.gray200).make(),
      );
}
