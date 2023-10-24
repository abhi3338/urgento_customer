import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/models/wallet.dart';
import 'package:fuodz/requests/wallet.request.dart';
import 'package:fuodz/traits/qrcode_scanner.trait.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletTransferViewModel extends PaymentViewModel with QrcodeScannerTrait {
  //
  WalletTransferViewModel(BuildContext context, this.wallet) {
    this.viewContext = context;
  }

  //
  WalletRequest walletRequest = WalletRequest();
  Wallet wallet;
  User selectedUser;
  TextEditingController amountTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  //
  Future<List<User>> searchUsers(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    //
    ApiResponse apiResponse = await walletRequest.getWalletAddress(keyword);
    if (apiResponse.allGood) {
      //
      return (apiResponse.body["users"] as List)
          .map((e) => User.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  void userSelected(suggestion) {
    selectedUser = suggestion;
    notifyListeners();
  }

  scanWalletAddress() async {
    final walletCode = await openScanner(viewContext);
    if (walletCode == null) {
      toastError("Operation failed/cancelled".tr());
    } else {
      selectedUser = User.fromJson(jsonDecode(walletCode));
      notifyListeners();
    }
  }

  //
  initiateWalletTransfer() async {
    //
    if (formKey.currentState.validate() && selectedUser != null) {
      setBusy(true);
      try {
        //
        ApiResponse apiResponse = await walletRequest.transferWallet(
          amountTEC.text,
          selectedUser.walletAddress,
          passwordTEC.text,
        );
        //
        if (apiResponse.allGood) {
          toastSuccessful(apiResponse.message);
          viewContext.pop(true);
        } else {
          toastError(apiResponse.message);
        }
      } catch (error) {
        toastError("$error");
      }
      setBusy(false);
    } else if (selectedUser == null) {
      toastError("Please select reciepent".tr());
    }
  }
}
