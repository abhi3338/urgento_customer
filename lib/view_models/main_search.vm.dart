import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/requests/vendor_type.request.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/search.vm.dart';
import 'package:fuodz/view_models/search_filter.vm.dart';
import 'package:fuodz/widgets/bottomsheets/search_filter.bottomsheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class MainSearchViewModel extends SearchViewModel {
  //
  SearchRequest _searchRequest = SearchRequest();
  ScrollController scrollController = ScrollController();
  List<RefreshController> refreshControllers = [
    RefreshController(),
    RefreshController(),
    RefreshController()
  ];
  String keyword = "";
  Category category;
  //
  int vendorsPage = 1;
  int productsPage = 1;
  int servicesPage = 1;
  bool showVendors = false;
  bool showProducts = false;
  bool showServices = false;
  List<Vendor> vendors = [];
  List<Product> products = [];
  List<Service> services = [];
  int selectedIndex = 0;

  MainSearchViewModel(BuildContext context) : super(context, Search());

  fetchSearchTabs() async {
    setBusy(true);
    try {
      final vendorTypes = await VendorTypeRequest().index();
      for (var vendorType in vendorTypes) {
        if (vendorType.isService) {
          showServices = true;
        } else if (vendorType.isProduct) {
          showProducts = true;
        }
      }

      showVendors = showServices ?? showProducts;
    } catch (error) {
      toastError("$error");
    }
    setBusy(false);
  }

  onTabChange(int index) {
    selectedIndex = index;
    notifyListeners();
    if (index == 0 && (vendors == null || vendors.isEmpty)) {
      searchVendors();
    } else if (index == 1 && (products == null || products.isEmpty)) {
      searchProducts();
    } else if (index == 2 && (services == null || services.isEmpty)) {
      searchServices();
    }
  }

  //
  startSearch({bool initialLoaoding = true}) async {
    if (selectedIndex == 0) {
      searchVendors(initial: initialLoaoding);
    } else if (selectedIndex == 1) {
      searchProducts(initial: initialLoaoding);
    } else {
      searchServices(initial: initialLoaoding);
    }
  }

  searchVendors({bool initial = true}) async {
    //
    if (initial) {
      setBusyForObject(vendors, true);
      vendorsPage = 1;
      refreshControllers[0].refreshCompleted();
    } else {
      vendorsPage = vendorsPage + 1;
    }

    //
    try {
      List<Vendor> searchResult = (await _searchRequest.searchRequest(
        keyword: keyword ?? "",
        search: search,
        type: "vendor",
        page: vendorsPage,
      ))
          .cast<Vendor>();
      clearErrors();

      //
      if (initial) {
        vendors = searchResult;
      } else {
        vendors.addAll(searchResult);
      }
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      toastError("$error");
    }

    if (!initial) {
      refreshControllers[0].loadComplete();
    }
    //done loading data
    setBusyForObject(vendors, false);
  }

  searchProducts({bool initial = true}) async {
    //
    if (initial) {
      setBusyForObject(products, true);
      productsPage = 1;
      refreshControllers[1].refreshCompleted();
    } else {
      productsPage = productsPage + 1;
    }

    //
    try {
      List<Product> searchResult = (await _searchRequest.searchRequest(
        keyword: keyword ?? "",
        search: search,
        type: "product",
        page: productsPage,
      ))
          .cast<Product>();
      clearErrors();

      //
      if (initial) {
        products = searchResult;
      } else {
        products.addAll(searchResult);
      }
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      toastError("$error");
    }

    if (!initial) {
      refreshControllers[1].loadComplete();
    }
    //done loading data
    setBusyForObject(products, false);
  }

  searchServices({bool initial = true}) async {
    //
    if (initial) {
      setBusyForObject(services, true);
      servicesPage = 1;
      refreshControllers.last.refreshCompleted();
    } else {
      servicesPage = servicesPage + 1;
    }

    //
    try {
      List<Service> searchResult = (await _searchRequest.searchRequest(
        keyword: keyword ?? "",
        search: search,
        type: "service",
        page: servicesPage,
      ))
          .cast<Service>();
      clearErrors();

      //
      if (initial) {
        services = searchResult;
      } else {
        services.addAll(searchResult);
      }
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      toastError("$error");
    }

    if (!initial) {
      refreshControllers.last.loadComplete();
    }
    //done loading data
    setBusyForObject(services, false);
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
    int searchProductIndex = CartServices.productsInCart.indexWhere((element) => element.product.id == product.id);
    if (searchProductIndex != -1) {
      product.selectedQty = CartServices.productsInCart[searchProductIndex].selectedQty;
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

  toggleShowGird(bool mShowGrid) {
    showGrid = mShowGrid;
    refreshController = new RefreshController();
    notifyListeners();
  }
}
