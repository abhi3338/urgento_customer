import 'package:flutter/material.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/category.request.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/category/subcategories.page.dart';
import 'package:fuodz/views/pages/vendor_details/vendor_category_products.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoriesViewModel extends MyBaseViewModel {
  CategoriesViewModel(BuildContext context, {this.vendorType, bool isGrocery = false, bool isService = false}) {
    this.viewContext = context;
    this.isGrocery = isGrocery;
    this.isService = isService;
  }

  //
  CategoryRequest _categoryRequest = CategoryRequest();
  RefreshController refreshController = RefreshController();

  //
  List<Category> categories = [];
  final VendorType vendorType;
  int queryPage = 1;
  bool isGrocery = false;
  bool isService = false;

  //
  initialise({bool all = false}) async {
    setBusy(true);
    try {
      categories = await _categoryRequest.categories(
        vendorTypeId: vendorType.id,
        page: queryPage,
        full: all ? 1 : 0,
      );
      if (isGrocery || isService) {
        for (int i = 0; i < categories.length; i++) {
          if (categories[i].subcategories.isEmpty) {
            categories[i].subcategories = await _categoryRequest.subcategories(categoryId: categories[i].id, page: 1);
          }
        }
      }
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  loadMoreItems([bool initialLoading = false, bool all = true]) async {
    if (initialLoading) {
      setBusy(true);
      queryPage = 1;
      refreshController.refreshCompleted();
    } else {
      queryPage += 1;
    }
    //
    try {
      final mCategories = await _categoryRequest.categories(
        vendorTypeId: vendorType.id,
        page: queryPage,
        full: all ? 1 : 0,
      );
      clearErrors();

      //
      if (isGrocery || isService) {
        for (int i = 0; i < mCategories.length; i++) {
          if (mCategories[i].subcategories.isEmpty) {
            mCategories[i].subcategories = await _categoryRequest.subcategories(categoryId: mCategories[i].id, page: 1);
          }
        }
      }
      if (initialLoading) {
        categories = mCategories;
      } else {
        categories.addAll(mCategories);
      }
    } catch (error) {
      setError(error);
    }
    if (initialLoading) {
      setBusy(false);
    }
    refreshController.loadComplete();
    notifyListeners();
  }

  //
  categorySelected(Category category) async {
    if (!isGrocery && !isService) {
      Widget page;
      final search = Search(
        vendorType: category.vendorType,
        category: category,
        showType: (category.vendorType.isService ?? false) ? 5 : 4,
      );
      page = NavigationService().searchPageWidget(search);

      viewContext.nextPage(page);
    } else {
      viewContext.nextPage(
        VendorCategoryProductsPage(
          category: category,
          vendor: new Vendor(vendorType: category.vendorType),
          isService: isService,
        ),
      );
    }
  }
}