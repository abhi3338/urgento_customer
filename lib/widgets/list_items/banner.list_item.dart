import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BannerListItem extends StatelessWidget {
  const BannerListItem({
    this.imageUrl,
    this.onPressed,
    this.radius = 4,
    this.noMargin = false,
    Key key,
  }) : super(key: key);

  final String imageUrl;
  final double radius;
  final bool noMargin;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      width: double.infinity,
      fit: BoxFit.fill,



    )
        .onInkTap(this.onPressed)
        .box
        .withRounded(value: radius)
        .clip(Clip.antiAlias)
        .margin(
          EdgeInsets.all(7),
        )
        .make();
  }
}
