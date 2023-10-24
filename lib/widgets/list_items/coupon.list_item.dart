import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponListItem extends StatelessWidget {
  const CouponListItem(
    this.coupon, {
    this.onPressed,
    this.radius = 4,
    Key key,
  }) : super(key: key);

  final Coupon coupon;
  final double radius;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    if (coupon == null) {
      return shimmerView();
    }

    Color fromColor = Vx.hexToColor(coupon.color) ?? AppColor.primaryColor;
    if (fromColor == Colors.black) {
      fromColor = AppColor.primaryColor;
    }
    Color toColor = fromColor.withAlpha(150);
    return  Container(

      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,

            spreadRadius: -1,
            offset: Offset(
              0,
              0,
            ),
          )
        ],
      ),
      child: HStack(
        [
          //
          Visibility(
            visible: coupon.photo.isNotDefaultImage,
            child: HStack(
              [
                CustomImage(imageUrl: coupon.photo).wh(30, 30),
                UiSpacer.horizontalSpace(space: 10 ),
              ],
            ),
          ),

          //
          VStack(
            [

              Container(
                height: 18,
                width: 80,
                child: Text(
                  '${coupon.code}',
                  textAlign: TextAlign.left,
                  overflow:TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(height:1.0,fontWeight: FontWeight.w600,fontFamily: GoogleFonts.lato().fontFamily,color:Utils.textColorByColor(fromColor),fontSize: 12.0,letterSpacing: 0.025),
                ),
              ),

              Container(
                height: 25,
                width: 100,
                child: Text(
                  '${coupon.description ?? ''}',
                  textAlign: TextAlign.left,
                  overflow:TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(height:1.0,fontWeight: FontWeight.w400,fontFamily: GoogleFonts.lato().fontFamily,color:Utils.textColorByColor(fromColor),fontSize:11.0,letterSpacing: 0.025),
                ),
              ),


            ],
          ).expand(),
        ],
      )
          .px(10)
          .py(10)
          .box
          .roundedSM
          .gradientFromTo(from: fromColor, to: toColor)
          .make()
          .onTap(onPressed != null ? () => onPressed(coupon) : null)
    );
  }

  Widget shimmerView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        color: Colors.white.withOpacity(0.9),
      )
      .px(20)
      .py(12)
      .box
      .roundedSM
      .make(),
    );
  }
}
