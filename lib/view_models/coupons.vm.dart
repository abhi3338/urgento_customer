import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/requests/coupon.request.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/cart.vm.dart';
import 'package:fuodz/views/pages/coupon/coupon_details.page.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CouponsViewModel extends MyBaseViewModel {
  CouponsViewModel(
    BuildContext context,
    this.vendorType, {
    this.coupon,
        this.vendor,
    this.byLocation = false,
    this.isCartPagevm = false,
    this.isDetailPagevm = false,
  }) {
    this.viewContext = context;
  }

  //
  List<Coupon> coupons = [];
  Coupon coupon;
  Vendor vendor;
  VendorType vendorType;
  bool byLocation;
  CouponRequest couponRequest = CouponRequest();
  bool isCartPagevm;
  bool isDetailPagevm;

  //
  initialise() {
    applyCouponIndex = 5000;
    fetchCoupons();
  }

  //
  fetchCoupons() async {
    print("isCartPagevm====>>>>>>$isCartPagevm");
    setBusy(true);
    List<int> vendorIdlist = [];
    if(isCartPagevm){
      List<Cart> cartItems = CartServices.productsInCart;
      cartItems.forEach((element) {
        vendorIdlist.add(element.product.vendorId);
      });
    }
    else if(isDetailPagevm){
      vendorIdlist.add(TempvendorId);
    }
    print("vendorIdlist===$vendorIdlist");

    // try {
      //filter by location if user selects delivery address
      coupons = await couponRequest.fetchCoupons(
        params: {
          "vendor_type_id": vendorType?.id,
          "vendor": vendor?.id,
          "vendor_id": isCartPagevm || isDetailPagevm ? vendorIdlist.toString() : [].toString()
        }
      );
      print("coupons fetch====>>>>$coupons");

      clearErrors();
    // } catch (error) {
    //   print("error loading coupons ==> $error");
    //   setError(error);
    // }
    setBusy(false);
  }

  couponSelected(Coupon coupon) async {
    // CartViewModel vm;
    // print("coupon.codeis====>>>>${coupon.code} ");
    // vm.couponTEC.text = coupon.code;
    viewContext.nextPage(CouponDetailsPage(coupon));
  }

  fetchCouponDetails() async {
    setBusyForObject(coupon, true);
    try {
      coupon = await couponRequest.fetchCoupon(coupon.id);
    } catch (error) {
      toastError("$error");
      setError(error);
    }
    setBusyForObject(coupon, false);
  }
}
