import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/main_search.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/states/loading_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

import 'widget/product_search_result.view.dart';
import 'widget/search_custom.tabbar.dart';
import 'widget/search.header.dart';
import 'widget/service_search_result.view.dart';
import 'widget/vendor_search_result.view.dart';
import 'package:fuodz/utils/utils.dart';


class MainSearchPage extends StatelessWidget {
  const MainSearchPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainSearchViewModel>.reactive(
      viewModelBuilder: () => MainSearchViewModel(context),
      onModelReady: (vm) => vm.fetchSearchTabs(),
      disposeViewModel: false,
      builder: (context, vm, child) {
        return BasePage(
          body: SafeArea(
            bottom: false,
            child: VStack(
              [
                //header
                UiSpacer.verticalSpace(),
                SearchHeader(vm, showCancel: false),
                //tab-
                LoadingIndicator(
                  loading: vm.isBusy,
                  child: ContainedTabBarView(
                    callOnChangeWhileIndexIsChanging: true,
                    tabBarProperties: TabBarProperties(
                      indicatorColor: Utils.textColorByBrightness(context),
                      alignment: TabBarAlignment.start,
                      isScrollable: true,
                      labelPadding: EdgeInsets.all(5),
                    ),
                    tabs: [
                      SearchCustomTabbar(
                        title: "Vendors".tr(),
                        active: vm.selectedIndex == 0,
                        show: vm.showVendors,
                      ),
                      SearchCustomTabbar(
                        title: "Products".tr(),
                        active: vm.selectedIndex == 1,
                        show: vm.showProducts,
                      ),
                      SearchCustomTabbar(
                        title: "Services".tr(),
                        active: vm.selectedIndex == 2,
                        show: vm.showServices,
                      ),
                    ],
                    views: [
                      VendorSearchResultView(vm),
                      ProductSearchResultView(vm),
                      ServiceSearchResultView(vm),
                    ],
                    onChange: vm.onTabChange,
                  ).expand(),
                ),
              ],
            ).px(16),
          ),
        );
      },
    );
  }
}
