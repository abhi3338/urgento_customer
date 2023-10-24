import 'package:flutter/material.dart';
import 'package:fuodz/models/flash_sale.dart';
import 'package:fuodz/view_models/flash_sale.vm.dart';
import 'package:fuodz/views/pages/flash_sale/widgets/flash_sale.item_view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/custom_dynamic_grid_view.dart';
import 'package:stacked/stacked.dart';

class FlashSaleItemsPage extends StatelessWidget {
  const FlashSaleItemsPage(this.flashSale, {Key key}) : super(key: key);

  final FlashSale flashSale;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: flashSale.name,
      showAppBar: true,
      showLeadingAction: true,
      body: ViewModelBuilder<FlashSaleViewModel>.reactive(
        viewModelBuilder: () => FlashSaleViewModel(
          context,
          flashSale: flashSale,
        ),
        onModelReady: (vm) => vm.getFlashSaleItems(),
        builder: (context, vm, child) {
          return CustomDynamicHeightGridView(
            refreshController: vm.refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: vm.getFlashSaleItems,
            onLoading: () => vm.getFlashSaleItems(false),
            noScrollPhysics: true,
            padding: EdgeInsets.all(15),
            itemCount: flashSale.items.length,
            itemBuilder: (ctx, index) {
              final flashSaleItem = flashSale.items[index];
              return FlashSaleItemListItem(
                flashSaleItem,
                fullPage: true,
              );
            },
          );
        },
      ),
    );
  }
}
