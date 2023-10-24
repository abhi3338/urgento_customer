import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/pharmacy.vm.dart';
import 'package:fuodz/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:fuodz/views/pages/pharmacy/widgets/pharmacy_categories.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/best_selling_products.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/header.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/nearby_vendors.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/vendor_type_categories.view.dart';
import 'package:fuodz/views/pages/grocery/widgets/grocery_categories.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_products.view.dart';
import 'package:fuodz/enums/product_fetch_data_type.enum.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/utils/utils.dart';

import '../../../utils/ui_spacer.dart';
import '../../../widgets/list_items/grocery_product.list_item.dart';


class PharmacyPage extends StatefulWidget {
  const PharmacyPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage>
    with AutomaticKeepAliveClientMixin<PharmacyPage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<PharmacyViewModel>.reactive(
      viewModelBuilder: () => PharmacyViewModel(context, widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: false,
          showLogo:true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: Utils.textColorByBrightness(context),
          showCart: true,
          key: model.pageKey,
          body: VStack(
            [
              //


              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: model.refreshController,
                onRefresh: model.reloadPage,
                child: VStack(
                  [  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        width: context.screenWidth,
                        child:  Image.network(
                            'https://superappadmin.aworkconnect.in/imghost/pharmacybg.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace)
                            {
                              return Container();
                            },
                          ),

                      ),
                      Column(
                        children: [

                          UiSpacer.verticalSpace(space: 5),

                          VendorHeader(
                            model: model,
                            showSearch: true,
                            onrefresh: model.reloadPage,
                          ),

                          UiSpacer.verticalSpace(space: 200),
                          Banners(widget.vendorType,
                            itemRadius: 25,),

                          // SearchBarInput(
                          //   hintText:
                          //   "Search for your desired foods or restaurants".tr(),
                          //   readOnly: true,
                          //   search: Search(
                          //     vendorType: widget.vendorType,
                          //     viewType: SearchType.vendorProducts,
                          //   ),
                          // ).px12(),








                          // Top widgets
                        ],
                      ),
                    ],
                  ),


                    //categories
                    GroceryCategories(widget.vendorType,

                    ),

                    //flash sales products
                    FlashSaleView(widget.vendorType, useBusyIndicator: false),

                    //best selling
                    SectionProductsView(
                      widget.vendorType,
                      title: "Best Selling".tr(),
                      scrollDirection: Axis.horizontal,
                      type: ProductFetchDataType.BEST,
                      itemWidth: context.percentWidth * 40,
                      itemHeight: 300,
                      viewType: GroceryProductListItem,
                      listHeight: 270,
                      byLocation: AppStrings.enableFatchByLocation,
                      loadingWidget: const SizedBox.shrink(),
                    ),

                    SectionProductsView(
                      widget.vendorType,
                      title: "Urgento Choice".tr(),
                      loadingWidget: const SizedBox.shrink(),
                      scrollDirection: Axis.horizontal,
                      type: ProductFetchDataType.FEATURED,
                      itemWidth: context.percentWidth * 40,
                      itemHeight: 300,
                      viewType: GroceryProductListItem,
                      listHeight: 270,
                      byLocation: AppStrings.enableFatchByLocation,
                    ),

                    //campain vendors
                    SectionProductsView(
                      widget.vendorType,
                      title: "Special Offers".tr(),
                      scrollDirection: Axis.horizontal,
                      type: ProductFetchDataType.FLASH,
                      itemWidth: context.percentWidth * 40,
                      itemHeight: 300,
                      viewType: GroceryProductListItem,
                      listHeight: 270,
                      byLocation: AppStrings.enableFatchByLocation,
                      loadingWidget: const SizedBox.shrink(),
                    ),

                    //nearby
                    NearByVendors(widget.vendorType),

                    //view cart and all vendors
                    //ViewAllVendorsView(vendorType: widget.vendorType),
                  ],
                ).scrollVertical(),
              ).expand(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
