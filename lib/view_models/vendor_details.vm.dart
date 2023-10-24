import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/menu.dart';
import 'package:fuodz/models/tag.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:fuodz/views/pages/vendor_search/vendor_search.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorDetailsViewModel extends MyBaseViewModel {
  //


  VendorDetailsViewModel(BuildContext context, this.vendor) {
    this.viewContext = context;
  }


  VendorRequest _vendorRequest = VendorRequest();

  Vendor vendor;

  final currencySymbol = AppStrings.currencySymbol;

  ProductRequest _productRequest = ProductRequest();

  RefreshController refreshContoller = RefreshController();

  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  List<Tag> tagsDataList = [];
  Tag selectedTag;

  Future<void> onTagSelected(Tag tag, int id) async {
    selectedTag = tag;

    int temp_value = vendor.menus[id].id;
    setBusy(true);
    await loadMoreProducts(temp_value);
    setBusy(false);
    notifyListeners();
  }

  //
  void getVendorDetails() async {
    //
    setBusy(true);

    tagsDataList = await SearchRequest().getTags();
    tagsDataList.insert(0, new Tag(id: -1, name: "All"));
    selectedTag = tagsDataList.first;

    try {
      vendor = await _vendorRequest.vendorDetails(vendor.id, params: { "type": "small", });

      vendor.menus.insert(0, Menu(id: null, name: "All".tr()));

      if (vendor != null && vendor.categories != null) {
        subCategoryDataList.addAll(vendor.categories);
        subCategoryDataList.forEach((element) async {
          for (int i = 0; i < element.subcategories.length; i++) {
            bool includeCategory = (await _productRequest.getProdcuts(page: 1, queryParams: {"sub_category_id": element.subcategories[i].id, "vendor_id": vendor?.id})).isEmpty;
            if (includeCategory) {
              element.subcategories.remove(element.subcategories[i]);
            }
          }
        });
      }

      updateUiComponents();
      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  List<Category> subCategoryDataList = [];

  void updateUiComponents() {
    if (!vendor.hasSubcategories) {
      loadMenuProducts();
    }
  }

  void onViewCartPressed() async {
    await loadMenuProducts();
  }

  void productSelected(Product product) async {
    await viewContext.navigator.pushNamed(AppRoutes.product, arguments: product);
  }

  //
  void uploadPrescription() {
    viewContext.push((context) => PharmacyUploadPrescription(vendor));
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    if (index != -1) {
      return refreshContollers[index];
    }
  }

  void loadMenuProducts() {
    vendor.menus.forEach((element) {
      refreshContollers.add(new RefreshController());
      refreshContollerKeys.add(element.id);
      menuProductsQueryPages[element.id] = 1;
    });

    if (vendor.menus.isNotEmpty) {
      final itemData = vendor.menus.first;
      loadMoreProducts(itemData.id);
    }
  }

  Future<void> loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = menuProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      menuProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      menuProductsQueryPages[id] = ++queryPage;
    }

    try {

      final mProducts = await _productRequest.getProdcuts(page: queryPage, queryParams: {"menu_id": id, "vendor_id": vendor?.id, "tags" : selectedTag.id == -1 ? null : [selectedTag.id] });

      var tempProducts = mProducts;

      if (initialLoad) {
        menuProducts[id] = tempProducts;
      } else {
        menuProducts[id].addAll(tempProducts);
      }

    } catch (error) {
      print("load more error ==> $error");
    }

    if (initialLoad) {
      setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }

    notifyListeners();
  }

  openVendorSearch() {
    viewContext.push(
          (context) => VendorSearchPage(vendor),
    );
  }
}