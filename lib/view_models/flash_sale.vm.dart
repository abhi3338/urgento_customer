import 'package:flutter/material.dart';
import 'package:fuodz/models/flash_sale.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/flash_sale.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/view_models/base.view_model.dart';
class FlashSaleViewModel extends MyBaseViewModel {
  FlashSaleViewModel(BuildContext context, {this.vendorType,this.byLocation: true,this.flashSale}) {

    this.viewContext = context;
    this.byLocation = AppStrings.enableFatchByLocation;
  }

  //
  FlashSaleRequest _flashSaleRequest = FlashSaleRequest();
  RefreshController refreshController = RefreshController();
  User currentUser;

  //
  List<FlashSale> flashSales = [];
  List<Product> flashSaleItems = [];
  final VendorType vendorType;
  final FlashSale flashSale;
  bool byLocation;
  int queryPage = 1;

  //
  initialise() async {

    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    deliveryaddress.address = LocationService?.currenctAddress?.addressLine;
    deliveryaddress.latitude =
        LocationService?.currenctAddress?.coordinates?.latitude;
    deliveryaddress.longitude =
        LocationService?.currenctAddress?.coordinates?.longitude;

    setBusy(true);
    try {
      flashSales = await _flashSaleRequest.getFlashSales(
        queryParams: {
          "vendor_type_id": vendorType.id,
          "latitude": byLocation ? deliveryaddress?.latitude : null,
          "longitude": byLocation ? deliveryaddress?.longitude : null,
        },
      );
      setBusy(false);
      //fetch items for each flash sale
      fetchFlashSaleItems();
      clearErrors();
    } catch (error) {
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  fetchFlashSaleItems() async {
    for (var i = 0; i < flashSales.length; i++) {
      final flashSale = flashSales[i];
      setBusyForObject(flashSale.id, true);
      try {
        final flashSaleItems = await _flashSaleRequest.getProdcuts(
          queryParams: {
            "flash_sale_id": flashSale.id,
            "latitude": byLocation ? deliveryaddress?.latitude : null,
            "longitude": byLocation ? deliveryaddress?.longitude : null,
          },
        );

        //set data
        flashSales[i].items = flashSaleItems;
        clearErrors();
      } catch (error) {
        setError(error);
        toastError("$error");
      }
      setBusyForObject(flashSale.id, false);
    }
  }

  getFlashSaleItems([bool initial = true]) async {
    if (initial) {
      setBusy(true);
      queryPage = 1;
    } else {
      queryPage += 1;
      refreshController.refreshCompleted();
      setBusyForObject(flashSale.id, true);
    }
    try {
      final mFlashSaleItems = await _flashSaleRequest.getProdcuts(
        queryParams: {
          "flash_sale_id": flashSale.id,
          "latitude": byLocation ? deliveryaddress?.latitude : null,
          "longitude": byLocation ? deliveryaddress?.longitude : null,
        },
        page: queryPage,
      );

      if (!initial) {
        flashSaleItems.addAll(mFlashSaleItems);
        refreshController.loadComplete();
      } else {
        flashSaleItems = mFlashSaleItems;
        refreshController.refreshCompleted();
      }

      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }
}
