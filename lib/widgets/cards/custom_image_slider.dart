import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomImageSlider extends StatefulWidget {
  CustomImageSlider(
    this.images, {
    this.viewportFraction = 0.8,
    this.showIndicators = false,
    this.height,
    this.autoplay = false,
    this.canZoom = true,
    this.boxFit,
    Key key,
  }) : super(key: key);

  final List<dynamic> images;
  final double viewportFraction;
  final bool showIndicators;
  final double height;
  final bool autoplay;
  final BoxFit boxFit;
  final bool canZoom;

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  int currentIndex = 0;

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      child: VStack(
        [
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: widget.viewportFraction,
              autoPlay: widget.autoplay ?? false,
              initialPage: 1,
              height: (widget.height ?? AppStrings.bannerHeight ?? 150.0),
              disableCenter: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: widget.images.map(
              (image) {
                if (image is Widget) {
                  return image;
                } else {
                  return CustomImage(
                    imageUrl: image,
                    width: double.infinity,
                    boxFit: widget.boxFit ?? BoxFit.scaleDown,
                    height: (widget.height ?? AppStrings.bannerHeight ?? 150.0),
                    canZoom: widget.canZoom,
                  );
                }
              },
            ).toList(),
          ),
          //indicators
          CustomVisibilty(
            visible: widget.images.length <= 10 || widget.showIndicators,
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: widget.images.length ?? 0,
              textDirection:
                  Utils.isArabic ? TextDirection.rtl : TextDirection.ltr,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 10,
                activeDotColor: context.primaryColor,
              ),
            ).centered().py8(),
          ),
        ],
      ),
    );
  }
}
