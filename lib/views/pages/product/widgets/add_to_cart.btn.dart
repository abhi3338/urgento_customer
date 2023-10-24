import 'package:flutter/material.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton(this.model, {Key key}) : super(key: key);

  final ProductDetailsViewModel model;

  //
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      loading: model.isBusy,
      child: "Add to cart"
          .tr()
          .text
          .color(Utils.textColorByTheme())
          .semiBold
          .make()
          .p12(),
      onPressed: model.addToCart,
    );
  }
}
