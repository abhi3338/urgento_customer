import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/service.vm.dart';
import 'package:fuodz/views/pages/service/widgets/popular_services.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/complex_header.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/simple_styled_banners.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/states/alternative.view.dart';
import 'package:fuodz/widgets/vendor_type_categories.view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../vendor/widgets/banners.view.dart';
import 'widgets/services_by_id.view.dart';
import 'widgets/top_service_vendors.view.dart';
import 'package:fuodz/utils/utils.dart';

class ServicePage extends StatefulWidget {
  const ServicePage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with AutomaticKeepAliveClientMixin<ServicePage> {
  GlobalKey pageKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    final mBannerHeight =
        (AppStrings.bannerHeight < (context.percentHeight * 35)
            ? context.percentHeight * 35
            : AppStrings.bannerHeight);

    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(context, widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Container(
          child: BasePage(
            showAppBar: false,
            showLeadingAction: !AppStrings.isSingleVendorMode,
            elevation: 0,
            showLogo: true,
            title: "${widget.vendorType.name}",
            appBarItemColor: Utils.textColorByBrightness(context),
            showCart: false,
            key: model.pageKey,
            body: SmartRefresher(
              controller: model.refreshController,
              onRefresh: model.reloadPage,
              child: VStack(
                [
                  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        width: context.screenWidth,
                        child:  Image.network(
                            'https://superappadmin.aworkconnect.in/imghost/servicebg.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container();
                            },
                          ),

                      ),
                      Column(
                        children: [
                          UiSpacer.verticalSpace(space: 40),



                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ComplexVendorHeader(
                                model: model,
                                searchShowType: 5,
                                onrefresh: model.reloadPage,
                              ),
                          ),



                          UiSpacer.verticalSpace(space: 220),
                          Banners(
                            widget.vendorType,
                            itemRadius: 25,
                          ).px20(),
                          // Top widgets
                        ],
                      ),
                    ],
                  ),
                  //

                  //categories
                  VendorTypeCategories(
                    widget.vendorType,
                    showTitle: false,
                    description: "Categories🔥",
                    childAspectRatio: 1.4,
                    crossAxisCount: 4,
                    isService: true,
                  ),
                  ServicesByIdView(widget.vendorType, 37),
                  ServicesByIdView(widget.vendorType, 38),
                  //top services
                  // PopularServicesView(widget.vendorType),
                  //
                  UiSpacer.verticalSpace(),
                  //top vendors
                  TopServiceVendors(widget.vendorType),

                  //
                  UiSpacer.verticalSpace(),
                ],
              ).scrollVertical(),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
