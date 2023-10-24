import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/list_items/plain_vendor_type.vertical_list_item.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/modern_vendor_type.vertical_list_item.dart';

import 'plain_welcome_header.section.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';

class PlainEmptyWelcome extends StatefulWidget {
  const PlainEmptyWelcome({this.vm, Key key}) : super(key: key);

  final WelcomeViewModel vm;

  @override
  State<PlainEmptyWelcome> createState() => _PlainEmptyWelcomeState();
}

class _PlainEmptyWelcomeState extends State<PlainEmptyWelcome> {
  double headerHeight = 200;
  //
  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        //
        MeasureSize(
          onChange: (size) {
            setState(() {
              headerHeight = size.height;
              if (headerHeight > 100) {
                headerHeight -= 130;
              }
            });

            print("UI H: ${size.height}");
          },
          child: PlainWelcomeHeaderSection(widget.vm),
        ),
        //UiSpacer.vSpace(),

        VStack(
          [
            //gridview
            CustomVisibilty(
              visible: HomeScreenConfig.isVendorTypeListingGridView &&
                  widget.vm.showGrid &&
                  widget.vm.isBusy,
              child: LoadingShimmer().px20().centered(),

            ),
            CustomVisibilty(
              visible: HomeScreenConfig.isVendorTypeListingGridView &&
                  widget.vm.showGrid &&
                  !widget.vm.isBusy,
              child: AnimationLimiter(
                child: MasonryGrid(
                  column: HomeScreenConfig.vendorTypePerRow ?? 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: List.generate(
                    widget.vm.vendorTypes.length ?? 0,
                        (index) {
                      final vendorType = widget.vm.vendorTypes[index];
                      return ModernVendorTypeVerticalListItem(
                        vendorType,
                        onPressed: () {
                          NavigationService.pageSelected(
                            vendorType,
                            context: context,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ).p20(),
        //
        VStack(
          [
            //

            SectionCouponsView(
              null,
              title: "Coupons for you".tr(),
              scrollDirection: Axis.horizontal,
              itemWidth: context.percentWidth * 70,
              height: 100,
              itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              bPadding: 10,
              loadingWidget: const SizedBox.shrink(),
            ),
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
              scrollDirection: Axis.horizontal,
              type: SearchFilterType.featured,
              itemWidth: context.percentWidth * 48,
              byLocation: AppStrings.enableFatchByLocation,
              loadingWidget: const SizedBox.shrink(),
            ),
            //spacing
            UiSpacer.vSpace(100),
          ],
        ).pOnly(top: headerHeight),
      ],
    ).scrollVertical();
  }
}