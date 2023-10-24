import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/requests/service.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/auth/new_ui_login/new_login.view.dart';
import 'package:fuodz/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:fuodz/views/pages/product/product_details.page.dart';
import 'package:fuodz/views/pages/service/service_details.page.dart';
import 'package:fuodz/views/pages/vendor_details/vendor_details.page.dart';
import 'package:fuodz/views/pages/welcome/welcome.page.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:in_app_update/in_app_update.dart';

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  int currentIndex = 0;
  PageController pageViewController = PageController(initialPage: 0);
  int totalCartItems = 0;
  StreamSubscription homePageChangeStream;
  Widget homeView = WelcomePage();

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      AppUpdateInfo _updateInfo = info;
      if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) {
          print("Exception: $e");
        });
      }
    }).catchError((e) {
      print("Exception: $e");
    });
  }

  @override
  void initialise() async {
    //
    handleAppLink();

    if (Platform.isAndroid) {
      checkForUpdate();
    }

    //determine if homeview should be multiple vendor types or single vendor page
    if (AppStrings.isSingleVendorMode) {
      VendorType vendorType = VendorType.fromJson(AppStrings.enabledVendorType);
      homeView = NavigationService.vendorTypePage(
        vendorType,
        context: viewContext,
      );
      //require login
      if (vendorType.authRequired && !AuthServices.authenticated()) {
        // await viewContext.push(
        //   (context) => LoginPage(
        //     required: true,
        //   ),
        // );

        await viewContext.push(
              (context) => NewUILogin(
            authRequired: true,
          ),
        );
      }
      notifyListeners();
    }

    LocalStorageService.rxPrefs.getStringStream(CartServices.cartItemsKey).listen((event) {
      if (event != null) {
        List<dynamic> cartData = json.decode(event);
        CartServices.productsInCart = cartData.map((e) => Cart.fromJson(e)).toList();
        print("home.vm.dart: ${CartServices.productsInCart.length}");
        //cartItemListStream.add(CartServices.productsInCart);
        CartServices.cartItemStream.add(CartServices.productsInCart);
      }
      notifyListeners();
    });

    //start listening to changes to items in cart
    // LocalStorageService.rxPrefs.getIntStream(CartServices.totalItemKey).listen(
    //   (total) {
    //     if (total != null) {
    //       totalCartItems = total;
    //       notifyListeners();
    //     }
    //   },
    // );

    //
    homePageChangeStream = AppService().homePageIndex.stream.listen(
          (index) {
        //
        onTabChange(index);
      },
    );
  }

  //
  // dispose() {
  //   super.dispose();
  //   homePageChangeStream.cancel();
  // }

  //
  onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  onTabChange(int index) {
    currentIndex = index;
    pageViewController.animateToPage(
      currentIndex,
      duration: Duration(microseconds: 5),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }

  //
  handleAppLink() async {
    // Get any initial links
    final PendingDynamicLinkData initialLink =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      openPageByLink(deepLink);
    }

    //
    FirebaseDynamicLinks.instance.onLink.listen(
          (dynamicLinkData) {
        //
        openPageByLink(dynamicLinkData.link);
      },
    ).onError(
          (error) {
        // Handle errors
        print("error opening link ==> $error");
      },
    );
  }

  //
  openPageByLink(Uri deepLink) async {
    final cleanLink = Uri.decodeComponent(deepLink.toString());
    if (cleanLink.contains(Api.appShareLink)) {
      //
      try {
        final linkFragments = cleanLink.split(Api.appShareLink);
        final dataSection = linkFragments[1];
        final pathFragments = dataSection.split("/");
        final dataId = pathFragments[pathFragments.length - 1];

        if (dataSection.contains("product")) {
          Product product = Product(id: int.parse(dataId));
          ProductRequest _productRequest = ProductRequest();
          AlertService.showLoading();
          product = await _productRequest.productDetails(product.id);
          AlertService.stopLoading();
          if (!product.vendor.vendorType.slug.contains("commerce")) {
            viewContext.push(
                  (context) => ProductDetailsPage(
                product: product,
              ),
            );
          } else {
            viewContext.push(
                  (context) => AmazonStyledCommerceProductDetailsPage(
                product: product,
              ),
            );
          }
        } else if (dataSection.contains("vendor")) {
          Vendor vendor = Vendor(id: int.parse(dataId));
          VendorRequest _vendorRequest = VendorRequest();
          AlertService.showLoading();
          vendor = await _vendorRequest.vendorDetails(vendor.id);
          AlertService.stopLoading();
          viewContext.push(
                (context) => VendorDetailsPage(
              vendor: vendor,
            ),
          );
        } else if (dataSection.contains("service")) {
          Service service = Service(id: int.parse(dataId));
          ServiceRequest _serviceRequest = ServiceRequest();
          AlertService.showLoading();
          service = await _serviceRequest.serviceDetails(service.id);
          AlertService.stopLoading();
          viewContext.push(
                (context) => ServiceDetailsPage(service),
          );
        }
      } catch (error) {
        AlertService.stopLoading();
        toastError("$error");
      }
    }
    print("Url Link ==> $cleanLink");
  }
}