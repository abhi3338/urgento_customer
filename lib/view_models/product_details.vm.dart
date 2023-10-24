import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/option.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/requests/favourite.request.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/cart_ui.service.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/cart/cart.page.dart';
import 'package:fuodz/views/pages/vendor_details/vendor_details.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/html_text_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/utils/utils.dart';


class ProductDetailsViewModel extends MyBaseViewModel {
  //
  ProductDetailsViewModel(BuildContext context, this.product) {
    this.viewContext = context;
    //updatedSelectedQty(1);
  }

  //view related
  final productReviewsKey = new GlobalKey();
  //
  ProductRequest _productRequest = ProductRequest();
  FavouriteRequest _favouriteRequest = FavouriteRequest();

  //
  Product product;
  List<Option> selectedProductOptions = [];
  List<int> selectedProductOptionsIDs = [];
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;

  //
  void getProductDetails() async {
    //
    setBusyForObject(product, true);

    try {
      final oldProductHeroTag = product.heroTag;
      product = await _productRequest.productDetails(product.id);
      int selectedProductIndex = CartServices.productsInCart.indexWhere((element) => element.product.id == product.id);
      if (selectedProductIndex != -1) {
        product.selectedQty = CartServices.productsInCart[selectedProductIndex].selectedQty;
      }
      product.heroTag = oldProductHeroTag;
      CartServices.cartItemStream.add(CartServices.productsInCart);

      clearErrors();
      calculateTotal();
    } catch (error) {
      setError(error);
      toastError("$error");
    }
    setBusyForObject(product, false);
    notifyListeners();
  }

  openVendorDetails() {
    viewContext.nextPage(
      VendorDetailsPage(
        vendor: product.vendor,
      ),
    );
  }

  //
  isOptionSelected(Option option) {
    return selectedProductOptionsIDs.contains(option.id);
  }

  //
  toggleOptionSelection(OptionGroup optionGroup, Option option) {
    //
    if (selectedProductOptionsIDs.contains(option.id)) {
      selectedProductOptionsIDs.remove(option.id);
      selectedProductOptions.remove(option);
    } else {
      //if it allows only one selection
      if (optionGroup.multiple == 0) {
        //
        final foundOption = selectedProductOptions.firstWhere(
                (option) => option.optionGroupId == optionGroup.id,
            orElse: () => null);
        if (foundOption != null) {
          selectedProductOptionsIDs.remove(foundOption.id);
          selectedProductOptions.remove(foundOption);
        }
      }

      selectedProductOptionsIDs.add(option.id);
      selectedProductOptions.add(option);
    }

    //
    calculateTotal();
  }

  //
  updatedSelectedQty(int qty) async {
    product.selectedQty = qty;
    calculateTotal();
  }

  //
  calculateTotal() {
    //
    double productPrice =
    !product.showDiscount ? product.price : product.discountPrice;

    //
    double totalOptionPrice = 0.0;
    selectedProductOptions.forEach((option) {
      totalOptionPrice += option.price;
    });

    //
    if (product.plusOption == 1 || selectedProductOptions.isEmpty) {
      subTotal = productPrice + totalOptionPrice;
    } else {
      subTotal = totalOptionPrice;
    }
    total = subTotal * (product.selectedQty ?? 1);
    notifyListeners();
  }

