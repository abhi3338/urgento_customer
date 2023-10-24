import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDriverInfoView extends StatelessWidget {
  OrderDriverInfoView(this.order, {Key key}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    double avatarSize = context.percentWidth * 14;

    //
    return Visibility(
      visible: order.driver != null,
      child: VxBox(
        child: VStack(
          [
            //driver info
            HStack(
              [
                //driver profile
                Stack(
                  children: [
                    CustomImage(
                      imageUrl: order?.driver?.photo,
                      width: avatarSize,
                      height: avatarSize,
                    ),
                    //rating
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: HStack(
                        [
                          Icon(
                            FlutterIcons.star_ant,
                            size: 14,
                            color: Utils.textColorByTheme(),
                          ),
                          UiSpacer.hSpace(2),
                          //
                          "${order?.driver?.rating}"
                              .text
                              .sm
                              .color(Utils.textColorByTheme())
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                        alignment: MainAxisAlignment.center,
                      )
                          .pSymmetric(v: 2, h: 6)
                          .box
                          .roundedLg
                          .color(AppColor.ratingColor)
                          .makeCentered(),
                    ),
                  ],
                ),
                UiSpacer.hSpace(12),

                VStack(
                  [
                    "${order?.driver?.name}".text.medium.xl.make(),
                    VxRating(
                      isSelectable: false,
                      onRatingUpdate: null,
                      maxRating: 5.0,
                      count: 5,
                      value: order?.driver?.rating,
                      selectionColor: AppColor.ratingColor,
                    ),
                  ],
                ).expand(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
            //vehicle info
            Visibility(
              visible: order.driver?.vehicle != null,
              child: VStack(
                [
                  UiSpacer.divider().py8(),
                  HStack(
                    [
                      "${order.driver?.vehicle?.carMake} - ${order.driver?.vehicle?.carModel}"
                          .text
                          .medium
                          .make(),
                      UiSpacer.expandedSpace(),
                      "${order.driver?.vehicle?.reg_no}"
                          .text
                          .lg
                          .semiBold
                          .make(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).px20().py12(),
      ).shadowXs.color(context.theme.colorScheme.background).make(),
    );
  }
}
