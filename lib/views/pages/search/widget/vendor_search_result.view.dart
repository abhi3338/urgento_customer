import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/main_search.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/dynamic_vendor.list_item.dart';
import 'package:fuodz/widgets/list_items/food_vendor.list_item.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorSearchResultView extends StatefulWidget {
  VendorSearchResultView(this.vm, {Key key}) : super(key: key);

  final MainSearchViewModel vm;
  @override
  State<VendorSearchResultView> createState() => _VendorSearchResultViewState();
}

class _VendorSearchResultViewState extends State<VendorSearchResultView> {
  @override
  Widget build(BuildContext context) {
    final refreshController = widget.vm.refreshControllers[0];
    //
    return (widget.vm.search.layoutType == null ||
            widget.vm.search.layoutType == "grid")
        ? CustomGridView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchVendors,
            onLoading: () => widget.vm.searchVendors(initial: false),
            dataSet: widget.vm.vendors,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            isLoading: widget.vm.busy(widget.vm.vendors),
            childAspectRatio: (context.screenWidth / 3.7) / 100,
            itemBuilder: (ctx, index) {
              final vendor = widget.vm.vendors[index];
              return FoodVendorListItem(
                vendor: vendor,
                onPressed: widget.vm.vendorSelected,
              );
            },
          )
        : CustomListView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchVendors,
            onLoading: () => widget.vm.searchVendors(initial: false),
            dataSet: widget.vm.vendors,
            isLoading: widget.vm.busy(widget.vm.vendors),
            itemBuilder: (ctx, index) {
              final vendor = widget.vm.vendors[index];
              return FoodVendorListItem(
                vendor: vendor,
                onPressed: widget.vm.vendorSelected,
              );
            },
            separatorBuilder: (p0, p1) => UiSpacer.vSpace(10),
          );
  }
}
