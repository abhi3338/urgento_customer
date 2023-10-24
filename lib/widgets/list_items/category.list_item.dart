import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    this.category,
    this.onPressed,
    this.maxLine = true,
    this.h,
    Key key,
  }) : super(key: key);

  final Function(Category) onPressed;
  final Category category;
  final bool maxLine;
  final double h;
  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return shimmerView(context);
    }
    return VStack(
      [
        //max line applied
        CustomVisibilty(
          visible: maxLine,
          child: VStack(
            [
              //


              CustomImage(
                imageUrl: category.imageUrl,
                boxFit: BoxFit.fill,
                width: AppStrings.categoryImageWidth,
                height: AppStrings.categoryImageHeight,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(Vx.hexToColor(category.color))
                  .make()
                  .py2(),

              category.name.text
                  .xs
                  .wrapWords(true)

              .maxLines(2)
                  .center
                  .make()
                  .p2(),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          )
              .w((AppStrings.categoryImageWidth * 1.8) +
                  AppStrings.categoryTextSize)
              .h(h ??
                  ((AppStrings.categoryImageHeight * 2.2) +
                      AppStrings.categoryImageHeight))
              .onInkTap(
                () => this.onPressed(this.category),
              )
              .px4(),
        ),

        //no max line applied
        CustomVisibilty(
          visible: !maxLine,
          child: VStack(
            [
              //
              CustomImage(
                imageUrl: category.imageUrl,
                boxFit: BoxFit.fill,
                width: AppStrings.categoryImageWidth,
                height: AppStrings.categoryImageHeight,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(Vx.hexToColor(category.color))
                  .make()
                  .py2(),

              //


              category.name.text
                  .xs
                  .wrapWords(false)
                  .center
                  .make()
                  .p2(),


            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          )
              .w((AppStrings.categoryImageWidth * 1.8) +
                  AppStrings.categoryTextSize)
              .onInkTap(
                () => this.onPressed(this.category),
              )
              .px4(),
        ),



        //
      ],
    );
  }

  Widget shimmerView(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        child: VStack([

          CustomVisibilty(
            visible: false,
            child: VStack([

              Container(
                width: AppStrings.categoryImageWidth,
                height: AppStrings.categoryImageHeight,
              )
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .make()
              .py2(),

            ], crossAlignment: CrossAxisAlignment.center, alignment: MainAxisAlignment.start)
            .w((AppStrings.categoryImageWidth * 1.8) + AppStrings.categoryTextSize)
            .h(h ?? (AppStrings.categoryImageHeight * 2.2) + AppStrings.categoryImageHeight)
            .px4(),
          ),

          CustomVisibilty(
            visible: true,
            child: VStack([

              Container(
                width: AppStrings.categoryImageWidth,
                height: AppStrings.categoryImageHeight,
              )
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .make()
              .py2(),

            ], crossAlignment: CrossAxisAlignment.center, alignment: MainAxisAlignment.start)
            .w((AppStrings.categoryImageWidth * 1.8) + AppStrings.categoryTextSize)
            .px4(),
          )
        ]),
      ),
    );
  }
}
