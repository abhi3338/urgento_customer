import 'package:flutter/material.dart';

class UpdateService {
  //
  handleAppUpdate(BuildContext context) async {
    // final show = await AppUpgradeSettings.showUpgrade();
    // final force = await AppUpgradeSettings.forceUpgrade();
    // if (show) {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: !force,
    //     builder: (ctx) {
    //       return Dialog(
    //         child: UpgradeAlert(
    //           upgrader: Upgrader(
    //             showIgnore: !force,
    //             shouldPopScope: () => !force,
    //             dialogStyle: Platform.isIOS
    //                 ? UpgradeDialogStyle.cupertino
    //                 : UpgradeDialogStyle.material,
    //           ),
    //           child:
    //               "Checking for Update. Please wait...".tr().text.make().p64(),
    //         ),
    //       );
    //     },
    //   );
    // }
  }
}
