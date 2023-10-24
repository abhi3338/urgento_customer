import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:velocity_x/velocity_x.dart';

class FullImagePreviewPage extends StatelessWidget {
  const FullImagePreviewPage(this.imageUrl, {this.boxFit, Key key})
      : super(key: key);

  final String imageUrl;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: SafeArea(
        child: Column(
          children: [
      //header
            HStack(
              [
                //
                Icon(
                  FlutterIcons.close_ant,
                  color: Colors.white,
                ).box.p4.roundedFull.red500.make().onInkTap(() {
                  context.pop();
                }),
                UiSpacer.expandedSpace(),
              ],
            ).p20(),
            //
            PinchZoom(
              maxScale: 5,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                errorWidget: (context, imageUrl, _) => Image.asset(
                  AppImages.appLogo,
                  fit: boxFit ?? BoxFit.cover,
                ),
                fit: boxFit ?? BoxFit.cover,
                progressIndicatorBuilder: (context, imageURL, progress) =>
                    BusyIndicator().centered(),
              ),
            ).expand(),
          ],
        ),
      ),
    );
  }
}
