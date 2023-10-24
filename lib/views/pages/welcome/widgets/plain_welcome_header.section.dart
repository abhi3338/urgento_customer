import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/finance/plain_wallet_management.view.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/cards/welcome_intro.view.dart';

class PlainWelcomeHeaderSection extends StatelessWidget {

  const PlainWelcomeHeaderSection(this.vm, {Key key,}) : super(key: key);

  final WelcomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack([

      VStack([

        HStack([

          HStack([

            Icon(
              FlutterIcons.location_pin_ent,
              size: 24,
              color: Utils.textColorByTheme(),
            ),

            UiSpacer.hSpace(5),

            VStack([
              "Deliver To".tr().text.thin.light.color(Utils.textColorByTheme()).sm.make(),

              StreamBuilder(
                stream: LocationService.currenctAddressSubject,
                builder: (context, snapshot) {
                  return (snapshot.hasData
                      ? "${snapshot.data?.addressLine}"
                      : "Current Location".tr())
                      .text.color(Utils.textColorByTheme()).medium.maxLines(1).ellipsis.make();
                },
              ).flexible(),

            ]).flexible(),

            UiSpacer.hSpace(5),

            Icon(
              FlutterIcons.chevron_down_ent,
              size: 20,
              color: Utils.textColorByTheme(),
            ),

          ]).expand(),

          UiSpacer.hSpace(),

          StreamBuilder<dynamic>(
            stream: AuthServices.listenToAuthState(),
            initialData: false,
            builder: (ctx, snapshot) {
              if (snapshot.hasData && snapshot.data is bool && snapshot.data) {
                return CustomImage(
                  imageUrl: AuthServices.currentUser?.photo,
                )
                    .wh(35, 35)
                    .box
                    .roundedFull
                    .clip(Clip.antiAlias)
                    .make()
                    .onInkTap(
                        () => AppService().homePageIndex.add(3));
              } else {
                return UiSpacer.emptySpace();
              }
            },
          ),

        ]).onTap(() async => await onLocationSelectorPressed()),

        SafeArea(child: WelcomeIntroView()),

        UiSpacer.vSpace(),

        SearchBarInput(
          onTap: () => AppService().homePageIndex.add(2),
        ),

        UiSpacer.vSpace(5),

      ])
          .p12()
          .box
          .bottomRounded(value: 25)
          .color(AppColor.primaryColor)
          .make(),

      CustomVisibilty(
        visible: HomeScreenConfig.showBannerOnHomeScreen && HomeScreenConfig.isBannerPositionTop,
        child: VStack([
          Banners(null, featured: true,).py12(),
        ]),
      ),

      //wallet UI for login user
      //finance section
      StreamBuilder<dynamic>(
        stream: AuthServices.listenToAuthState(),
        initialData: false,
        builder: (ctx, snapshot) {
          if (snapshot.hasData && snapshot.data is bool && snapshot.data) {
            return CustomVisibilty(
              visible: HomeScreenConfig.showWalletOnHomeScreen ?? true,
              child: PlainWalletManagementView().py(15),
            );
          } else {
            return UiSpacer.emptySpace();
          }
        },
      ),


      UiSpacer.vSpace(120),

    ])
        .wFull(context)
        .safeArea();
  }

  Future<void> onLocationSelectorPressed() async {
    try {
      vm.pickDeliveryAddress(onselected: () {
        vm.pageKey = GlobalKey<State>();
        vm.notifyListeners();
      });
    } catch (error) {
      AlertService.stopLoading();
    }
  }
}