  //
  addToFavourite() async {
    //
    setBusy(true);

    try {
      //
      final apiResponse = await _favouriteRequest.makeFavourite(product.id);
      if (apiResponse.allGood) {
        //
        product.isFavourite = true;

        //
        AlertService.success(text: apiResponse.message);
      } else {
        viewContext.showToast(
          msg: apiResponse.message,
          bgColor: Colors.red,
          textColor: Colors.white,
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  removeFromFavourite() async {
    //
    setBusy(true);

    try {
      //
      final apiResponse = await _favouriteRequest.removeFavourite(product.id);
      if (apiResponse.allGood) {
        //
        product.isFavourite = false;
        //
        AlertService.success(text: apiResponse.message);
      } else {
        viewContext.showToast(
          msg: apiResponse.message,
          bgColor: Colors.red,
          textColor: Colors.white,
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //check if the option groups with required setting has an option selected
  optionGroupRequirementCheck() {
    //check if the option groups with required setting has an option selected
    bool optionGroupRequiredFail = false;
    OptionGroup optionGroupRequired;
    //
    for (var optionGroup in product.optionGroups) {
      //
      optionGroupRequired = optionGroup;
      //
      final selectedOptionInOptionGroup = selectedProductOptions.firstWhere(
            (e) => e.optionGroupId == optionGroup.id,
        orElse: () => null,
      );

      //check if there is an option group that is required but customer is yet to select an option
      if (optionGroup.required == 1 && selectedOptionInOptionGroup == null) {
        optionGroupRequiredFail = true;
        break;
      }
    }

    //
    if (optionGroupRequiredFail) {
      //
      CoolAlert.show(
        context: viewContext,
        title: "addon required".tr(),
        text: "You are required to select at least one addon of".tr() +
            " ${optionGroupRequired.name}",
        type: CoolAlertType.error,
      );

      throw "Option required".tr();
    }
  }

  //
  Future<bool> addToCart({bool force = false, bool skip = false}) async {

    if (product.optionGroups.isNotEmpty) {
      var tempCartData = CartServices.productsInCart;
      product.optionGroups.forEach((element) {
        for (int i = 0; i < element.options.length; i++) {
          int existsInCart = tempCartData.indexWhere((innerElement) => innerElement.optionsIds.contains(element.options[i].id));
          if (existsInCart != -1) {
            toggleOptionSelection(element, element.options[i]);
          }
        }
      });
      bool valueData = await openProductAddOnSheet();
      if (valueData == null) return false;
    }
    //
    final cart = Cart();
    cart.price = subTotal;
    cart.product = product;
    cart.product.selectedQty = product.selectedQty ?? 1;
    cart.selectedQty = product.selectedQty ?? 1;
    cart.options = selectedProductOptions;
    cart.optionsIds = selectedProductOptionsIDs;
    bool done = false;
    //

    try {
      //check if the option groups with required setting has an option selected
      optionGroupRequirementCheck();
      //
      setBusy(true);
      bool canAddToCart = await CartUIServices.handleCartEntry(
        viewContext,
        cart,
        product,
      );

      if (canAddToCart || force) {
        //
        await CartServices.addToCart(cart);
        //
        if (!skip) {
          done = await CoolAlert.show(
            context: viewContext,
            title: "Add to cart".tr(),
            text: "%s Added to cart".tr().fill([product.name]),
            type: CoolAlertType.success,
            showCancelBtn: true,
            confirmBtnColor: AppColor.primaryColor,
            confirmBtnText: "GO TO CART".tr(),
            confirmBtnTextStyle: viewContext.textTheme.bodyLarge.copyWith(
              fontSize: Vx.dp12,
              color: Colors.white,
            ),
            onConfirmBtnTap: () async {
              //
              viewContext.pop(true);
              viewContext.nextPage(CartPage());
            },
            cancelBtnText: "Keep Shopping".tr(),
            cancelBtnTextStyle:
            viewContext.textTheme.bodyLarge.copyWith(fontSize: Vx.dp12),
          );
        }
      } else if (product.isDigital) {
        //
        CoolAlert.show(
          context: viewContext,
          title: "Digital Product".tr(),
          text:
          "You can only buy/purchase digital products together with other digital products. Do you want to clear cart and add this product?"
              .tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            //
            viewContext.pop();
            await CartServices.clearCart();
            addToCart(force: true);
          },
        );
      } else {
        //
        done = await CoolAlert.show(
          context: viewContext,
          title: "Replace items already in cart?".tr(),
          text:
          "Your cart contains items from other store. Do you want to discard the selection and add items from this store?."
              .tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            //
            viewContext.pop();
            await CartServices.clearCart();
            addToCart(force: true);
          },
        );
      }
    } catch (error) {
      print("Cart Error => $error");
      setError(error);
    }
    setBusy(false);
    return done;
  }

  //
  void openVendorPage() {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: product.vendor,
    );
  }

  buyNow() async {
    try {
      //check if the option groups with required setting has an option selected
      optionGroupRequirementCheck();
      await addToCart(skip: true);
      viewContext.pop();
      viewContext.nextPage(CartPage());
    } catch (error) {
      toastError("$error");
    }
  }

  Future openProductAddOnSheet() {
    return showModalBottomSheet(
      context: viewContext,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0)
      ),
      backgroundColor: Colors.white,
      enableDrag: false,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        final currencySymbol = AppStrings.currencySymbol;
        return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                child: VStack([

                  HStack([

                    CustomImage(
                      imageUrl: product.photo,
                      width: 80.0,
                      height: 80.0,
                    )
                        .card
                        .clip(Clip.antiAlias)
                        .roundedSM
                        .make(),

                    SizedBox().w(12.0),

                    VStack([

                      product.name.text.color(Color(0xFF181725)).semiBold.maxFontSize(18.0).minFontSize(18.0).make(),

                      SizedBox().h(8.0),

                      CurrencyHStack([

                        currencySymbol.text.color(Color(0xFF181725)).lg.bold.make(),

                        (product.showDiscount ? product.discountPrice.currencyValueFormat() : product.price.currencyValueFormat())
                            .text.color(Color(0xFF181725)).minFontSize(18.0).semiBold.make(),

                      ]),
                    ],
                      axisSize: MainAxisSize.min,
                      crossAlignment: CrossAxisAlignment.start,
                    ).expand()

                  ], axisSize: MainAxisSize.max,),

                  const SizedBox().h(12.0),

                  "Description".tr().text.minFontSize(16.0).maxFontSize(16.0).bold.make(),

                  const SizedBox().h(4.0),

                  HtmlTextView(product.description),

                  const SizedBox().h(12.0),

                  VStack(product.optionGroups.map((e) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        e.name.text.color(Color(0xFF181725)).semiBold.maxFontSize(14.0).minFontSize(14.0).make(),

                        //const SizedBox().h(4.0),

                        // "You need to select minimum 1 options".text.minFontSize(14.0).color(Colors.black45).fontWeight(FontWeight.w600).make(),

                        const SizedBox().h(12.0),

                        CustomListView(
                          dataSet: e.options,
                          itemBuilder: (p0, p1) {
                            var selectedOption;
                            if (selectedProductOptions != null && selectedProductOptions.isNotEmpty) {
                              int temporaryIndex = selectedProductOptions.indexWhere((element) => element.id == e.options[p1].id);
                              if (temporaryIndex != -1) {
                                selectedOption = selectedProductOptions[temporaryIndex];
                              }
                            }
                            return HStack([

                              if (e.multiple == 0)
                                Radio<Option>(
                                  activeColor: AppColor.primaryColor,
                                  autofocus: true,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  value: e.options[p1],
                                  onChanged: (Option value) {
                                    toggleOptionSelection(e, value);
                                    setState(() {});
                                  },
                                  groupValue: selectedOption,
                                )
                                    .w(60.0)
                              else
                                Checkbox(
                                  activeColor: AppColor.primaryColor,
                                  autofocus: true,
                                  checkColor: Colors.white,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (bool value) {
                                    toggleOptionSelection(e, e.options[p1]);
                                    setState(() {});
                                  },
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)
                                  ),
                                  value: isOptionSelected(e.options[p1]),
                                ).w(60.0),


                              e.options[p1].name.text.semiBold.minFontSize(14.0).maxLines(2).make().expand(),

                              const SizedBox().h(8.0),

                              CurrencyHStack([
                                "+ ".text.lg.bold.make(),

                                currencySymbol.text.lg.bold.make(),

                                e.options[p1].price.currencyValueFormat().text.minFontSize(14.0).semiBold.make(),

                              ]),

                            ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.center,)
                                .onInkTap(() {
                              toggleOptionSelection(e, e.options[p1]);
                              setState(() {});
                            });
                          },
                        ),
                      ],
                    );
                  }).toList()),

                  const SizedBox().h(12.0),

                  HStack([

                    "Quantity".tr().text.xl.medium.make().expand(),

                    VxStepper(
                      defaultValue: product.selectedQty ?? 1,
                      min: 1,
                      max: (product.availableQty != null && product.availableQty > 0) ? product.availableQty : 20,
                      disableInput: true,
                      onChange: (int value) {
                        updatedSelectedQty(value);
                        setState(() {});
                      },
                    ),

                  ], alignment: MainAxisAlignment.spaceBetween,),

                  const SizedBox().h(12.0),

                  CustomButton(
                    loading: isBusy,
                    height: 50.0,
                    child: HStack([

                      "Order Now ".tr().text.white.medium.make(),

                      CurrencyHStack([
                        currencySymbol.text.white.lg.make(),
                        total
                            .currencyValueFormat()
                            .text
                            .white
                            .letterSpacing(1.5)
                            .xl
                            .semiBold
                            .make(),
                      ]),

                    ])
                        .p12(),
                    onPressed: () => viewContext.pop(true),
                  ).wFull(context),

                ], axisSize: MainAxisSize.min, crossAlignment: CrossAxisAlignment.start),
              );
            }
        );
      },
    );
  }
}
