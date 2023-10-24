import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/home.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CartHomeFab extends StatelessWidget {
  const CartHomeFab(this.model, {Key key}) : super(key: key);

  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return !AppUISettings.showCart
        ? UiSpacer.emptySpace()
        : StreamBuilder<List<Cart>>(
      initialData: List.empty(),
      stream: CartServices.cartItemStream.stream,
      //stream: HomeViewModel(context).cartItemListStream.stream,
      builder: (context, snapshot) {
        int totalCartItem = 0;
        if (snapshot.data != null && snapshot.data.isNotEmpty) {
          for (var item in snapshot.data) {
            print(item.toJson());
            totalCartItem += item.selectedQty;
          }
        }
        print("cart.fab.dart: ${totalCartItem}");
        return SizedBox(
          height: 40,
          child: FloatingActionButton.extended(
            backgroundColor: AppColor.primaryColorDark,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: model.openCart,
            icon: Icon(
              FlutterIcons.shopping_cart_faw,
              color: Colors.white,
            )
                .badge(
              position: Utils.isArabic
                  ? VxBadgePosition.leftTop
                  : VxBadgePosition.rightTop,
              //count: model.totalCartItems,
              count: totalCartItem,
              color: Colors.white,
              textStyle: context.textTheme.bodyLarge?.copyWith(
                color: AppColor.primaryColor,
                fontSize: 10,
              ),
            ),
            label: "Cart".tr().text.white.make(),
          ),
        );
      },
    );
  }
}
