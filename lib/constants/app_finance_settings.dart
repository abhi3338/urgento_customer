import 'package:fuodz/constants/app_strings.dart';

class AppFinanceSettings extends AppStrings {
  static bool get collectDeliveryFeeInCash {
    try {
      final allowCashDeliveryFee =
          AppStrings.env('finance')["delivery"]["collectDeliveryCash"];
      if (allowCashDeliveryFee == "1" || allowCashDeliveryFee == 1) {
        return true;
      }
    } catch (error) {}

    return false;
  }

  static bool get enableLoyalty {
    try {
      final allow = AppStrings.env('finance')["enableLoyalty"];
      if (allow == "1" || allow == 1 || allow) {
        return true;
      }
    } catch (error) {}

    return false;
  }

  static String get loyaltyPointsToAmount {
    try {
      return AppStrings.env('finance')["point_to_amount"];
    } catch (error) {}

    return "0.001";
  }

  static String get amountToLoyaltyPoints {
    try {
      return AppStrings.env('finance')["amount_to_point"];
    } catch (error) {}

    return "0.001";
  }
}
