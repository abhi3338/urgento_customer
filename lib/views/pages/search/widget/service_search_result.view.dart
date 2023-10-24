import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/main_search.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/service.list_item.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/service.gridview_item.dart';

class ServiceSearchResultView extends StatefulWidget {
  ServiceSearchResultView(this.vm, {Key key}) : super(key: key);

  final MainSearchViewModel vm;
  @override
  State<ServiceSearchResultView> createState() =>
      _ServiceSearchResultViewState();
}

class _ServiceSearchResultViewState extends State<ServiceSearchResultView> {
  @override
  Widget build(BuildContext context) {
    final refreshController = widget.vm.refreshControllers.last;
    //
    return (widget.vm.search.layoutType == null ||
            widget.vm.search.layoutType == "grid")
        ? CustomGridView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchServices,
            onLoading: () => widget.vm.searchServices(initial: false),
            dataSet: widget.vm.services,
            mainAxisSpacing: 0,
            crossAxisSpacing: 15,
            isLoading: widget.vm.busy(widget.vm.services),
            childAspectRatio: (context.screenWidth / 6.8) / 100,
            separatorBuilder: (p0, p1) => UiSpacer.vSpace(0),
            itemBuilder: (ctx, index) {
              final service = widget.vm.services[index];
              return ServiceGridViewItem(
                service: service,
                onPressed: widget.vm.servicePressed,
              );
            },
          )
        : CustomListView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchServices,
            onLoading: () => widget.vm.searchServices(initial: false),
            dataSet: widget.vm.services,
            isLoading: widget.vm.busy(widget.vm.services),
            itemBuilder: (ctx, index) {
              final service = widget.vm.services[index];
              return ServiceGridViewItem(
                service: service,
                onPressed: widget.vm.servicePressed,
              );







                ServiceListItem(
                service: service,
                onPressed: widget.vm.servicePressed,
                height: 80,
                imgW: 60,
              );
            },
            separatorBuilder: (p0, p1) => UiSpacer.vSpace(10),
            padding: EdgeInsets.all(0),
          );
  }
}
