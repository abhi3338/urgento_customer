import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/search_data.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/search_filter.vm.dart';
import 'package:fuodz/widgets/bottomsheets/search_filter.bottomsheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchViewModel extends MyBaseViewModel {
  //
  SearchRequest _searchRequest = SearchRequest();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  SearchData searchData;
  String keyword = "";
  String type = "";
  Category category;
  Search search;
  int selectTagId = 2;
  bool showGrid = false;
  //
  int queryPage = 1;
  List<dynamic> searchResults = [];
  bool filterByProducts = true;
  SearchFilterViewModel searchFilterVM;

  SearchViewModel(BuildContext context, this.search) {
    this.viewContext = context;
    this.vendorType = this.search.vendorType;
    //
    setSlectedTag(search.showType);
    CartServices.cartItemStream.add(CartServices.productsInCart);
  }

  //
  startSearch({bool initialLoaoding = true}) async {
    //
    if (initialLoaoding) {
      setBusy(true);
      queryPage = 1;
      refreshController.refreshCompleted();
    } else {
      queryPage = queryPage + 1;
    }

    //
    try {
      final searchResult = (await _searchRequest.searchRequest(
        keyword: keyword ?? "",
        search: search,
        page: queryPage,
      ));
      clearErrors();

      //
      if (initialLoaoding) {
        searchResults = searchResult;
      } else {
        searchResults.addAll(searchResult);
      }
      for (var cartItemData in CartServices.productsInCart) {
        int searchIndex = searchResults.indexWhere((element) => element.product.id == cartItemData.product.id);
        if (searchIndex != -1) {
          searchResults[searchIndex].selectedQty = cartItemData.product.selectedQty;
        }
      }
      //CartServices.cartItemStream.add(CartServices.productsInCart);
    } catch (error) {
      print("Error ==> $error");
      setError(error);
    }

    if (!initialLoaoding) {
      refreshController.loadComplete();
    }
    //done loading data
    setBusy(false);
  }

  //
  void showFilterOptions() async {
    if (searchFilterVM == null) {
      searchFilterVM = SearchFilterViewModel(viewContext, search);
    }

    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchFilterBottomSheet(
          search: search,
          vm: searchFilterVM,
          onSubmitted: (mSearch) {
            search = mSearch;
            queryPage = 1;
            startSearch();
          },
        );
      },
    );
  }

  //
  productSelected(Product product) async {
    var cartItemData = CartServices.productsInCart;
    int searchInCart = cartItemData.indexWhere((element) => element.product.id == product.id);
    if (searchInCart != -1) {
      product.selectedQty = cartItemData[searchInCart].selectedQty;
    }
    final page = NavigationService().productDetailsPageWidget(product);
    viewContext.nextPage(page);
  }

  //
  vendorSelected(Vendor vendor) async {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }

  setSlectedTag(int tagId) {
    //start the reassign the tagId from search to the view type of tag
    if (tagId == 4) {
      tagId = 1;
    } else if (tagId == 5) {
      tagId = 3;
    }
    //END

    selectTagId = tagId;
    refreshController = new RefreshController();
    //
    search.genApiType(selectTagId);
    startSearch();
  }

  toggleShowGird(bool mShowGrid) {
    showGrid = mShowGrid;
    refreshController = new RefreshController();
    notifyListeners();
  }
}
