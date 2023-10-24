import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_dynamic_link.dart';
import 'package:fuodz/constants/app_map_settings.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/cart_ui.service.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/services/update.service.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/views/pages/auth/login.page.dart';
import 'package:fuodz/views/pages/auth/new_ui_login/new_login.view.dart';
import 'package:fuodz/views/pages/cart/cart.page.dart';
import 'package:fuodz/views/pages/service/service_details.page.dart';
import 'package:fuodz/views/pages/vendor/vendor_reviews.page.dart';
import 'package:fuodz/views/shared/ops_map.page.dart';
import 'package:fuodz/widgets/bottomsheets/delivery_address_picker.bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBaseViewModel extends BaseViewModel with UpdateService {
  //
  BuildContext viewContext;
  GlobalKey pageKey = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  final formBuilderKey = GlobalKey<FormBuilderState>();
  GlobalKey genKey = GlobalKey();
  final currencySymbol = AppStrings.currencySymbol;
  DeliveryAddress deliveryaddress = DeliveryAddress();
  String firebaseVerificationId;
  VendorType vendorType;
  Vendor vendor;
  RefreshController refreshController = RefreshController();

  void initialise() {}

  void reloadPage() {
    pageKey = new GlobalKey<State>();
    refreshController = new RefreshController();
    notifyListeners();
    initialise();
  }

  openWebpageLink(String url) async {
    PaymentViewModel paymentViewModel = PaymentViewModel();
    paymentViewModel.viewContext = viewContext;
    await paymentViewModel.openWebpageLink(url);
  }

  //
  //open delivery address picker
  void pickDeliveryAddress({
    bool vendorCheckRequired = true,
    Function onselected,
  }) {
    //
    showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DeliveryAddressPicker(
          vendorCheckRequired: vendorCheckRequired,
          allowOnMap: true,
          onSelectDeliveryAddress: (mDeliveryaddress) {
            print("called here");
            viewContext.pop();
            deliveryaddress = mDeliveryaddress;
            notifyListeners();

            //
            final address = Address(
              coordinates: Coordinates(
                deliveryaddress.latitude,
                deliveryaddress.longitude,
              ),
              addressLine: deliveryaddress.address,
            );
            //
            LocationService.currenctAddress = address;
            //
            LocationService.currenctAddressSubject.sink.add(address);

            //
            if (onselected != null) {
              onselected();
            }
          },
        );
      },
    );
  }

  //
  bool isAuthenticated() {
    return AuthServices.authenticated();
  }

  //
  void openLogin() async {
    //await viewContext.nextPage(LoginPage());
    await viewContext.nextPage(NewUILogin());
    notifyListeners();
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  //
  //
  Future<DeliveryAddress> showDeliveryAddressPicker() async {
    //
    DeliveryAddress selectedDeliveryAddress;

    //
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeliveryAddressPicker(
          onSelectDeliveryAddress: (deliveryAddress) {
            viewContext.pop();
            selectedDeliveryAddress = deliveryAddress;
          },
        );
      },
    );

    return selectedDeliveryAddress;
  }

  //
  Future<DeliveryAddress> getLocationCityName(
      DeliveryAddress deliveryAddress) async {
    final coordinates =
    new Coordinates(deliveryAddress.latitude, deliveryAddress.longitude);
    final addresses = await GeocoderService().findAddressesFromCoordinates(
      coordinates,
    );
    //
    deliveryAddress.city = addresses.first.locality;
    deliveryAddress.state = addresses.first.adminArea;
    deliveryAddress.country = addresses.first.countryName;
    return deliveryAddress;
  }

  Future addToCartDirectly(Product product, int qty, {bool force = false, bool isIncrement = false, bool isDecrement = false}) async {
    if (qty == 0 && isDecrement) {
      return;
    }
    
    final cart = Cart();
    cart.price = (product.showDiscount ? product.discountPrice : product.price);
    product.selectedQty = qty;
    cart.product = product;
    print("VendorId: ${cart.product.vendorId}");
    cart.product.selectedQty = qty;
    cart.selectedQty = qty;
    cart.options = product.selectedOptions ?? [];
    cart.optionsIds = product.selectedOptions.map((e) => e.id).toList() ?? [];

    // if (qty <= 0) {
    //   final mProductsInCart = CartServices.productsInCart;
    //   final previousProductIndex = mProductsInCart.indexWhere((e) => e.product.id == product.id);
    //   if (previousProductIndex != -1) {
    //     mProductsInCart.removeAt(previousProductIndex);
    //     await CartServices.saveCartItems(mProductsInCart);
    //     CartServices.cartItemStream.add(mProductsInCart);
    //   } else {
    //     if (isIncrement) {
    //       cart.selectedQty += 1;
    //       cart.product.selectedQty += 1;
    //     }
    //     if (isDecrement) {
    //       cart.selectedQty -= 1;
    //       cart.product.selectedQty -= 1;
    //     }
    //     await CartServices.addToCart(cart);
    //   }
    //   notifyListeners();
    //   return;
    // }


    try {
      bool canAddToCart = await CartUIServices.handleCartEntry(viewContext, cart, product);

      if (canAddToCart || force) {
        if (isIncrement) {
          cart.selectedQty += 1;
          cart.product.selectedQty += 1;
        }
        if (isDecrement) {
          cart.selectedQty -= 1;
          cart.product.selectedQty -= 1;
        }
        final mProductsInCart = CartServices.productsInCart;
        final previousProductIndex = mProductsInCart.indexWhere((e) => e.product.id == product.id);
        if (previousProductIndex != -1) {
          mProductsInCart.removeAt(previousProductIndex);
          if (cart.selectedQty > 0) {
            mProductsInCart.insert(previousProductIndex, cart);
          }
          await CartServices.saveCartItems(mProductsInCart);
        } else {
          await CartServices.addToCart(cart);
        }
        CartServices.cartItemStream.add(CartServices.productsInCart);
        notifyListeners();

      } else if (product.isDigital) {

        CoolAlert.show(
          context: viewContext,
          title: "Digital Product".tr(),
          text: "You can only buy/purchase digital products together with other digital products. Do you want to clear cart and add this product?".tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            viewContext.pop();
            await CartServices.clearCart();
            addToCartDirectly(product, qty, force: true);
          },
        );

      } else {

        CoolAlert.show(
          context: viewContext,
          title: "Replace items already in the cart?".tr(),
          text: "Your cart contains items from other store. Do you want to discard the selection and add items from this store?".tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            viewContext.pop();
            await CartServices.clearCart();
            //addToCartDirectly(product, qty, force: true);
            addToCartDirectly(product, 1, force: true);
          },
        );

      }

    } catch (error) {
      print("Cart Error => $error");
      setError(error);
    }
    notifyListeners();
  }

  //switch to use current location instead of selected delivery address
  void useUserLocation() {
    LocationService.geocodeCurrentLocation();
  }

  //
  openSearch({int showType = 4}) async {
    final search = Search(
      vendorType: vendorType,
      showType: showType,
    );
    final page = NavigationService().searchPageWidget(search);
    viewContext.nextPage(page);
  }

  openCart() async {
    //viewContext.nextPage(CartPage());
    await viewContext.push((context) => CartPage());
    CartServices.cartItemStream.add(CartServices.productsInCart);
    //HomeViewModel(viewContext).cartItemListStream.add(CartServices.productsInCart);
  }

  //
  //
  productSelected(Product product) async {
    Navigator.pushNamed(
      viewContext,
      AppRoutes.product,
      arguments: product,
    );
  }

  servicePressed(Service service) async {
    viewContext.push(
          (context) => ServiceDetailsPage(service),
    );
  }

  openVendorReviews() {
    viewContext.push(
          (context) => VendorReviewsPage(vendor),
    );
  }

  //show toast
  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  toastError(String msg, {Toast length}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void fetchCurrentLocation() async {
    //
    Position currentLocation = await Geolocator.getCurrentPosition();
    if (currentLocation == null) {
      currentLocation = await Geolocator.getLastKnownPosition();
    }
    //
    final address = await LocationService.addressFromCoordinates(
      lat: currentLocation?.latitude,
      lng: currentLocation?.longitude,
    );
    //
    LocationService.currenctAddress = address;
    LocationService.currenctAddressSubject.sink.add(address);
    deliveryaddress ??= DeliveryAddress();
    deliveryaddress.address = address?.addressLine;
    deliveryaddress.latitude = address?.coordinates?.latitude;
    deliveryaddress.longitude = address?.coordinates?.longitude;
    deliveryaddress.name = "Current Location".tr();
    LocationService.deliveryaddress = deliveryaddress;
  }

  // NEW LOCATION PICKER
  Future<dynamic> newPlacePicker() async {
    //
    if (!AppMapSettings.useGoogleOnApp) {
      return await viewContext.push(
            (context) => OPSMapPage(
          // apiKey: AppStrings.googleMapApiKey,
          // autocompleteLanguage: I18n.language,
          region: AppStrings.countryCode.trim().split(",").firstWhere(
                (e) => !e.toLowerCase().contains("auto"),
            orElse: () {
              return "";
            },
          ),
          initialPosition: LocationService.currenctAddress != null
              ? LatLng(
            LocationService.currenctAddress?.coordinates?.latitude,
            LocationService.currenctAddress?.coordinates?.longitude,
          )
              : null,
          useCurrentLocation: true,
        ),
      );
    }
    //google maps
    return await Navigator.push(
      viewContext,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: AppStrings.googleMapApiKey,
          autocompleteLanguage: translator.activeLocale.languageCode,
          selectInitialPosition: true,
          region: AppStrings.countryCode.trim().split(",").firstWhere(
                (e) => !e.toLowerCase().contains("auto"),
            orElse: () {
              return "";
            },
          ),
          onPlacePicked: (result) {
            Navigator.of(context).pop(result);
          },
          initialPosition: LocationService.currenctAddress != null
              ? LatLng(
            LocationService.currenctAddress?.coordinates?.latitude,
            LocationService.currenctAddress?.coordinates?.longitude,
          )
              : null,
          useCurrentLocation: true,
        ),
      ),
    );
  }

  //share
  //share
  shareProduct(Product product) async {
    //
    setBusyForObject(shareProduct, true);
    String link = "${Api.appShareLink}/product/${product.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareProduct, false);
  }

  shareVendor(Vendor vendor) async {
    //
    setBusyForObject(shareVendor, true);
    String link = "${Api.appShareLink}/vendor/${vendor.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareVendor, false);
  }

  shareService(Service service) async {
    //
    setBusyForObject(shareService, true);
    String link = "${Api.appShareLink}/service/${service.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareService, false);
  }
}