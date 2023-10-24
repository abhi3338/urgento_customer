import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CartListItem extends StatelessWidget {
  const CartListItem(
    this.cart, {
    this.onQuantityChange,
    this.deleteCartItem,
    Key key,
  }) : super(key: key);

  final Cart cart;
  final Function(int) onQuantityChange;
  final Function deleteCartItem;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return Stack(
      children: [
        HStack(
          [
            //
            //PRODUCT IMAGE
            CustomImage(
              imageUrl: cart.product.photo,
              width: context.percentWidth * 18,
              height: context.percentWidth * 18,
            ).box.clip(Clip.antiAlias).roundedSM.make(),

            //
            UiSpacer.hSpace(10),
            VStack(
              [
                //product name
                "${cart.product.name}"
                    .text
                    .medium
                    .lg
                    .maxLines(2)
                    .ellipsis
                    .make(),
                UiSpacer.vSpace(10),
                //product options
                cart.optionsSentence.isNotEmpty
                    ? cart.optionsSentence.text.base.gray600.make()
                    : UiSpacer.emptySpace(),
                cart.optionsSentence.isNotEmpty
                    ? UiSpacer.verticalSpace(space: 10)
                    : UiSpacer.verticalSpace(space: 5),

                //
                //price and qty
                UiSpacer.horizontalSpace(),
                HStack(
                  [
                    //cart item price
                    ("$currencySymbol" + "${(cart.selectedQty * cart.price)}")
                        .currencyFormat()
                        .text
                        .semiBold
                        .xl2
                        .make(),
                    UiSpacer.hSpace(10).expand(),
                    //qty stepper
                    SizedBox(
                      height: 30,
                      child: FittedBox(
                        child: VxStepper(
                          defaultValue: cart.selectedQty ?? 1,
                          min: 1,
                          max: cart.product.availableQty ?? 20,
                          disableInput: true,
                          onChange: onQuantityChange,
                        )
                            .box
                            .color(context.theme.colorScheme.background)
                            .roundedSM
                            .clip(Clip.antiAlias)
                            .outerShadow
                            .make(),
                      ),
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ],
            ).expand(),
          ],
        )
            .p12()
            .box
            .rounded
            .outerShadow
            .color(context.theme.colorScheme.background,)
            .make(),

        //
        //delete icon
        Icon(
          FlutterIcons.x_fea,
          size: 16,
          color: Colors.white,
        )
            .centered()
            .p8()
            .onInkTap(
              this.deleteCartItem,
            )
            .box
            .roundedFull
            .color(Colors.red)
            .make()
            .positioned(
              top: 0,
              left: 0,
            ),
      ],
    );
  }
}
