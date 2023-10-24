import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/views/pages/cart/cart.page.dart';
import 'package:velocity_x/velocity_x.dart';

class PageCartAction extends StatefulWidget {
  const PageCartAction({
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 12,
    this.iconSize = 24,
    this.badgeSize = 14,
    this.padding = 10,
    Key key,
  }) : super(key: key);
  final Color color;
  final Color textColor;
  final double badgeSize;
  final double iconSize;
  final double fontSize;
  final double padding;

  @override
  _PageCartActionState createState() => _PageCartActionState();
}

class _PageCartActionState extends State<PageCartAction> {
  @override
  void initState() {
    super.initState();
    CartServices.getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return !AppUISettings.showCart
        ? UiSpacer.emptySpace()
        : StreamBuilder(
            stream: CartServices.cartItemsCountStream.stream,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return OutlinedButton.icon( // <-- OutlinedButton
                onPressed: () {context.nextPage(CartPage());},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.theme.colorScheme.background, width: 1), //<-- SEE HERE
                ),
                icon: Icon(
                  FlutterIcons.shopping_cart_fea,
                  size: 24.0,
                  color: Utils.textColorByBrightness(context),
                ),
                label: Text('Cart',style: TextStyle(color: Utils.textColorByBrightness(context))),
              )/*TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(color: Colors.blue),
                  backgroundColor: Colors.white,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () => {

                  context.nextPage(CartPage())
                },
                icon: Icon(FlutterIcons.shopping_cart_fea,),
                label: Text('view cart',),
              ) */
                  .badge(
                count: snapshot.data,
                size: widget.badgeSize,
                color: widget.color ?? Colors.white,
                textStyle: context.textTheme.bodyText1.copyWith(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                ),
              )

                  .onInkTap(
                    () async {
                  //

                },
              );
            },
          );
  }
}
