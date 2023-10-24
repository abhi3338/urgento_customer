import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/views/shared/full_image_preview.page.dart';
import 'package:fuodz/widgets/Other_Busy_Loading.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';

class CustomImage extends StatefulWidget {
  CustomImage(
      {this.imageUrl,
      this.height = Vx.dp40,
      this.width,
      this.boxFit,
      this.canZoom = false,
      Key key})
      : super(key: key);

  final String imageUrl;
  final double height;
  final double width;
  final BoxFit boxFit;
  final bool canZoom;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this.widget.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: this.widget.imageUrl,
        errorWidget: (context, imageUrl, _) => Image.asset(
          AppImages.appLogo,
          fit: this.widget.boxFit ?? BoxFit.cover,
        ),
        fit: this.widget.boxFit ?? BoxFit.cover,
        progressIndicatorBuilder: (context, imageURL, progress) =>
            LoadingShimmer(),
      )
          .h(this.widget.height)
          .w(this.widget.width ?? context.percentWidth)
          .onInkTap(this.widget.canZoom
              ? () {
                  //if zooming is allowed
                  if (this.widget.canZoom) {
                    context.push(
                      (context) => FullImagePreviewPage(
                        this.widget.imageUrl,
                        boxFit: this.widget.boxFit ?? BoxFit.cover,
                      ),
                    );
                  }
                }
              : null);
    } else {
      return UiSpacer.emptySpace();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
