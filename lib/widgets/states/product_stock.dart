import 'package:flutter/material.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_steppr.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductStockState extends StatefulWidget {
  const ProductStockState(this.product, {this.qtyUpdated, Key key, this.newQtyUpdated, this.useNewStepper = false})
      : super(key: key);

  final Product product;
  final Function qtyUpdated;
  final Function(Product, int, {bool increment, bool decrement}) newQtyUpdated;
  final bool useNewStepper;

  @override
  _ProductStockStateState createState() => _ProductStockStateState();
}

class _ProductStockStateState extends State<ProductStockState> {

  @override
  Widget build(BuildContext context) {
    if (widget.useNewStepper) {
      return StreamBuilder<List<Cart>>(
        initialData: List.empty(),
        stream: CartServices.cartItemStream.stream,
        builder: (context, snapshot) {
          int productQty = 0;
          List<Cart> tempCartData;
          if (snapshot.data != null || snapshot.data.isEmpty) {
            tempCartData = snapshot.data;
          } else {
            tempCartData = CartServices.productsInCart;
          }
          int searchIndex = tempCartData.indexWhere((element) => element.product.id == widget.product.id);
          if (searchIndex != -1) {
            productQty = tempCartData[searchIndex].selectedQty;
          }
          print("product_stock.dart: ${productQty}");
          return optionGroupRequirementCheck(context)
          ? UiSpacer.emptySpace()
          : widget.product.hasStock
          ? NewOneCustomStepper(
            max: widget.product.availableQty ?? 20,
            defaultValue: productQty ?? 0,
            onChange: (p0, increment, decrement) {
              bool required = optionGroupRequirementCheck(context);
              if (!required) {
                widget.newQtyUpdated(widget.product, p0, increment: increment, decrement: decrement);
              } 
            },
          ).py4().centered()
          : !widget.product.hasStock
          ? "No stock".tr().text.xs.white.makeCentered().py2().px4().box.red600.roundedSM.make().p8()
          : UiSpacer.emptySpace();
        },
      );
    }
    
    final cartItemData = CartServices.productsInCart;
    final searchProductIndex = cartItemData.indexWhere((element) => element.product.id == widget.product.id);
    int productQty = 0;
    if (searchProductIndex != -1) {
      print("product_stock: $cartItemData");
      productQty = cartItemData[searchProductIndex].selectedQty;
      print("product_stock: (SelectedQty) $productQty");
    }
    return optionGroupRequirementCheck(context)
        ? UiSpacer.emptySpace()
        : (widget.product.hasStock)
            ? CustomStepper(
                defaultValue: productQty,
                max: widget.product.availableQty ?? 20,
                onChange: (qty) {
                  //
                  bool required = optionGroupRequirementCheck(context);
                  if (!required) {
                    widget.qtyUpdated(widget.product, qty);
                  } else {
                    print("not working");
                  }
                },
              )
                //  VxStepper(
                //     disableInput: true,
                //     defaultValue: 0,
                //     max: widget.product.availableQty ?? 20,
                //     onChange: (qty) {
                //       //
                //       bool required = optionGroupRequirementCheck(context);
                //       if (!required) {
                //         widget.qtyUpdated(widget.product, qty);
                //       } else {
                //         print("not working");
                //       }
                //     },
                //   )
                .py4()
                .centered()
            : !widget.product.hasStock
                ? "No stock"
                    .tr()
                    .text.xs
                    .white
                    .makeCentered()
                    .py2()
                    .px4()
                    .box
                    .red600
                    .roundedSM
                    .make()
                    .p8()
                : UiSpacer.emptySpace();
  }

  optionGroupRequirementCheck(BuildContext context) {
    //check if the option groups with required setting has an option selected
    OptionGroup optionGroupRequired = widget.product.optionGroups
        .firstWhere((e) => e.required == 1, orElse: () => null);
    //

    if (optionGroupRequired == null) {
      return false;
    } else {
      return true;
    }
  }
}
