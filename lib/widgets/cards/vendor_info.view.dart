import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorInfoView extends StatelessWidget {
  const VendorInfoView(this.vendor, {Key key}) : super(key: key);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        CustomImage(
          imageUrl: vendor.logo,
          width: 25,
          height: 25,
        ).box.roundedFull.clip(Clip.antiAlias).make(),
        UiSpacer.hSpace(10),
        VStack(
          [
            "${vendor.name}".text.sm.maxLines(1).ellipsis.make(),
            VxRating(
              maxRating: 5,
              value: vendor.rating.toDouble(),
              size: 10,
              isSelectable: false,
              onRatingUpdate: null,
              selectionColor: AppColor.ratingColor,
            ),
          ],
        ).expand(),
      ],
    );
  }
}
