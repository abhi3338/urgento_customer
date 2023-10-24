import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/views/pages/product/amazon_styled_commerce_product_details.page.dart';
// import 'package:fuodz/views/pages/product/commerce_product_details.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/tags/fav.positioned.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductListItem extends StatelessWidget {
  const CommerceProductListItem(this.product, {this.height, Key key})
      : super(key: key);

  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //image and fav icon
        Stack(
          children: [
            //prouct first image
            CustomImage(
              imageUrl: "${product.photo}",
              width: double.infinity,
              height: height,
              boxFit: BoxFit.contain,
            ).box.topRounded(value: 5).clip(Clip.antiAlias).make(),

            //fav icon
            FavPositiedView(product),
          ],
        ).p2(),

        //details
        VStack(
          [
            //name
            "${product.name}"
                .text
                .medium
                .size(14)
                .maxLines(2)
                .minFontSize(12)
                .maxFontSize(14)
                .overflow(TextOverflow.ellipsis)
                .make(),

            // "${product.vendor.name}".text.make(),

            // price
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                //price
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.base.semiBold.make(),
                    product.sellPrice
                        .currencyValueFormat()
                        .text
                        .base
                        .bold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                //discount
                CustomVisibilty(
                  visible: product.showDiscount,
                  child: CurrencyHStack(
                    [
                      AppStrings.currencySymbol.text.lineThrough.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .xs
                          .medium
                          .make(),
                    ],
                  ).px4(),
                ),
              ],
            ),
          ],
        ).p8(),
      ],
    )
        .onInkTap(
          () => openProductDetailsPage(context, product),
        )
        .material(color: context.theme.colorScheme.background)
        .box
        .clip(Clip.antiAlias)
        .border(
          color: context.theme.colorScheme.background,
          width: 2,
        )
        .color(context.theme.colorScheme.background)
        .withRounded(value: 8)
        .outerShadowSm
        .make();
  }

  openProductDetailsPage(BuildContext context, product) {
    context.push(
      (context) => AmazonStyledCommerceProductDetailsPage(product: product),
    );
  }
}
