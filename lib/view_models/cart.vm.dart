import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/requests/cart.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/cart_ui.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/checkout/multiple_order_checkout.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

int applyCouponIndex = 5000;
BuildContext tempContext ;
class CartViewModel extends MyBaseViewModel {
  //
  CartRequest cartRequest = CartRequest();
  List<Cart> cartItems = [];
  int totalCartItems = 0;
  double subTotalPrice = 0.0;
  double discountCartPrice = 0.0;
  double totalCartPrice = 0.0;

  //
  bool canApplyCoupon = false;
  Coupon coupon;
  TextEditingController couponTEC = TextEditingController();
  String applyStr = "Apply";


  //
  CartViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    cartItems = CartServices.productsInCart;
    //
    calculateSubTotal();
  }

  //
  calculateSubTotal() {
    //
    totalCartItems = 0;
    subTotalPrice = 0;
    discountCartPrice = 0;

    //
    cartItems.forEach(
      (cartItem) {
        totalCartItems += cartItem.selectedQty;
        final totalProductPrice = cartItem.price * cartItem.selectedQty;
        subTotalPrice += totalProductPrice;

        //discount/coupon
        if (coupon != null) {
          final foundProduct = coupon.products.firstWhere(
              (product) => cartItem.product.id == product.id,
              orElse: () => null);
          final foundVendor = coupon.vendors.firstWhere(
              (vendor) => cartItem.product.vendorId == vendor.id,
              orElse: () => null);

          //
          bool skipCalculation = false;
          //
          if (coupon.vendorTypeId != null) {
            //if vendor type match product vendor type
            if (foundProduct != null &&
                foundProduct?.vendor?.vendorType?.id == coupon.vendorTypeId) {
              skipCalculation = false;
            }
            //if vendor type match vendor type
            else if (foundVendor != null &&
                foundVendor?.vendorType?.id == coupon.vendorTypeId) {
              skipCalculation = false;
            } else if (cartItem.product?.vendor?.vendorTypeId ==
                coupon.vendorTypeId) {
              skipCalculation = false;
            } else {
              skipCalculation = true;
              setErrorForObject(
                  coupon, "Coupon can't be used with vendor type".tr());
            }
          }
          //
          if (!skipCalculation) {
            if (foundProduct != null ||
                foundVendor != null ||
                (coupon.products.isEmpty && coupon.vendors.isEmpty)) {
              if (coupon.percentage == 1) {
                if(couponTEC.text != ""){
                  discountCartPrice += (coupon.discount / 100) * totalProductPrice;
                }
              } else {
                if(couponTEC.text != ""){
                  discountCartPrice += coupon.discount;
                }
              }
            }
          }
        }

        //
      },
    );

    //check if coupon is allow with the discount price
    if (coupon != null) {
      try {
        discountCartPrice = coupon.validateDiscount(
          subTotalPrice,
          discountCartPrice,
          couponTEC: couponTEC
        );
        if(couponTEC.text != ""){
        showPopUpForApply(tempContext,couponCode: coupon.code,savedRs: discountCartPrice);
       }
      } catch (error) {
        discountCartPrice = 0;
        setErrorForObject(coupon, error);
      }
    }
    //
    totalCartPrice = subTotalPrice - discountCartPrice;
    notifyListeners();
  }



  showPopUpForApply(BuildContext context,{String couponCode,double savedRs}){
    double value = savedRs;
    double sValue = value;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                ),
                child: Icon(Icons.check,color: Vx.white,size: 40),
              ),
              SizedBox(height: 10),
              Text("${couponCode} applied"),
              SizedBox(height: 10),
              Text("You saved ₹${sValue.toStringAsFixed(2)}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              SizedBox(height: 10),
              Text("with this coupon code."),
              SizedBox(height: 10),
              Text("Woohoo! Thanks"),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }


  //
  deleteCartItem(int index) {
    //
    // AlertService.showConfirm()
    AlertService.showConfirm(
      title: "Remove From Cart".tr(),
      text: "Are you sure you want to remove this product from cart?".tr(),
      confirmBtnText: "Yes".tr(),
      onConfirm: () async {
        //
        //remove item/product from cart
        print('index===>>>>$index');
        cartItems.removeAt(index);
        print('cartItems===>>>>$cartItems');
        await CartServices.saveCartItems(cartItems);
        initialise();

        //close dialog
        viewContext.pop();
      },
    );
  }

  //
  updateCartItemQuantity(int qty, int index) async {
    final cart = cartItems[index];
    bool addedQty = qty > cart.selectedQty;
    //
    if (addedQty) {
      int qtyDiff = qty - cart.selectedQty;
      final canAdd = await CartUIServices.cartItemQtyUpdated(
        viewContext,
        qtyDiff,
        cart,
      );
      //
      if (!canAdd) {
        qty = cart.selectedQty;
        pageKey = GlobalKey<State>();
        notifyListeners();
        return;
      }
    }

    cartItems[index].selectedQty = qty;
    await CartServices.cartItemsCountStream.add(cartItems[index].selectedQty);
    await CartServices.saveCartItems(cartItems);
    initialise();
  }

  //
  couponCodeChange(String code) {
    canApplyCoupon = code.isNotBlank;
    print("canApplyCoupon====>>>>>$canApplyCoupon");
    print("canApplyCoupon====>>>>>${code.isNotBlank}");
    notifyListeners();
  }

  updateApply(){
    print("couponTEC.text for update===>>>${couponTEC.text}");
    couponTEC.text.isNotEmpty ? canApplyCoupon = true : canApplyCoupon = false;
    applyStr = "Applied!";
    notifyListeners();
  }

  //
  applyCoupon() async {
    //
    setBusyForObject(coupon, true);
    try {
      coupon = await cartRequest.fetchCoupon(couponTEC.text);
      //
      if (coupon.useLeft <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon.expired) {
        throw "Coupon has expired ".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      calculateSubTotal();
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon, error);
      coupon = null;
      calculateSubTotal();
    }
    setBusyForObject(coupon, false);
  }

  //
  checkoutPressed() async {
    //
    bool canOpenCheckout = true;
    if (!AuthServices.authenticated()) {
      //
      final result = await viewContext.navigator.pushNamed(
        AppRoutes.loginRoute,
      );
      if (result == null || !result) {
        canOpenCheckout = false;
      }
    }

    //
    CheckOut checkOut = CheckOut();
    checkOut.coupon = coupon;
    checkOut.subTotal = subTotalPrice;
    checkOut.discount = discountCartPrice;
    checkOut.total = totalCartPrice;
    checkOut.totalWithTip = totalCartPrice;
    checkOut.cartItems = cartItems;

    //
    if (canOpenCheckout) {
      dynamic result;
      //check if multiple vendor order was added to cart
      if (AppStrings.enableMultipleVendorOrder &&
          CartServices.isMultipleOrder()) {
        result = await viewContext.push(
          (ctx) => MultipleOrderCheckoutPage(checkout: checkOut),
        );
      } else {
        result = await viewContext.navigator.pushNamed(
          AppRoutes.checkoutRoute,
          arguments: checkOut,
        );
      }

      if (result != null && result) {
        //
        await CartServices.saveCartItems([]);
        viewContext.pop();
      }
    }
  }
}
