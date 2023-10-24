import 'package:fuodz/constants/app_strings.dart';

class AppTaxiSettings extends AppStrings {
  static bool get requiredBookingCode {
    if (AppStrings.env('taxi') == null ||
        AppStrings.env('taxi')["requestBookingCode"] == null) {
      return false;
    }
    return true;
  }

  static bool get requiredBookingCodeBeforeTrip {
    if (AppStrings.env('taxi') == null ||
        AppStrings.env('taxi')["requestBookingCode"] == null) {
      return false;
    }
    return ["both", "before"]
        .contains(AppStrings.env('taxi')["requestBookingCode"]);
  }

  static bool get requiredBookingCodeAfterTrip {
    if (AppStrings.env('taxi') == null ||
        AppStrings.env('taxi')["requestBookingCode"] == null) {
      return false;
    }
    return ["both", "after"]
        .contains(AppStrings.env('taxi')["requestBookingCode"]);
  }
}
