import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/view_models/home.vm.dart';
import 'package:fuodz/views/pages/cart/cart.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';

class GoToCartView extends StatelessWidget {
  const GoToCartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cart>>(
      initialData: List.empty(),
      stream: CartServices.cartItemStream.stream,
      builder: (context, snapshot) {
        int temporaryCounter = 0;
        List<Cart> cartDataList;
        if (snapshot.data != null) {
          cartDataList = snapshot.data;
        } else {
          cartDataList = CartServices.productsInCart;
        }
        if (cartDataList.isNotEmpty) {
          for (var itemData in cartDataList) {
            temporaryCounter += itemData.selectedQty;
          }
        }
        print("go_to_cart.view.dart: $temporaryCounter");
        return Visibility(
          visible: temporaryCounter > 0,
          child: HStack([

            "You have %s items in your cart".tr().fill([temporaryCounter]).text.color(Utils.textColorByBrightness(context)).make().expand(),

            CustomButton(
              title: "View Cart".tr(),
              height: 30,
              color: AppColor.accentColor,
              elevation: 1,
              onPressed: () => context.push((context) => CartPage()),
            ),

          ])
          .p20()
          .safeArea(top: false)
          .box
          .color(context.theme.colorScheme.background,)
          .topRounded()
          .make(),
        );
      }
    );
  }
}
