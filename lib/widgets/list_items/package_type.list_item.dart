import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/package_type.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class PackageTypeListItem extends StatelessWidget {
  const PackageTypeListItem(
      {this.packageType, this.selected = false, this.onPressed, Key key})
      : super(key: key);

  final PackageType packageType;
  final bool selected;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //image
        CustomImage(
          imageUrl: packageType.photo,
        ).wh(Vx.dp56, Vx.dp56).pOnly(
              right: AppService.isDirectionRTL(context) ? Vx.dp0 : Vx.dp12,
              left: AppService.isDirectionRTL(context) ? Vx.dp12 : Vx.dp0,
            ),

        VStack(
          [
            packageType.name.text.semiBold.make(),
            packageType.description.text.sm.make(),
          ],
        ).expand(),
      ],
      crossAlignment: CrossAxisAlignment.start,
      // alignment: MainAxisAlignment.start,
    )
        .p12()
        .onInkTap(onPressed)
        .box
        .roundedSM
        .border(
          color: selected ? Color(0xFF000000) : Color(0xFFFFFFFF),
          width: selected ? 2 : 1,
        )
        .make();
  }
}
