import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/requests/payment_method.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyUploadPrescriptionViewModel extends CheckoutBaseViewModel {
  //
  PharmacyUploadPrescriptionViewModel(BuildContext context, this.vendor) {
    this.viewContext = context;
    this.checkout = CheckOut(subTotal: 0.00);
    this.canSelectPaymentOption = true;
  }

  //
  VendorRequest vendorRequest = VendorRequest();
  Vendor vendor;
  final picker = ImagePicker();
  File prescriptionPhoto;

  void initialise() async {
    calculateTotal = false;
    fetchVendorDetails();
    super.initialise();
  }

  //
  fetchVendorDetails() async {
    //
    setBusyForObject(vendor, true);
    try {
      vendor = await vendorRequest.vendorDetails(vendor.id);
    } catch (error) {
      print("Error ==> $error");
    }
    setBusyForObject(vendor, false);
  }

  //
  void changePhoto({@required ImageSource imageSource}) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      prescriptionPhoto = File(pickedFile.path);
    } else {
      prescriptionPhoto = null;
    }

    notifyListeners();
  }

  //
  //

  int orderId;
  processOrderPlacement() async {
    setBusy(true);
    //set the total with discount as the new total
    checkout.total = checkout.totalWithTip;

    PaymentMethodRequest paymentMethodRequest = new PaymentMethodRequest();
    var paymentMethodList = await paymentMethodRequest.getPaymentOptions(vendorId: vendor.id);
    var temporaryData = paymentMethodList.where((element) => element.id == 4 && element.name.toLowerCase() == "pay online").toList();
    //var temporaryData = paymentMethodList.where((element) => element.id == 4 && element.name.toLowerCase() == "pay online")).toList();
    //
    final apiResponse = await checkoutRequest.newPrescriptionOrder(
        checkout,
        vendor,
        photo: prescriptionPhoto,
        note: noteTEC.text,
        payment_method_id: temporaryData.isNotEmpty ? temporaryData.first.id : 0,
        status: "review"
    );
    //not error
    if (apiResponse.allGood) {
      //cash payment

      final paymentLink = "";
      orderId = apiResponse.body["orderId"];
      // apiResponse.body["link"].toString();
      if (!paymentLink.isEmptyOrNull) {
        viewContext.pop();
        showOrdersTab(context: viewContext);
        openWebpageLink(paymentLink);
      }
      //cash payment
      else {
        CoolAlert.show(
            context: viewContext,
            type: CoolAlertType.success,
            title: "Checkout".tr(),
            text: apiResponse.message,
            barrierDismissible: false,
            onConfirmBtnTap: () {
              viewContext.pop();
              if (viewContext.navigator.canPop()) {
                viewContext.navigator.popUntil(
                      (route) {
                    return route == AppRoutes.homeRoute || route.isFirst;
                  },
                );
              }
              viewContext.navigator.pushNamed(
                AppRoutes.orderDetailsRoute,
                arguments: new Order(id: orderId),
              );
              // showOrdersTab(context: viewContext);
              // if (viewContext.navigator.canPop()) {
              //   viewContext.pop();
              // }
            });
      }
    } else {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Checkout".tr(),
        text: apiResponse.message,
      );
    }
    setBusy(false);
  }
}