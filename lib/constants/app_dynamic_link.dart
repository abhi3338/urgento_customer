import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:package_info/package_info.dart';

class AppDynamicLink extends AppStrings {
  static String get dynamicLinkPrefix {
    if (AppStrings.env('dynamic_link') == null) {
      return Api.baseUrl;
    }
    return AppStrings.env('dynamic_link')["prefix"].toString() ?? Api.baseUrl;
  }

  static Future<String> get androidDynamicLinkId async {
    if (AppStrings.env('dynamic_link') == null) {
      final platformInfo = await PackageInfo.fromPlatform();
      return platformInfo.packageName;
    }
    return AppStrings.env('dynamic_link')["android"].toString();
  }

  static Future<String> get iOSDynamicLinkId async {
    if (AppStrings.env('dynamic_link') == null) {
      final platformInfo = await PackageInfo.fromPlatform();
      return platformInfo.packageName;
    }
    return AppStrings.env('dynamic_link')["ios"].toString();
  }
}
