import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/ui_spacer.dart';

class PickupTag extends StatelessWidget {
  const PickupTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,  // Set the width of the container
      height: 10.0,  // Set the height of the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),  // Adjust the radius for roundness
        color: AppColor.pickupColor,  // Set the background color
      ),
      child: Center(
          child: HStack(
            [
              Icon(
                FlutterIcons.store_mco,
                color: Colors.yellow,

                size: 7,
              ),
              UiSpacer.horizontalSpace(space: 3),
              Text(
                'Pickup',
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                    color: Utils.textColorByBrightness(context),
                    fontSize: 7.0,
                    letterSpacing: 0.025),
              ),

            ],
          ),
      ),
    );"Pickup"
                    .tr()
                    .text.xs
                    .color(Utils.isDark(AppColor.pickupColor) ? Colors.white:Colors.black)
                    .make()
                    .py2()
                    .px8()
                    .box
                    .roundedLg
                    .color(AppColor.pickupColor)
                    .make();
  }
}
