import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/welcome_intro.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/finance/wallet_management.view.dart';
import 'package:fuodz/widgets/list_items/vendor_type.list_item.dart';
import 'package:fuodz/widgets/list_items/vendor_type.vertical_list_item.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:fuodz/services/app.service.dart';

class EmptyWelcome extends StatelessWidget {
  const EmptyWelcome({this.vm, Key key}) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        SafeArea(
          child: WelcomeIntroView(),
        ),

        //
        VStack(
          [
            UiSpacer.vSpace(),
            SearchBarInput(
              onTap: () {
                AppService().homePageIndex.add(2);
              },
            ),
            UiSpacer.vSpace(5),
            //finance section
            CustomVisibilty(
              visible: HomeScreenConfig.showWalletOnHomeScreen ?? true,
              child: WalletManagementView().px20().py16(),
            ),
            //
            //top banner
            CustomVisibilty(
              visible: HomeScreenConfig.showBannerOnHomeScreen &&
                  HomeScreenConfig.isBannerPositionTop,
              child: VStack(
                [
                  Banners(
                    null,
                    featured: true,
                  ).py12(),
                ],
              ),
            ),
            //

            SectionCouponsView(
              null,
              title: "Promo".tr(),
              scrollDirection: Axis.horizontal,
              itemWidth: context.percentWidth * 70,
              height: 100,
              itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              bPadding: 10,
            ),

            VStack(
              [
                HStack(
                  [
                    "I want to:".tr().text.xl.medium.make().expand(),
                    CustomVisibilty(
                      visible: HomeScreenConfig.isVendorTypeListingBoth,
                      child: Icon(
                        vm.showGrid
                            ? FlutterIcons.grid_fea
                            : FlutterIcons.list_fea,
                      ).p2().onInkTap(
                            () {
                          vm.showGrid = !vm.showGrid;
                          vm.notifyListeners();
                        },
                      ),
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
                UiSpacer.vSpace(12),
                //list view
                CustomVisibilty(
                  visible: (HomeScreenConfig.isVendorTypeListingBoth &&
                      !vm.showGrid) ||
                      (!HomeScreenConfig.isVendorTypeListingBoth &&
                          HomeScreenConfig.isVendorTypeListingListView),
                  child: CustomListView(
                    noScrollPhysics: true,
                    dataSet: vm.vendorTypes,
                    isLoading: vm.isBusy,
                    loadingWidget: LoadingShimmer().px20(),
                    itemBuilder: (context, index) {
                      final vendorType = vm.vendorTypes[index];
                      return VendorTypeListItem(
                        vendorType,
                        onPressed: () {
                          NavigationService.pageSelected(vendorType,
                              context: context);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => UiSpacer.emptySpace(),
                  ),
                ),
                //gridview
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      vm.isBusy,
                  child: LoadingShimmer().px20().centered(),
                ),
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      !vm.isBusy,
                  child: AnimationLimiter(
                    child: MasonryGrid(
                      column: HomeScreenConfig.vendorTypePerRow ?? 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(
                        vm.vendorTypes.length ?? 0,
                            (index) {
                          final vendorType = vm.vendorTypes[index];
                          return VendorTypeVerticalListItem(
                            vendorType,
                            onPressed: () {
                              NavigationService.pageSelected(vendorType, context: context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ).p20(),

            //botton banner
            CustomVisibilty(
              visible: HomeScreenConfig.showBannerOnHomeScreen &&
                  !HomeScreenConfig.isBannerPositionTop,
              child: Banners(
                null,
                featured: true,
              ).py12().pOnly(bottom: context.percentHeight * 10),
            ),


            //featured vendors
            SectionVendorsView(
              null,
              title: "Featured Vendors".tr(),
              titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemsPadding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              type: SearchFilterType.featured,
              itemWidth: context.percentWidth * 48,
              byLocation: AppStrings.enableFatchByLocation,
            ),
            //spacing
            UiSpacer.vSpace(100),
          ],
        //).box.color(context.backgroundColor).topRounded(value: 30).make(),
        ).box.white.topRounded(value: 30).make(),
      ],
    ).box.color(AppColor.primaryColor).make().scrollVertical();
  }
}