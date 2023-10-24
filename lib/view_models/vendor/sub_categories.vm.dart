import 'package:flutter/material.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/requests/category.request.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class SubcategoriesViewModel extends MyBaseViewModel {
  SubcategoriesViewModel(BuildContext context, this.category) {
    this.viewContext = context;
  }

  //
  CategoryRequest _categoryRequest = CategoryRequest();
  RefreshController refreshController = RefreshController();

  //
  List<Category> subcategories = [];
  final Category category;
  int queryPage = 1;

  //
  initialise({bool all = false}) async {
    setBusy(true);
    try {
      subcategories = await _categoryRequest.subcategories(
        categoryId: category.id,
        page: queryPage,
      );
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
      final mCategories = await _categoryRequest.subcategories(
        categoryId: category.id,
        page: queryPage,
      );
      clearErrors();

      //
      if (initialLoading) {
        subcategories = mCategories;
      } else {
        subcategories.addAll(mCategories);
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
    final search = Search(
      vendorType: category.vendorType,
      category: category,
      subcategory: category,
      showType: (category.vendorType.isService ?? false) ? 5 : 4,
    );
    final page = NavigationService().searchPageWidget(search);

    viewContext.nextPage(page);
  }
}
