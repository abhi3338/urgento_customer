import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/enums/product_fetch_data_type.enum.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';

class ProductsViewModel extends MyBaseViewModel {
  //
  ProductsViewModel(
    BuildContext context,
    this.vendorType,
    this.type, {
    this.categoryId,
    this.byLocation = true,
  }) {
    this.viewContext = context;
    this.byLocation = AppStrings.enableFatchByLocation;
  }

  //
  User currentUser;

  //
  VendorType vendorType;
  int categoryId;
  ProductFetchDataType type;
  ProductRequest productRequest = ProductRequest();
  List<Product> products = [];
  bool byLocation;

  bool get anyProductWithOptions {
    try {
      return products.firstWhere((e) =>
              e.optionGroups != null &&
              e.optionGroups.first != null &&
              e.optionGroups.first.options.isNotEmpty) !=
          null;
    } catch (error) {
      return false;
    }
  }

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    deliveryaddress.address = LocationService?.currenctAddress?.addressLine;
    deliveryaddress.latitude =
        LocationService?.currenctAddress?.coordinates?.latitude;
    deliveryaddress.longitude =
        LocationService?.currenctAddress?.coordinates?.longitude;

    //get today picks
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusy(true);
    try {
      products = await productRequest.getProdcuts(
        queryParams: {
          "category_id": categoryId,
          "vendor_type_id": vendorType.id,
          "type": type.name.toLowerCase(),
          "latitude": byLocation ? deliveryaddress?.latitude : null,
          "longitude": byLocation ? deliveryaddress?.longitude : null,
        },
      );
    } catch (error) {
      print("Error ==> $error");
    }
    setBusy(false);
  }
}
