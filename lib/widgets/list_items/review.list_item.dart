import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/review.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class ReviewListItem extends StatelessWidget {
  const ReviewListItem(this.review, {Key key}) : super(key: key);
  final Review review;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //user profile
        CustomImage(
          imageUrl: review.user.photo,
          width: 50,
          height: 50,
        ),
        UiSpacer.horizontalSpace(space: 10),
        //
        VStack(
          [
            //
            review.user.name.text.medium.lg.make(),
            "${review.review}".text.sm.hairLine.gray500.make(),
          ],
        ).expand(),
        //
        HStack(
          [
            //
            Icon(
              FlutterIcons.star_ant,
              size: 12,
              color: Colors.white,
            ),
            UiSpacer.horizontalSpace(space: 5),
            "${review.rating}".text.white.make(),
          ],
        )
            .px4()
            .py2()
            .box
            .roundedSM
            .shadowXs
            .color(AppColor.ratingColor)
            .make()
            .px8(),
      ],
    )
        .box
        .rounded
        .border(
          color: context.cardColor,
          width: 2,
        )
        .clip(Clip.antiAliasWithSaveLayer)
        .color(context.theme.colorScheme.background)
        .make();
  }
}
