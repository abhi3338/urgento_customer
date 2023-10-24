import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class TopServiceVendorListItem extends StatelessWidget {
  const TopServiceVendorListItem({
    this.vendor,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        CustomImage(
          imageUrl: vendor.logo,
          height: 50,
          width: 50,
        ).box.roundedFull.clip(Clip.antiAlias).make(),
        UiSpacer.vSpace(6),
        //name
        vendor.name.text.center.semiBold.maxLines(1).ellipsis.make(),
        //rating
        VxRating(
          maxRating: 5.0,
          value: double.parse(vendor.rating.toString()),
          isSelectable: false,
          onRatingUpdate: null,
          selectionColor: AppColor.ratingColor,
          size: 14,
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
      alignment: MainAxisAlignment.center,
    )
        .centered()
        .onInkTap(
          () => this.onPressed(this.vendor),
        )
        .box
        .make()
        .box
        .color(context.theme.colorScheme.background)
        .outerShadow
        .shadowOutline(outlineColor: AppColor.primaryColor)
        .roundedSM
        .make();
  }
}
