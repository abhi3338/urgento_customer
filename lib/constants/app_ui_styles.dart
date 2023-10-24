import 'package:fuodz/constants/app_strings.dart';
import 'package:supercharged/supercharged.dart';

class AppUIStyles extends AppStrings {
  //
  static int themeUIStyle() {
    dynamic uiEnv = AppStrings.env("ui");
    if (uiEnv == null ||
        uiEnv["home"] == null ||
        uiEnv['home']["homeViewStyle"] == null) {
      return 1;
    }
    return (uiEnv['home']["homeViewStyle"].toString().toInt()) ?? 1;
  }

  static bool get isModern => themeUIStyle() == 2;
  static bool get isOriginal => [1, null].contains(themeUIStyle());
  
}
