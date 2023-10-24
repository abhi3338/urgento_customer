import 'package:flutter/material.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodHorizontalProductListItem extends StatelessWidget {
  //
  const FoodHorizontalProductListItem(
      this.product, {
        this.onPressed,
        @required this.qtyUpdated,
        this.height,
        Key key,
      }) : super(key: key);

  //
  final Product product;
  final Function(Product) onPressed;
  final Function(Product, int) qtyUpdated;
  final double height;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    //
    Widget widget = HStack(
      [
        //
        Hero(
          tag: product.heroTag,
          child: CustomImage(
            imageUrl: product.photo,
            width: height != null ? height / 1.6 : height,
            height: height,
          )
          // .wh(Vx.dp40, Vx.dp40)
              .box
              .clip(Clip.antiAlias)
              .roundedSM
              .make(),
        ),
        UiSpacer.verticalSpace(space: 15),
        //Details
        VStack(
          [
            //name
            product.name.text.lg.medium
                .maxLines(2)
                .overflow(TextOverflow.ellipsis)
                .make(),
            //description
            "${product.vendor.name}"
                .text
                .xs
                .light
                .gray600
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),
            //price
            Wrap(
              children: [
                //price
                CurrencyHStack(
                  [
                    currencySymbol.text.sm.make(),
                    (product.showDiscount
                        ? product.discountPrice.currencyValueFormat()
                        : product.price.currencyValueFormat())
                        .text
                        .lg
                        .semiBold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                UiSpacer.horizontalSpace(),
                //discount price
                CustomVisibilty(
                  visible: product.showDiscount,
                  child: CurrencyHStack(
                    [
                      currencySymbol.text.lineThrough.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .lg
                          .medium
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ).px12().expand(),
      ],
    ).onInkTap(() => onPressed(product));

    //height set
    if (height != null) {
      widget = widget.h(height);
    }

    //
    return widget.box.p4.roundedSM
        .color(context.cardColor)
        .outerShadow
        .makeCentered()
        .p8();
  }
}
