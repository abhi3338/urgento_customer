import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/tcustom_steppr.view.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/inputs/drop_down.input.dart';
import 'package:fuodz/widgets/states/product_stock.dart';
import 'package:fuodz/widgets/tags/discount.positioned.dart';
import 'package:fuodz/widgets/tags/fav.positioned.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/currency_hstack.dart';

class GroceryProductListItem extends StatefulWidget {
  const GroceryProductListItem({
    this.product,
    this.onPressed,
    @required this.qtyUpdated,
    this.showStepper = false,
    this.height,
    Key key,
  }) : super(key: key);

  final Function(Product) onPressed;
  final Function(Product, int, {bool isIncrement, bool isDecrement}) qtyUpdated;
  final Product product;
  final bool showStepper;
  final double height;

  @override
  State<GroceryProductListItem> createState() => _GroceryProductListItemState();
}

final currencySymbol = AppStrings.currencySymbol;

class _GroceryProductListItemState extends State<GroceryProductListItem> {
  @override
  Widget build(BuildContext context) {
    return VStack([
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Image border
              child: CustomImage(
                imageUrl: widget.product.photo,
                width: double.infinity,
                height: 120,
              ),
            ),
            DiscountPositiedView(widget.product),
            FavPositiedView(widget.product),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: VStack([
          Container(
            height: 24,
            child: Text(
              '${widget.product.name}',
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  height: 1.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.rubik().fontFamily,
                  color: Color(0xFF181725),
                  fontSize: 12.0,
                  letterSpacing: 0.025),
            ),
          ),
          UiSpacer.verticalSpace(space: 2),
          Container(
            height: 8,
            child: Text(
              '${widget.product.description}',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  height: 1.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.rubik().fontFamily,
                  color: Color(0xFF000000),
                  fontSize: 8.0,
                  letterSpacing: 0.025),
            ),
          ),
          UiSpacer.verticalSpace(space: 1),
          Container(
            height: 8,
            child: Text(
              '${widget.product.vendor.name}',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  height: 1.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.rubik().fontFamily,
                  color: Color(0xFF000000),
                  fontSize: 8.0,
                  letterSpacing: 0.025),
            ),
          ),


          UiSpacer.verticalSpace(space: 2),
          HStack([
            Expanded(
              child: CurrencyHStack([
                Wrap(
                  children: [
                    CustomVisibilty(
                      visible: !widget.product.showDiscount,
                      child: CurrencyHStack([
                        Container(
                          height: 18,
                          child: Text(
                            '${currencySymbol}',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              height: 1.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: Color(0xFF181725),
                              fontSize: 10.0,
                              letterSpacing: 0.025,
                            ),
                          ),
                        ),
                        Container(
                          height: 18,
                          child: Text(
                            '${widget.product.showDiscount ? widget.product.discountPrice.currencyValueFormat() : widget.product.price.currencyValueFormat()}',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              height: 1.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: Color(0xFF181725),
                              fontSize: 10.0,
                              letterSpacing: 0.025,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    CustomVisibilty(
                      visible: widget.product.showDiscount,
                      child: CurrencyHStack([
                        VStack([
                          HStack([
                            Container(
                              height: 18,
                              child: Text(
                                '${currencySymbol}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Color(0xFF181725),
                                  fontSize: 10.0,
                                  letterSpacing: 0.025,
                                ),
                              ),
                            ),
                            Container(
                              height: 18,
                              child: Text(
                                '${widget.product.discountPrice.currencyValueFormat()}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Color(0xFF181725),
                                  fontSize: 10.0,
                                  letterSpacing: 0.025,
                                ),
                              ),
                            ),
                          ]),
                          HStack([
                            Container(
                              height: 18,
                              child: Text(
                                '${currencySymbol}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Color(0xFF181725),
                                  fontSize: 10.0,
                                  letterSpacing: 0.025,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Container(
                              height: 18,
                              child: Text(
                                '${widget.product.price.currencyValueFormat()}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Color(0xFF181725),
                                  fontSize: 10.0,
                                  letterSpacing: 0.025,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      ]),
                    ),
                  ],
                ),
              ]),
            ),

            Stack(
              children: [

                HStack([

                  Visibility(
                    visible: widget.product.optionGroups.isNotEmpty,
                    child: Container(
                      width: 90,
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          final ProductDetailsViewModel
                          productDetailsViewModel =
                          new ProductDetailsViewModel(
                              context, widget.product);
                          productDetailsViewModel.addToCart();
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(width: 3.0),
                          minimumSize: Size(60, 0),
                        ),
                        child: Text('ADD'),
                      ).centered(),
                    ),
                  ),
                  CustomVisibilty(
                    visible: !widget.product.optionGroups.isNotEmpty,
                    child: Container(
                      height: 50,
                      child: Stack(
                        children: [
                          CustomVisibilty(
                            visible: widget.product.hasStock,
                            child: StreamBuilder<List<Cart>>(
                              stream: CartServices.cartItemStream.stream,
                              builder: (context, snapshot) {
                                int productQty = 0;
                                List<Cart> tempCartData;
                                if (snapshot.data != null) {
                                  tempCartData = snapshot.data;
                                } else {
                                  tempCartData = CartServices.productsInCart;
                                }
                                int searchIndex = tempCartData.indexWhere(
                                        (element) =>
                                    element.product.id ==
                                        widget.product.id);
                                if (searchIndex != -1) {
                                  productQty =
                                      tempCartData[searchIndex].selectedQty;
                                }
                                print("productgrid.dart: $productQty");
                                return Stack(
                                  children: [
                                    CustomVisibilty(
                                      visible: productQty != null &&
                                          productQty > 0,
                                      child: Container(
                                        height: 30,
                                        width: 85,
                                        child: tNewOneCustomStepper(
                                          defaultValue: productQty ?? 0,
                                          max: widget.product.availableQty ??
                                              200,
                                          onChange:
                                              (p0, increment, decrement) {
                                            updateProductQty(
                                              value: p0,
                                              decrement: decrement,
                                              increment: increment,
                                            );
                                          },
                                        ),
                                      ).centered(),
                                    ),
                                    CustomVisibilty(
                                      visible: productQty != null &&
                                          productQty <= 0,
                                      child: TextButton(
                                        onPressed: () {
                                          updateProductQty(
                                            value: 0,
                                            increment: true,
                                            decrement: false,
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          side: BorderSide(width: 3.0),
                                          minimumSize: Size(60, 0),
                                        ),
                                        child: Text('ADD'),
                                      ).centered(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          CustomVisibilty(
                            visible: !widget.product.hasStock,
                            child: ProductStockState(widget.product),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),


          ]),


        ]),

      ) ])
        .onInkTap(() => this.widget.onPressed(this.widget.product))
        .box
        .roundedSM
        .color(Color(0xFFF1F4FB))
        .clip(Clip.antiAlias)
        .outerShadowSm
        .makeCentered()
        .w(150);
  }

  void updateProductQty({int value = 0, bool increment, bool decrement}) {
    bool required = widget.product.optionGroupRequirementCheck();
    if (!required) {
      setState(() {
        widget.product.selectedQty = value;
      });
      widget.qtyUpdated(widget.product, value,
          isIncrement: increment, isDecrement: decrement);
    } else {
      widget.onPressed(widget.product);
    }
  }
}
