import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/requests/vendor_type.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/coupons.vm.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/notification/notifications.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeHeaderSection extends StatelessWidget {
  const WelcomeHeaderSection(
      this.vm, {
        Key key,
      }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        HStack(
          [

            Row(
              children: [
                Column(
                  children: [


                    Icon(
                      FlutterIcons.location_pin_ent,
                      color: Colors.black,
                      size: 18,
                    ).p8().box

                        .roundedSM
                        .clip(Clip.antiAlias)
                        .color(context.theme.colorScheme.background)
                        .outerShadowSm
                        .make(),
                  ],
                )
              ],
            ),


            UiSpacer.hSpace(5),
            HStack(
              [
                Text(
                    "Deliver To ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    )
                ),
                StreamBuilder(
                  stream: LocationService.currenctAddressSubject,
                  builder: (conxt, snapshot) {
                    return Text(
                      snapshot.hasData
                          ? snapshot.data?.addressLine
                          : "Current Location".tr(),
                      style: TextStyle(
                        fontSize: 14.0, // Adjust the font size as needed
                        fontWeight: FontWeight.w500, // Use FontWeight.bold for bold text
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );

                  },
                ).flexible(),
              ],
            ).flexible(),
            UiSpacer.hSpace(1),

            Icon(
              FlutterIcons.chevron_down_ent,
              size: 20,
            ),
          ],
        ).onTap(
              () async {
            await onLocationSelectorPressed(context);
          },
        ).expand(),
        UiSpacer.hSpace(),
        Icon(
          FlutterIcons.bell_alert_mco,
          color: Colors.black,
          size: 18,
        ).p8().onInkTap(
    () {
    context.nextPage(NotificationsPage());
    },
    ).box

            .roundedSM
            .clip(Clip.antiAlias)
            .color(context.theme.colorScheme.background)
            .outerShadowSm
            .make(),


      ],
    )
        .px20()
        .py16()
        .safeArea()


        .pOnly(bottom: 5)
        .box

        .make();
  }

  Future<void> onLocationSelectorPressed(BuildContext context) async {
    try {
      vm.pickDeliveryAddress(onselected: () {
        vm.pageKey = GlobalKey<State>();
        print("vm.pageKey===>>>>>${vm.pageKey}");
        vm.updateVendorData();

        vm.notifyListeners();
      });
    } catch (error) {
      AlertService.stopLoading();
    }
  }
}