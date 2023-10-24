import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/ui_spacer.dart';

class OpenTag extends StatelessWidget {
  const OpenTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack(


      [

        Icon(
          FlutterIcons.lock_open_ent,
          color: Colors.yellow,
          size: 9,
        ),
        UiSpacer.horizontalSpace(space: 3),
        Text(
    "Open",
    textAlign: TextAlign.left,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
    height: 1.0,
    fontWeight: FontWeight.w300,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: Utils.textColorByBrightness(context),
    fontSize: 9.0,
    letterSpacing: 0.025),
    ),

      ],
    );
        // .text.sm
        // .color(Utils.isDark(AppColor.openColor) ? Colors.white:Colors.black)
        // .make()
        // .py2()
        // .px8()
        // .box
        // .roundedLg
        // .color(AppColor.openColor)
        // .make();
  }
}
