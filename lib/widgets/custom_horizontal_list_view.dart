import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CustomHorizontalListView extends StatelessWidget {
  //

  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget emptyWidget;
  final bool isLoading;
  final bool hasError;
  final bool reversed;
  final bool noScrollPhysics;
  final EdgeInsets padding;
  final List<Widget> itemsViews;

  //
  final bool canRefresh;
  final RefreshController refreshController;
  final Function onRefresh;
  final Function onLoading;
  final bool canPullUp;

  const CustomHorizontalListView({
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.reversed = false,
    this.noScrollPhysics = false,
    @required this.itemsViews,
    this.padding,

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
    return _getBody();
  }

  Widget _getBody() {
    final contentBody = this.isLoading
        ? this.loadingWidget ?? LoadingShimmer()
        : this.hasError
            ? this.errorWidget ?? EmptyState(description: "There is an error")
            : this.itemsViews.isEmpty
                ? this.emptyWidget ?? UiSpacer.emptySpace()
                : _getListView();

    return contentBody;
  }

  //get listview
  Widget _getListView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: itemsViews,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
