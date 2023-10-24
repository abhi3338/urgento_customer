import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTimelineConnector extends StatelessWidget {
  const CustomTimelineConnector({
    this.height,
    Key key,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Container(
          color: AppColor.primaryColorDark,
          width: 12,
          height: 12,
          child: Container(
            width: 5,
            height: 5,
            color: Colors.white,
          ).box.roundedFull.clip(Clip.antiAlias).make().centered(),
        ).box.roundedFull.clip(Clip.antiAlias).make(),

        //
        Container(
          width: 4,
          height: height ?? 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primaryColorDark,
                AppColor.accentColor,
              ],
            ),
          ),
        ),
        Container(
          color: AppColor.accentColor,
          width: 12,
          height: 12,
          child: Container(
            width: 5,
            height: 5,
            color: Colors.white,
          ).box.roundedFull.clip(Clip.antiAlias).make().centered(),
        ).box.roundedFull.make(),
      ],
      crossAlignment: CrossAxisAlignment.center,
    );
  }
}
