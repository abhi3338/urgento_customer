import 'package:fuodz/constants/app_strings.dart';
import 'package:supercharged/supercharged.dart';

class AppFileLimit extends AppStrings {
  //prescription file limit
  static int get prescriptionFileLimit {
    if (AppStrings.env('file_limit') != null &&
        AppStrings.env('file_limit')['prescription'] != null &&
        AppStrings.env('file_limit')['prescription']["file_limit"] != null) {
      return AppStrings.env('file_limit')['prescription']["file_limit"]
          .toString()
          .toInt();
    }
    return 2;
  }

  //prescription file size limit
  static int get prescriptionFileSizeLimit {
    if (AppStrings.env('file_limit') != null &&
        AppStrings.env('file_limit')['prescription'] != null &&
        AppStrings.env('file_limit')['prescription']["file_size_limit"] !=
            null) {
      return AppStrings.env('file_limit')['prescription']["file_size_limit"]
          .toString()
          .toInt();
    }
    //return 1mb in kb
    return 1024;
  }
}
