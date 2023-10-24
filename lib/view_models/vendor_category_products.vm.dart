import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/category.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/service/service_details.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorCategoryProductsViewModel extends MyBaseViewModel {
  //
  VendorCategoryProductsViewModel(
      BuildContext context,
      this.category,
      this.vendor,
      {bool isService = false}
      ) {
    this.viewContext = context;
    this.isService = isService;
  }

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Category category;
  Vendor vendor;
  Map<int, List> categoriesProducts = {};
  Map<int, int> categoriesProductsQueryPages = {};
  final currencySymbol = AppStrings.currencySymbol;
  bool isService = false;

  serviceSelected(Service service) {
    viewContext.push(
          (context) => ServiceDetailsPage(service),
    );
  }

  initialise() {
    //
    CartServices.cartItemStream.add(CartServices.productsInCart);


    if (category.hasSubcategories) {
      refreshContollers = List.generate(
        category.subcategories.length,
            (index) => new RefreshController(),
      );
      refreshContollerKeys = List.generate(
        category.subcategories.length,
            (index) => category.subcategories[index].id,
      );
      category.subcategories.forEach((element) {
        loadMoreProducts(element.id, vendorTypeId: isService ? element.vendorType?.id : null, subCategory: isService ? element : null);
        categoriesProductsQueryPages[element.id] = 1;
      });
    }
  }

  void productSelected(Product product) async {
    await viewContext.navigator.pushNamed(
      AppRoutes.product,
      arguments: product,
    );

    //
    notifyListeners();
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  loadMoreProducts(int id, {bool initialLoad = true, int vendorTypeId, Category subCategory}) async {
    int queryPage = categoriesProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      categoriesProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      categoriesProductsQueryPages[id] = ++queryPage;
    }

    //load the products by subcategory id
    try {

      var customDataList;
      if (vendorTypeId == null) {

        deliveryaddress.address = LocationService?.currenctAddress?.addressLine;
        deliveryaddress.latitude =
            LocationService?.currenctAddress?.coordinates?.latitude;
        deliveryaddress.longitude =
            LocationService?.currenctAddress?.coordinates?.longitude;

        customDataList = await _productRequest.getProdcuts(
          page: queryPage,
          queryParams: {
            "sub_category_id": id,
            "vendor_id": vendor?.id,
            "vendor_type_id": vendor?.vendorType?.id,
            "latitude": deliveryaddress?.latitude,
            "longitude": deliveryaddress?.longitude,
          },
        );

        var cartItemData = CartServices.productsInCart;
        for (int i = 0; i < cartItemData.length; i++) {
          int searchProductIndex = customDataList.indexWhere((element) => element.id == cartItemData[i].product.id);
          if (searchProductIndex != -1) {
            customDataList[searchProductIndex].selectedQty = cartItemData[i].selectedQty;
          }
        }

      } else {

        SearchRequest searchRequest = new SearchRequest();
        Search searchData = new Search(type: "service", subcategory: subCategory, vendorType: subCategory.vendorType, viewType: SearchType.services, category: category);
        searchData.byLocation = true;
        customDataList = (await searchRequest.searchRequest(type: "service", search: searchData));
        print("ServiceData: ${customDataList.length}");

      }

      //
      if (initialLoad) {
        categoriesProducts[id] = customDataList;
      } else {
        categoriesProducts[id].addAll(customDataList);
      }
    } catch (error) {}

    //
    if (initialLoad) {
      setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }

    //
    notifyListeners();
  }




}
