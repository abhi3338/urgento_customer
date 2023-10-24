import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/utils.dart';

class TimeTag extends StatelessWidget {
  const TimeTag(this.value, {@required this.iconData, Key key})
      : super(key: key);

  final String value;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    //delivery time
    return Visibility(
      visible: value != null,
      child: HStack(
        [
          //icon
          Icon(
            iconData,
            color: Colors.yellow,
            size: 7,
          ),
          UiSpacer.smHorizontalSpace(space: 4),

          //
          Text(
            "${value}",
            textAlign: TextAlign.left,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                height: 1.0,
                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.rubik().fontFamily,
                color: Utils.textColorByBrightness(context),
                fontSize: 7.0,
                letterSpacing: 0.025),
          ),

        ],
      )



      ,
    );
  }
}
