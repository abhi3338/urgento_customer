import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_finance_settings.dart';
import 'package:fuodz/models/loyalty_point.dart';
import 'package:fuodz/models/loyalty_point_report.dart';
import 'package:fuodz/requests/loyalty_point.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/views/pages/loyalty/widgets/loyalty_point_withdrawal_entry.bottomsheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class LoyaltyPointViewModel extends PaymentViewModel {
  //
  LoyaltyPointViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  LoyaltyPointRequest loyaltyPointRequest = LoyaltyPointRequest();
  LoyaltyPoint loyaltyPoint;
  double amountRate = 0;
  double estimatedAmount = 0;
  RefreshController refreshController = RefreshController();
  List<LoyaltyPointReport> loyaltyPointReports = [];
  int queryPage = 1;

  //
  initialise() async {
    await loadData();
  }

  //
  loadData() async {
    await getLoyaltyPoint();
    await getReport();
  }

  //
  getLoyaltyPoint() async {
    setBusy(true);
    try {
      loyaltyPoint = await loyaltyPointRequest.getLoyaltyPoint();
      calculateExchangeRates();
      clearErrors();
    } catch (error) {
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  calculateExchangeRates() {
    estimatedAmount = loyaltyPoint.points *
        (double.parse(AppFinanceSettings.loyaltyPointsToAmount) ?? 0);
    notifyListeners();
  }

  getReport({bool initialLoading = true}) async {
    //
    if (initialLoading) {
      setBusyForObject(loyaltyPointReports, true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage = queryPage + 1;
    }

    try {
      //
      final mLoyaltyPointReports =
          await loyaltyPointRequest.loyaltyPointReports(
        page: queryPage,
      );
      //
      if (initialLoading) {
        loyaltyPointReports = mLoyaltyPointReports;
      } else {
        loyaltyPointReports.addAll(mLoyaltyPointReports);
        refreshController.loadComplete();
      }
      clearErrors();
    } catch (error) {
      print("Loyalty Point report error ==> $error");
      setErrorForObject(loyaltyPointReports, error);
    }
    setBusyForObject(loyaltyPointReports, false);
  }

  //
  showAmountEntry() {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return LoyaltyPointWithdrawalEntryBottomSheet(
          onSubmit: (String points) {
            viewContext.pop();
            initiatePointsWithdrawal(points);
          },
        );
      },
    );
  }

  //
  initiatePointsWithdrawal(String points) async {
    setBusyForObject(loyaltyPoint, true);
    try {
      final apiResponse = await loyaltyPointRequest.withdrawPoints(points);
      if (apiResponse.allGood) {
        loadData();
        AlertService.success(
          title: "Loyalty Points".tr(),
          text: apiResponse.message,
        );
      } else {
        AlertService.error(
          title: "Loyalty Points".tr(),
          text: apiResponse.message,
        );
      }
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(loyaltyPoint, false);
  }
}
