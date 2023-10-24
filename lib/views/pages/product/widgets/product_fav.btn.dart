import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';

class ProductFavButton extends StatelessWidget {
  const ProductFavButton({
    this.model,
    Key key,
  }) : super(key: key);

  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return CustomOutlineButton(
      loading: model.isBusy,
      color: Colors.transparent,
      child: Icon(
        (!model.isAuthenticated() || !model.product.isFavourite)
            ? FlutterIcons.heart_o_faw
            : FlutterIcons.heart_faw,
        color: Colors.red,
      ),
      onPressed: !model.isAuthenticated()
          ? model.openLogin
          : !model.product.isFavourite
              ? model.addToFavourite
              : model.removeFromFavourite,
    );
  }
}
