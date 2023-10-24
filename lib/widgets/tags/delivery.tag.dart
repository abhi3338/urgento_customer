import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryTag extends StatelessWidget {
  const DeliveryTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack(


          [

            Icon(
              FlutterIcons.truck_delivery_mco,
              color: Colors.yellow,
              size: 7,
            ),
            UiSpacer.horizontalSpace(space: 3),
            Text(
              'Delivery',
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
        );



                    // .width(10)
                    // .roundedLg
                    // .color(AppColor.deliveryColor)
                    // .make();
  }
}
