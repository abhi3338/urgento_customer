import 'package:flutter/material.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/views/pages/booking/booking.page.dart';
import 'package:fuodz/views/pages/commerce/commerce.page.dart';
import 'package:fuodz/views/pages/food/food.page.dart';
import 'package:fuodz/views/pages/grocery/grocery.page.dart';
import 'package:fuodz/views/pages/parcel/parcel.page.dart';
import 'package:fuodz/views/pages/pharmacy/pharmacy.page.dart';
import 'package:fuodz/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:fuodz/views/pages/product/product_details.page.dart';
import 'package:fuodz/views/pages/search/product_search.page.dart';
import 'package:fuodz/views/pages/search/search.page.dart';
import 'package:fuodz/views/pages/search/service_search.page.dart';
import 'package:fuodz/views/pages/service/service.page.dart';
import 'package:fuodz/views/pages/taxi/taxi.page.dart';
import 'package:fuodz/views/pages/vendor/vendor.page.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/pages/auth/new_ui_login/new_login.view.dart';

class NavigationService {
  static pageSelected(VendorType vendorType,
      {BuildContext context, bool loadNext = true}) async {
    Widget nextpage = vendorTypePage(vendorType);

    //
    if (vendorType.authRequired && !AuthServices.authenticated()) {
      final result = await context.push(
        (context) => NewUILogin(
          authRequired: true,
        )
      );
      //
      if (result == null || !result) {
        return;
      }
    }
    //
    if (loadNext) {
      context.nextPage(nextpage);
    }
  }

  static Widget vendorTypePage(VendorType vendorType, {BuildContext context}) {
    Widget homeView = VendorPage(vendorType);
    switch (vendorType.slug) {
      case "parcel":
        homeView = ParcelPage(vendorType);
        break;
      case "grocery":
        homeView = GroceryPage(vendorType);
        break;
      case "food":
        homeView = FoodPage(vendorType);
        break;
      case "pharmacy":
        homeView = PharmacyPage(vendorType);
        break;
      case "service":
        homeView = ServicePage(vendorType);
        break;
      case "booking":
        homeView = BookingPage(vendorType);
        break;
      case "taxi":
        homeView = TaxiPage(vendorType);
        break;
      case "commerce":
        homeView = CommercePage(vendorType);
        break;
      default:
        homeView = VendorPage(vendorType);
        break;
    }
    return homeView;
  }

  ///special for product page
  Widget productDetailsPageWidget(Product product) {
    if (!product.vendor.vendorType.isCommerce) {
      return ProductDetailsPage(
        product: product,
      );
    } else {
      return AmazonStyledCommerceProductDetailsPage(
        product: product,
      );
    }
  }

  //
  Widget searchPageWidget(Search search) {
    if (search.vendorType.isProduct) {
      return ProductSearchPage(search: search);
    } else if (search.vendorType.isService) {
      return ServiceSearchPage(search: search);
    } else if (search.vendorType.isGrocery) {
      return ProductSearchPage(search: search);
    } else {
      return SearchPage(search: search);
    }
  }
}
