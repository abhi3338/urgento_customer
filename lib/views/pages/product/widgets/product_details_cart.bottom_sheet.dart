import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_steppr.view.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetailsCartBottomSheet extends StatelessWidget {
  const ProductDetailsCartBottomSheet({this.model, Key key}) : super(key: key);

  final ProductDetailsViewModel model;
  @override
  Widget build(BuildContext context) {
    return VStack(
        [
          //
          Visibility(
            visible: model.product.hasStock,
            child: model.product.optionGroups.isEmpty
                ? HStack([
              "Quantity".tr().text.xl.medium.make().expand(),

              StreamBuilder<List<Cart>>(
                  stream: CartServices.cartItemStream.stream,
                  builder: (context, snapshot) {
                    int productQty = 1;
                    print("product_details_cart.bottom_sheet.dart: ${snapshot.data}");
                    if (snapshot.data != null) {
                      int searchIndex = snapshot.data.indexWhere((element) => element.product.id == model.product.id);
                      if (searchIndex != -1) {
                        productQty = snapshot.data[searchIndex].selectedQty;
                      }
                    }
                    return NewOneCustomStepper(
                      defaultValue: productQty,
                      max: (model.product.availableQty != null && model.product.availableQty > 0) ? model.product.availableQty : 20,
                      onChange: (p0, increment, decrement) async {
                        await model.addToCartDirectly(model.product, p0, isIncrement: increment, isDecrement: decrement);
                        model.calculateTotal();
                      },
                    );
                    // return VxStepper(
                    //   //defaultValue: model.product.selectedQty ?? 1,
                    //   defaultValue: productQty,
                    //   min: 1,
                    //   max: (model.product.availableQty != null && model.product.availableQty > 0) ? model.product.availableQty : 20,
                    //   disableInput: true,
                    //   //onChange: model.updatedSelectedQty,
                    //   onChange: (int value) {
                    //     print(value);
                    //     //print(productQty > value);
                    //     model.addToCartDirectly(model.product, value, isIncrement: productQty > value, isDecrement: productQty < value);
                    //   },

                    // );
                  }
              ),
            ],
            )
                : const SizedBox.shrink(),
          ),

          Visibility(
            visible: model.product.hasStock,
            child: HStack([

              CustomButton(
                loading: model.isBusy,
                child: Icon(
                  FlutterIcons.heart_fea,
                  color: Colors.white,
                ),
                onPressed: !model.isAuthenticated()
                    ? model.openLogin
                    : !model.product.isFavourite
                    ? model.addToFavourite
                    : null,
              )
                  .w(Vx.dp64)
                  .pOnly(right: Vx.dp24),

              CustomButton(
                loading: model.isBusy,
                child: HStack([
                  model.product.optionGroups.isEmpty
                      ? "Add to cart".tr().text.black.medium.make().expand()
                      : "Tap to choose variant".tr().text.white.medium.make(),
                  if (model.product.optionGroups.isEmpty)
                    CurrencyHStack([
                      model.currencySymbol.text.white.lg.make(),
                      model.total
                          .currencyValueFormat()
                          .text
                          .white
                          .letterSpacing(1.5)
                          .xl
                          .semiBold
                          .make(),
                    ]),
                ])
                    .p12(),
                onPressed: model.addToCart,
              ).expand(),

            ]).py12(),
          ),

          Visibility(
              visible: !model.product.hasStock,
              child: "No stock".tr().text.white.makeCentered().p8().box.red500.roundedSM.make().p8().wFull(context)
          ),
        ])
        .p20()
        .box
        .color(context.theme.colorScheme.background)
        .shadowXl
        .make()
        .wFull(context);
  }
}