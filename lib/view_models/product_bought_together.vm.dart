import 'package:flutter/material.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:dartx/dartx.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductBoughtTogetherViewModel extends MyBaseViewModel {
  //
  ProductBoughtTogetherViewModel(BuildContext context, this.product) {
    this.viewContext = context;
  }

  //
  ProductRequest productRequest = ProductRequest();

  Product product;
  List<Product> products = [];
  List<Product> selectedProducts = [];
  double totalSellPrice = 0.0;
  bool expanded = false;

  @override
  void initialise() async {
    super.initialise();
    getProductBoughtTogether();
  }

  //
  void getProductBoughtTogether() async {
    //
    setBusy(true);

    try {
      final mProducts = await productRequest.productsBoughtTogether(
        queryParams: {
          "id": product.id,
        },
      );

      products = mProducts;
      selectedProducts = List.from(mProducts);

      calTotal();
    } catch (error) {
      setError(error);
      print("load more error ==> $error");
    }
    setBusy(false);
  }

  calTotal() {
    //
    totalSellPrice = 0.0;
    totalSellPrice = selectedProducts.sumBy((e) => e.sellPrice);
    notifyListeners();
  }

  toggleExpanded() {
    expanded = !expanded;
    notifyListeners();
  }

  bool isProductSelected(product) {
    return selectedProducts.firstWhere((e) => e.id == product.id,
            orElse: () => null) !=
        null;
  }

  void updateSelectedProducts(int index, bool add) {
    if (add) {
      selectedProducts.add(products[index]);
    } else {
      selectedProducts.removeWhere((e) => e.id == products[index].id);
    }
    calTotal();
  }

  addFrequentBoughtToCart() async {
    setBusyForObject(selectedProducts, true);
    try {
      for (var selectedProduct in selectedProducts) {
        selectedProduct.selectedQty = 1;
        await addToCartDirectly(selectedProduct, 1);
        toastSuccessful("Product(s) added to cart".tr());
      }
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(selectedProducts, false);
  }
}
