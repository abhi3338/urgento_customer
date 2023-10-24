import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomMasonryGridView extends StatelessWidget {
  //
  final Widget title;
  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget emptyWidget;
  final List<Widget> items;
  final bool isLoading;
  final bool hasError;
  final bool justList;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  //
  final bool canRefresh;
  final RefreshController refreshController;
  final Function onRefresh;
  final Function onLoading;
  final bool canPullUp;

  const CustomMasonryGridView({
    this.title,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.justList = true,
    @required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 2,
    this.mainAxisSpacing = 0,

    //
    this.canRefresh = false,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.canPullUp = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.justList
        ? _getBody()
        : VStack(
            [
              this.title ?? UiSpacer.emptySpace(),
              _getBody(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          );
  }

  Widget _getBody() {
    return this.isLoading
        ? this.loadingWidget ?? LoadingShimmer()
        : this.hasError
            ? this.errorWidget ?? EmptyState()
            : this.justList
                ? this.items.isEmpty
                    ? this.emptyWidget ?? UiSpacer.emptySpace()
                    : _getBodyList()
                : Expanded(
                    child: _getBodyList(),
                  );
  }

  //
  Widget _getBodyList() {
    return this.canRefresh
        ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: canPullUp,
            controller: this.refreshController,
            onRefresh: this.onRefresh,
            onLoading: this.onLoading,
            child: _getListView(),
          )
        : _getListView();
  }

  //get listview
  Widget _getListView() {
    return MasonryGrid(
      column: this.crossAxisCount,
      crossAxisSpacing: this.crossAxisSpacing,
      mainAxisSpacing: this.mainAxisSpacing,
      children: this.items,
    );

  }
}
