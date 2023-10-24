import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/enums/product_fetch_data_type.enum.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/grocery.vm.dart';
import 'package:fuodz/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:fuodz/views/pages/grocery/widgets/grocery_categories.view.dart';
import 'package:fuodz/views/pages/grocery/widgets/grocery_categories_products.view.dart';
import 'package:fuodz/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/header.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/nearby_vendors.view.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_products.view.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';
import 'package:fuodz/widgets/list_items/grid_view_product.list_item.dart';
import 'package:fuodz/widgets/list_items/grocery_product.list_item.dart';

import '../../../utils/ui_spacer.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;
  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage>
    with AutomaticKeepAliveClientMixin<GroceryPage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<GroceryViewModel>.reactive(
      viewModelBuilder: () => GroceryViewModel(context, widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: false,
          showLogo:true,
          showCartView: true,
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
                  [

                    Stack(
                      children: [
                        SizedBox(
                          height: 300,
                          width: context.screenWidth,
                          child:  Image.network(
                              'https://superappadmin.aworkconnect.in/imghost/grocerybg.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container();
                              },
                            ),

                        ),
                        Column(
                          children: [



                            VendorHeader(
                              model: model,
                              onrefresh: model.reloadPage,
                            ),
                            UiSpacer.verticalSpace(space: 200),

                            Banners(
                              widget.vendorType,
                              itemRadius: 25,
                            ).px20(),

                            // Top widgets
                          ],
                        ),
                      ],
                    ),
                    //banners
         GroceryCategories(widget.vendorType),

                    //categories


                    //coupons
                    SectionCouponsView(
                      widget.vendorType,
                      title: "Coupons".tr(),
                      scrollDirection: Axis.horizontal,
                      itemWidth: context.percentWidth * 40,
                      height: 90,
                      loadingWidget: const SizedBox.shrink(),
                      itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    ),

                    //flash sales products
                    FlashSaleView(widget.vendorType, loadingWidget: const SizedBox.shrink(), useBusyIndicator: false),

                    //today picks
                    GroceryProductsSectionView(
                      "Today Picks".tr() + " 🔥",
                      model.vendorType,
                      showGrid: false,
                      type: ProductFetchDataType.RANDOM,
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

                    //

                    //nearby
                    NearByVendors(widget.vendorType),

                    //top 5 categories products
                    GroceryCategoryProducts(widget.vendorType),

                    //view cart and all vendors
                    //ViewAllVendorsView(vendorType: widget.vendorType),
                  ],
                ).scrollVertical(),
              ).expand(),
            ],
            // key: model.pageKey,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
