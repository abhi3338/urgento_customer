import 'package:flutter/material.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';

class CheckoutViewModel extends CheckoutBaseViewModel {

  CheckoutViewModel(BuildContext context, CheckOut checkout) {
    this.viewContext = context;
    this.checkout = checkout;
  }

  void onTipSelect(String value) {
    selectedTip = value;
    if (value.toLowerCase() != "custom") {
      driverTipTEC.text = value;
    } else {
      driverTipTEC.clear();
    }
    updateTotalOrderSummary();
    notifyListeners();
  }
}
