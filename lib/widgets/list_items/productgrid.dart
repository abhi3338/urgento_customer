import 'package:flutter/material.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/states/product_stock.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/widgets/states/alternative.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/scustom_steppr.view.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/inputs/drop_down.input.dart';
import 'package:fuodz/widgets/states/product_stock.dart';
import 'package:fuodz/widgets/tags/discount.positioned.dart';
import 'package:fuodz/widgets/tags/fav.positioned.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductGridListItem extends StatefulWidget {
  const ProductGridListItem(this.product,
      {this.onPressed,
        @required this.qtyUpdated,
        this.height,
        this.onNewQtyUpdated, Key key})
      : super(key: key);

  final Product product;
  final Function(Product) onPressed;
  final Function(Product, int, {bool isIncrement, bool isDecrement}) qtyUpdated;
  final Function(Product, int, bool isIncrement, bool isDecrement) onNewQtyUpdated;
  final double height;

  @override
  State<ProductGridListItem> createState() => _ProductGridListItemState();
}

class _ProductGridListItemState extends State<ProductGridListItem> {

  Widget shimmerView(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        height: double.infinity,
        child: VStack([], axisSize: MainAxisSize.max).wFull(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      print("shimmer");
      return shimmerView(context);
    }


    final currencySymbol = AppStrings.currencySymbol;
    return VStack([

      VStack([

        Stack(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(3), // Image border
              child: CustomImage(
                          imageUrl: widget.product.photo,

                          width: double.infinity,
                          height: Vx.dp64 * 2
                      ),




            ).pOnly(bottom: 10),

            //discount
            Visibility(
              visible: widget.product.showDiscount,
              child: "%s Off"
                  .tr()
                  .fill(["${widget.product.discountPercentage}%"])
                  .text
                  .sm
                  .white
                  .semiBold
                  .make()
                  .p2()
                  .px4()
                  .box
                  .green500
                  .withRounded(value: 7)
                  .make(),
            ),
          ],
        ),



        /*CustomImage(imageUrl: product.photo, height: 130, width: 180)
        .box
        .clip(Clip.antiAlias)
        .roundedSM
        .make(),

        UiSpacer.horizontalSpace(space: 6),

        Visibility(
          visible: product.showDiscount,
          child: "%s Off"
              .tr()
              .fill(["${product.discountPercentage}%"])
              .text
              .sm
              .white
              .semiBold
              .make()
              .p2()
              .px4()
              .box
              .green300
              .withRounded(value: 7)
              .make(),
        ),*/

      ]),

      VStack([

        VStack([

          Container(
            height: 32,
            child: Text(
              '${widget.product.name}',
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow:TextOverflow.ellipsis,
              style: TextStyle(height:1.0,fontWeight: FontWeight.w700,fontFamily: GoogleFonts.lato().fontFamily,color:Color(0xFF181725),fontSize: 13.0,letterSpacing: 0.025),
            ),
          ),

          UiSpacer.verticalSpace(space: 4),

          Container(
            height: 14,
            child: Text(
              '${widget.product.description}',
              textAlign: TextAlign.left,
              overflow:TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(height:1.0,fontWeight: FontWeight.w200,fontFamily: GoogleFonts.lato().fontFamily,color:Color(0xFF181725),fontSize: 11.0,letterSpacing: 0.025),
            ),
          ),

          Container(
            height: 14,
            child:  CustomVisibilty(
                visible: !widget.product.capacity.isEmptyOrNull && !widget.product.unit.isEmptyOrNull,
                child: "   ${widget.product.capacity} ${widget.product.unit}   "
                    .text
                    .xs
                    .color(Color(0xFF181725))
                    .extraBold
                    .make()
                    .box.rounded.gray300

                    .make()
            ),
          ),

         /* "${widget.product.name}".text.extraBlack.extraBold.lg.maxLines(4).overflow(TextOverflow.ellipsis).make(), */


          /*widget.product.description.text.xs.light.maxLines(1).overflow(TextOverflow.ellipsis).make(),*/

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
            UiSpacer.horizontalSpace(space: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: [
                  HStack([
                    Visibility(
                      visible: widget.product.optionGroups.isNotEmpty,
                      child: Container(
                        height: 30,
                        width: 90,
                        child: TextButton(
                          onPressed: () {
                            final ProductDetailsViewModel productDetailsViewModel =
                            new ProductDetailsViewModel(context, widget.product);
                            productDetailsViewModel.addToCart();
                          },
                          style: TextButton.styleFrom(
                            side: BorderSide(width: 2.0,color: Color(0xFF181725)),
                            minimumSize: Size(90, 0),
                          ),
                          child: Text('ADD',style: TextStyle(
    color: Color(0xFF181725)
    ),),
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
                                          (element) => element.product.id == widget.product.id);
                                  if (searchIndex != -1) {
                                    productQty = tempCartData[searchIndex].selectedQty;
                                  }
                                  print("productgrid.dart: $productQty");
                                  return Stack(
                                    children: [
                                      CustomVisibilty(
                                        visible: productQty != null && productQty > 0,
                                        child: Container(
                                          height: 30,
                                          width: 90,
                                          child: sNewOneCustomStepper(
                                            defaultValue: productQty ?? 0,
                                            max: widget.product.availableQty ?? 200,
                                            onChange: (p0, increment, decrement) {
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
                                        visible: productQty != null && productQty <= 0,
                                        child: Container(

                                          child: TextButton(
                                            onPressed: () {
                                              updateProductQty(
                                                value: 0,
                                                increment: true,
                                                decrement: false,
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              side: BorderSide(width: 2.0,color: Color(0xFF181725)),
                                              minimumSize: Size(90, 0),
                                            ),
                                            child: Text('ADD',style: TextStyle(
                                  color: Color(0xFF181725),
                                  ),),
                                          ).centered(),
                                        ),
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
            ),
          ]),











          /*


        UiSpacer.verticalSpace(space: 3),
        ProductStockState(
          product,
          qtyUpdated: qtyUpdated,
          useNewStepper: true,
          newQtyUpdated: (newTemporaryProduct, int value, {bool increment, bool decrement}) {
            if (onNewQtyUpdated != null) {
              onNewQtyUpdated(newTemporaryProduct, value, increment, decrement);
            }
          },
        ), */
        ]),





      ]).p8(),



    ])
        .onInkTap(() => this.widget.onPressed(this.widget.product))
        .wFull(context)
        .box

        .roundedSM
        .color(Colors.white)

        .makeCentered();

  }
  void updateProductQty({int value = 0, bool increment, bool decrement}) {
    bool required = widget.product.optionGroupRequirementCheck();
    if (!required) {
      setState(() {
        widget.product.selectedQty = value;
      });
      widget.qtyUpdated(widget.product, value, isIncrement: increment, isDecrement: decrement);
    } else {
      widget.onPressed(widget.product);
    }
  }
}
