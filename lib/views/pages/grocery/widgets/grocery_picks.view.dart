import 'package:flutter/material.dart';
import 'package:fuodz/enums/product_fetch_data_type.enum.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/products.vm.dart';
import 'package:fuodz/views/pages/search/search.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/custom_masonry_grid_view.dart';
import 'package:fuodz/widgets/list_items/grocery_product.list_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/grocery_product.list_item.dart';

import '../../../../utils/utils.dart';

class GroceryProductsSectionView extends StatelessWidget {
  const GroceryProductsSectionView(
      this.title,
      this.vendorType, {
        this.type = ProductFetchDataType.RANDOM,
        this.category,
        this.showGrid = true,
        this.crossAxisCount = 2,
        Key key,
      }) : super(key: key);

  final String title;
  final bool showGrid;
  final int crossAxisCount;
  final VendorType vendorType;
  final ProductFetchDataType type;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => ProductsViewModel(
        context,
        vendorType,
        type,
        categoryId: category?.id,
      ),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        if (vm.isBusy) {
          return const SizedBox.shrink();
        }

        return CustomVisibilty(
          visible: vm.products.isNotEmpty && !vm.isBusy,
          child: VStack(
            [
              //
              HStack(
                [
                  Text(
                    "$title🔥",
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      color: Utils.textColorByBrightness(context),
                      fontSize: 18.0,
                      letterSpacing: 0.025,
                    ),
                  ),
                  Spacer(), // Add a Spacer widget to push "See All" to the right

                  GestureDetector(
                    onTap: () {
                      final search = Search(
                        category: category,
                        vendorType: vendorType,
                        showType: 2,
                      );
                      context.push(
                            (context) {
                          return SearchPage(
                            search: search,
                          );
                        },
                      );
                    },
                    child: Text(
                      "See All 👀",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: Utils.textColorByBrightness(context),
                        fontSize: 18.0,
                        letterSpacing: 0.025,
                      ),
                    ),
                  ),
                ],
              ).p12(),

              CustomVisibilty(
                visible: !showGrid,
                child: CustomListView(
                  isLoading: vm.isBusy,
                  dataSet: vm.products,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: Vx.dp12),
                  itemBuilder: (context, index) {
                    return GroceryProductListItem(
                      product: vm.products.elementAt(index),
                      onPressed: vm.productSelected,

                      //qtyUpdated: vm.addToCartDirectly,
                      qtyUpdated: (Product product, int quantity, {bool isIncrement, bool isDecrement}) {
                        vm.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                      },
                    );
                  },
                ).h(vm.anyProductWithOptions ? 270 : 270),
              ),
              CustomVisibilty(
                visible: showGrid,
                child: CustomMasonryGridView(
                  isLoading: vm.isBusy,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: crossAxisCount ?? 2,
                  items: vm.products
                      .map(
                        (product) => GroceryProductListItem(
                      product: product,
                      onPressed: vm.productSelected,
                      //qtyUpdated: vm.addToCartDirectly,
                      qtyUpdated: (Product product, int quantity, {bool isIncrement, bool isDecrement}) {
                        vm.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                      },
                    ),
                  )
                      .toList(),
                ).px12(),
              ),
            ],
          ).py12(),
        );
      },
    );
  }
}
