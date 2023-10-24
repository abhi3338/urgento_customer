import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductDetailsHeader extends StatelessWidget {
  const CommerceProductDetailsHeader({
    this.product,
    this.showVendor = true,
    Key key,
    this.model,
  }) : super(key: key);

  final Product product;
  final bool showVendor;
  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    //

    return VStack(
      [
        UiSpacer.verticalSpace(),
        //product name
        product.name.text.lg.semiBold.make(),

        //product size details and more
        HStack(
          [
            //deliverable or not
            (product.canBeDelivered
                    ? "Deliverable".tr()
                    : "Not Deliverable".tr())
                .text
                .white
                .sm
                .make()
                .py4()
                .px8()
                .box
                .roundedLg
                .color(
                  product.canBeDelivered ? Vx.green500 : Vx.red500,
                )
                .make(),

            //
            UiSpacer.expandedSpace(),

            //size
            CustomVisibilty(
              visible: !product.capacity.isEmptyOrNull &&
                  !product.unit.isEmptyOrNull,
              child: "${product.capacity} ${product.unit}"
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make()
                  .pOnly(right: Vx.dp12),
            ),

            //package items
            CustomVisibilty(
              visible: product.packageCount != null,
              child: "%s Items"
                  .tr()
                  .fill(["${product.packageCount}"])
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make(),
            ),
            UiSpacer.smHorizontalSpace(),
            //fav
            CustomOutlineButton(
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
            ),
          ],
        ).pOnly(top: Vx.dp10),
      ],
    ).px20();
  }
}
