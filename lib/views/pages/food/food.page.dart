import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/enums/product_fetch_data_type.enum.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor.vm.dart';
import 'package:fuodz/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/header.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_products.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:fuodz/widgets/list_items/food_horizontal_product.list_item.dart';
import 'package:fuodz/widgets/list_items/grid_view_product.list_item.dart';
import 'package:fuodz/widgets/list_items/horizontal_product.list_item.dart';
import 'package:fuodz/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:fuodz/widgets/list_items/vendor.list_item.dart';
import 'package:fuodz/widgets/notext_vendor_type_category_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';
import 'package:fuodz/widgets/list_items/grocery_product.list_item.dart';

import '../../../widgets/list_items/food_vendor.list_item.dart';

class FoodPage extends StatefulWidget {
  const FoodPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with AutomaticKeepAliveClientMixin<FoodPage> {
  GlobalKey pageKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<VendorViewModel>.reactive(
      viewModelBuilder: () => VendorViewModel(context, widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: false,
          showCartView: true,
          showLogo: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: Utils.textColorByBrightness(context),
          showCart: true,
          key: model.pageKey,

          body: VStack(
          [
          //location setion


          SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: model.refreshController,
          onRefresh: model.reloadPage,
          child: VStack( [
        //   [
            //
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: context.screenWidth,
                  child: Image.network(
                    'https://superappadmin.aworkconnect.in/imghost/foodbg.png',
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
                      showSearch: true,
                      onrefresh: model.reloadPage,
                    ),
                    UiSpacer.verticalSpace(space: 5),
                    UiSpacer.verticalSpace(space: 180),
                    Banners(
                      widget.vendorType,
                      itemRadius: 25,
                    ).px20(),
                  ],
                ),
              ],
            ),


            //address

        //search bar
        //
        //     VendorHeader(
        //       model: model,
        //       showSearch: true,
        //       onrefresh: model.reloadPage,
        //     ),
        //     UiSpacer.verticalSpace(space: 5),

            // SearchBarInput(
            //   hintText:
            //   "Search for your desired foods or restaurants".tr(),
            //   readOnly: true,
            //   search: Search(
            //     vendorType: widget.vendorType,
            //     viewType: SearchType.vendorProducts,
            //   ),
            // ).px12(),
            //
            // UiSpacer.verticalSpace(space: 180),
            //
            //
            // Banners(
            //   widget.vendorType,
            //   itemRadius: 25,
            // ).px20(),



        //banners



        SectionCouponsView(
        widget.vendorType,
        title: "Coupons".tr(),
        scrollDirection: Axis.horizontal,
        itemWidth: context.percentWidth * 40,
        height: 90,
        itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        ),

        //categories
        // Categories(
        //   widget.vendorType,
        // ),
        //categories
        NoVendorTypeCategories(
        widget.vendorType,
        loadingWidget: const SizedBox.shrink(),
        title: "Categories".tr(),
        crossAxisCount: AppStrings.categoryPerRow,
        ),
        //flash sales products
        FlashSaleView(
        widget.vendorType,
        loadingWidget: const SizedBox.shrink(),
        useBusyIndicator: false,
        ),
        //popular vendors


        SectionVendorsView(
        widget.vendorType,
        title: "Top Vendors".tr(),
        scrollDirection: Axis.horizontal,
        type: SearchFilterType.featured,
          viewType: FoodVendorListItem,
        itemWidth: context.percentWidth * 48,
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


        //popular foods

        /*   //new vendors
                    CustomVisibilty(
                      visible: !AppStrings.enableSingleVendor,
                      child: SectionVendorsView(
                        widget.vendorType,
                        title: "New on".tr() + " ${AppStrings.appName}",
                        scrollDirection: Axis.horizontal,
                        type: SearchFilterType.fresh,
                        itemWidth: context.percentWidth * 40,
                        byLocation: AppStrings.enableFatchByLocation,
                      ),
                    ), */
/*
                    SectionProductsView(
                      widget.vendorType,
                      title: "Best Selling".tr(),
                      scrollDirection: Axis.horizontal,
                      type: ProductFetchDataType.BEST,
                      itemWidth: context.percentWidth * 50,
                      itemHeight: 300,
                      viewType: GroceryProductListItem,
                      listHeight: 170,
                      byLocation: AppStrings.enableFatchByLocation,
                      loadingWidget: const SizedBox.shrink(),
                    ), */


        CustomVisibilty(
        visible: !AppStrings.enableSingleVendor,
        child: SectionVendorsView(
        widget.vendorType,
        title: "All Vendors/Restaurants".tr(),
        scrollDirection: Axis.vertical,
        viewType: FoodVendorListItem,
        separator: UiSpacer.verticalSpace(space: 10),
        byLocation: AppStrings.enableFatchByLocation,
        loadingWidget: const SizedBox.shrink(),
        ),
        ),

        //all vendor

        //all products
        CustomVisibilty(
        visible: AppStrings.enableSingleVendor,
        child: SectionProductsView(
        widget.vendorType,
        title: "All Products".tr(),
        scrollDirection: Axis.vertical,
        type: ProductFetchDataType.FEATURED,
        viewType: ProductGridListItem,
        separator: UiSpacer.verticalSpace(space: 0),
        byLocation: AppStrings.enableFatchByLocation,
        listHeight: null,
        loadingWidget: const SizedBox.shrink(),
        ),
        ),

        //view all vendors
        ViewAllVendorsView(
        vendorType: widget.vendorType,
        ),
        UiSpacer.verticalSpace(),
        ],
        // key: model.pageKey,
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