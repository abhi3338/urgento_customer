import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/wallet.dart';
import 'package:fuodz/models/wallet_transaction.dart';
import 'package:fuodz/razor_credentials.dart';
import 'package:fuodz/requests/wallet.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/views/pages/wallet/wallet_transfer.page.dart';
import 'package:fuodz/widgets/bottomsheets/wallet_amount_entry.bottomsheet.dart';
import 'package:fuodz/widgets/finance/wallet_address.bottom_sheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

class WalletViewModel extends PaymentViewModel {
  //
  WalletViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  WalletRequest walletRequest = WalletRequest();
  Wallet wallet;
  RefreshController refreshController = RefreshController();
  List<WalletTransaction> walletTransactions = [];
  int queryPage = 1;
  StreamSubscription<bool> refreshWalletBalanceSub;
  final _razorpay = Razorpay();
  bool isRazorpayLoading = false;

  //
  initialise() async {
    await loadWalletData();

    refreshWalletBalanceSub = AppService().refreshWalletBalance.listen(
      (value) {
        loadWalletData();
      },
    );
  }

  dispose() {
    super.dispose();
    refreshWalletBalanceSub?.cancel();
  }


  //
  loadWalletData() async {
    await getWalletBalance();
    await getWalletTransactions();
  }

  //
  getWalletBalance() async {
    setBusy(true);
    try {
      wallet = await walletRequest.walletBalance();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  getWalletTransactions({bool initialLoading = true}) async {
    //
    if (initialLoading) {
      setBusyForObject(walletTransactions, true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage = queryPage + 1;
    }

    try {
      //
      final mWalletTransactions = await walletRequest.walletTransactions(
        page: queryPage,
      );
      //
      if (initialLoading) {
        walletTransactions = mWalletTransactions;
      } else {
        walletTransactions.addAll(mWalletTransactions);
        refreshController.loadComplete();
      }
      clearErrors();
    } catch (error) {
      print("Wallet transactions error ==> $error");
      setErrorForObject(walletTransactions, error);
    }
    setBusyForObject(walletTransactions, false);
  }

  //
  showAmountEntry() {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return WalletAmountEntryBottomSheet(
          onSubmit: (String amount) {
            viewContext.pop();
            initiateWalletTopUp(amount);
          },
        );
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print(response);
    UpdateWalletBalance(userId: userId,amount: Wallamount,isSuccess: true);
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    UpdateWalletBalance(userId: userId,amount: Wallamount,isSuccess: false);
    _razorpay.clear();
    toastSuccessful(response.message ?? '');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    //response.walletName ?? ''
    toastSuccessful(response.walletName ?? '');
  }

  double finalAmount;

  void createOrder(double amounts) async {
    finalAmount = amounts * 100;
    isRazorpayLoading = true;
    var data = await LocalStorageService.prefs.getString(AppStrings.userKey);
    final userObject = json.decode(data);
    print("data is===>>>${userObject["email"]}");
    print("data is===>>>${userObject["phone"]}");
    print("data is===>>>${userObject['id']}");
    userId = userObject['id'];
    Wallamount = amounts;
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> body = {
      "amount": finalAmount,
      "currency": "INR",
      "receipt": 'fyu'
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      isRazorpayLoading = false;
      openGateway(jsonDecode(res.body)['id'],userObject["phone"],userObject["email"]);
    }else{
      isRazorpayLoading = false;
    }
    print(res.body);
  }

  openGateway(String orderId,String contact,String email) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': finalAmount, //in the smallest currency sub-unit.
      'name': 'Urgento',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'powered by a work connect private limited',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme.color':'#000000'
    };
    _razorpay.open(options);
  }

  //
  initiateWalletTopUp(String amount) async {
    setBusy(true);
    print("here=====");
    try {
      // final link = await walletRequest.walletTopup(amount);
      print("aaaaaaa===>>>>${amount}");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      });
      await createOrder(double.parse(amount));
      // await openWebpageLink(link);
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //Wallet transfer
  showWalletTransferEntry() async {
    final result = await viewContext.push(
      (context) => WalletTransferPage(wallet),
    );

    //
    if (result == null) {
      return;
    }
    //
    getWalletBalance();
    getWalletTransactions();
  }

  showMyWalletAddress() async {
    setBusyForObject(showMyWalletAddress, true);
    final apiResponse = await walletRequest.myWalletAddress();
    //
    if (apiResponse.allGood) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: viewContext,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => WalletAddressBottomSheet(apiResponse),
      );
    } else {
      toastError(apiResponse.message);
    }
    setBusyForObject(showMyWalletAddress, false);
  }
}
