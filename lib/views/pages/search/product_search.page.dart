import 'package:flutter/material.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/search.vm.dart';
import 'package:fuodz/views/pages/search/widget/search.header.dart';
import 'package:fuodz/views/pages/search/widget/vendor_search_header.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_dynamic_grid_view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/commerce_product.list_item.dart';
import 'package:fuodz/widgets/list_items/grocery_product.list_item.dart';
import 'package:fuodz/widgets/list_items/horizontal_product.list_item.dart';
import 'package:fuodz/widgets/list_items/vendor.list_item.dart';
import 'package:fuodz/widgets/states/search.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';

import '../../../widgets/list_items/food_vendor.list_item.dart';

class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage(
      {Key key, @required this.search, this.showCancel = true})
      : super(key: key);

  //
  final Search search;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(context, search),
      disposeViewModel: false,
      builder: (context, model, child) {
        return BasePage(
          showCartView: showCancel,
          body: SafeArea(
            bottom: false,
            child: VStack(
              [
                //header
                UiSpacer.verticalSpace(),
                SearchHeader(model, showCancel: showCancel),

                //tags
                VendorSearchHeaderview(
                  model,
                  showProducts: true,
                  showVendors: true,
                ),

                //vendors listview
                CustomVisibilty(
                  visible: model.selectTagId == 1,
                  child: CustomListView(
                    refreshController: model.refreshController,
                    canRefresh: true,
                    canPullUp: true,
                    onRefresh: model.startSearch,
                    onLoading: () => model.startSearch(initialLoaoding: false),
                    //isLoading: false,
                    isLoading: model.isBusy,
                    dataSet: model.searchResults,
                    itemBuilder: (context, index) {
                      var searchResult = model.searchResults[index];
                      if (searchResult is Product) {
                        //grocery product list item
                        if (searchResult?.vendor?.vendorType?.isGrocery ??
                            false) {
                          return GroceryProductListItem(
                            product: searchResult,
                            onPressed: model.productSelected,
                            //qtyUpdated: model.addToCartDirectly,
                            qtyUpdated: (Product product, int quantity, {bool isIncrement, bool isDecrement}) {
                              model.addToCartDirectly(product, quantity, isIncrement: isIncrement, isDecrement: isDecrement);
                            },
                          );
                        } else if (searchResult
                            ?.vendor?.vendorType?.isCommerce ??
                            false) {
                          return CommerceProductListItem(
                            searchResult,
                            height: 80,
                          );
                        } else {
                          //regular views
                          return HorizontalProductListItem(
                            searchResult,
                            onPressed: model.productSelected,
                            qtyUpdated: model.addToCartDirectly,
                          );
                        }
                      } else {
                        return FoodVendorListItem(
                          vendor: searchResult,
                          onPressed: model.vendorSelected,
                        );
                      }
                    },
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 10),
                    emptyWidget: EmptySearch(),
                  ).expand(),
                ),

                //product/services related view
                CustomVisibilty(
                  visible: model.selectTagId != 1,
                  child: VStack(
                    [
                      //result listview
                      CustomVisibilty(
                        visible: !model.showGrid,
                        child: CustomListView(
                          refreshController: model.refreshController,
                          canRefresh: true,
                          canPullUp: true,
                          onRefresh: model.startSearch,
                          onLoading: () =>
                              model.startSearch(initialLoaoding: false),
                          isLoading: model.isBusy,
                          dataSet: model.searchResults,
                          itemBuilder: (context, index) {
                            //
                            var searchResult = model.searchResults[index];

                            if (searchResult is Product) {
                              //grocery product list item

                              // var cartItemData = CartServices.productsInCart;
                              // for (var itemData in cartItemData) {
                              //   if (itemData.product.id == searchResult.id) {
                              //     searchResult.selectedQty = itemData.product.selectedQty;
                              //   }
                              // }

                              if (searchResult?.vendor?.vendorType?.isGrocery ??
                                  false) {
                                return GroceryProductListItem(
                                  product: searchResult,
                                  onPressed: model.productSelected,
                                  //qtyUpdated: model.addToCartDirectly,
                                  qtyUpdated: (Product product, int quantity, {bool isIncrement, bool isDecrement}) {
                                    model.addToCartDirectly(product, quantity, isIncrement: isIncrement, isDecrement: isDecrement);
                                  },
                                );
                              } else if (searchResult
                                  ?.vendor?.vendorType?.isCommerce ??
                                  false) {
                                return CommerceProductListItem(
                                  searchResult,
                                  height: 80,
                                );
                              } else {
                                //regular views
                                return HorizontalProductListItem(
                                  searchResult,
                                  onPressed: model.productSelected,
                                  //qtyUpdated: model.addToCartDirectly,
                                    qtyUpdated: ( product, int quantity, {bool isIncrement, bool isDecrement}) {
                                      model.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                                    },
                                    onNewQtyUpdated: (newTempProduct, value, increment, decrement) {
                                      model.addToCartDirectly(newTempProduct, value, isDecrement: decrement, isIncrement: increment);
                                    }
                                );
                              }
                            } else {
                              return FoodVendorListItem(
                                vendor: searchResult,
                                onPressed: model.vendorSelected,
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              UiSpacer.verticalSpace(space: 10),
                          emptyWidget: EmptySearch(),
                        ).expand(),
                      ),

                      //result gridview
                      CustomVisibilty(
                        visible: model.showGrid,
                        child: CustomDynamicHeightGridView(
                          noScrollPhysics: true,
                          refreshController: model.refreshController,
                          canRefresh: true,
                          canPullUp: true,
                          onRefresh: model.startSearch,
                          onLoading: () =>
                              model.startSearch(initialLoaoding: false),
                          isLoading: model.isBusy,
                          itemCount: model.searchResults.length,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            //
                            final searchResult = model.searchResults[index];
                            if (searchResult is Product) {
                              //regular views
                              return ProductGridListItem(
                                  searchResult,
                                  onPressed: model.productSelected,
                                  qtyUpdated: ( product, int quantity, {bool isIncrement, bool isDecrement}) {
                                    model.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                                  },
                                  onNewQtyUpdated: (newTempProduct, value, increment, decrement) {
                                    model.addToCartDirectly(newTempProduct, value, isDecrement: decrement, isIncrement: increment);
                                  }
                              );
                            } else {
                              return FoodVendorListItem(
                                vendor: searchResult,
                                onPressed: model.vendorSelected,
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              UiSpacer.verticalSpace(space: 10),
                          emptyWidget: EmptySearch(),
                        ).expand(),
                      ),
                    ],
                  ).expand(),
                ),
              ],
            ).pOnly(
              left: Vx.dp16,
              right: Vx.dp16,
            ),
          ),
        );
      },
    );
  }
}
