import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/product_review_stat.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_review.vm.dart';
import 'package:fuodz/views/pages/product/widgets/amazon/product_review_sumup.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/product_review.list_item.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductReviewsPage extends StatelessWidget {
  const ProductReviewsPage(this.product, {Key key}) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "%s reviews".tr().fill([product.name]),
      showAppBar: true,
      showLeadingAction: true,
      body: ViewModelBuilder<ProductReviewViewModel>.reactive(
        viewModelBuilder: () => ProductReviewViewModel(context, product, false),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              //review summary
              ProductReviewSumupView(product),
              UiSpacer.vSpace(),
              ...(ratingPercentageView(vm.productReviewStats)),

              UiSpacer.divider().py12(),

              //all reviews
              CustomListView(
                noScrollPhysics: true,
                isLoading: vm.busy(vm.productReviews),
                dataSet: vm.productReviews,
                itemBuilder: (ctx, index) {
                  final productReview = vm.productReviews[index];
                  return ProductReviewListItem(productReview);
                },
              ),
              //loading more indicator
              CustomVisibilty(
                visible: vm.busy(vm.scrollController),
                child: BusyIndicator().centered().p8(),
              ),
            ],
          ).scrollVertical(
            controller: vm.scrollController,
            padding: EdgeInsets.all(20),
          );
        },
      ),
    );
  }

  List<Widget> ratingPercentageView(
      List<ProductReviewStat> productReviewStats) {
    List<Widget> items = [];
    for (var productReviewStat in productReviewStats) {
      final item = HStack(
        [
          //rating
          "%s star"
              .tr()
              .fill([productReviewStat.rate])
              .text.medium
              .color(AppColor.primaryColor)
              .make()
              .expand(flex: 2),
          UiSpacer.hSpace(8),
          //
          HStack(
            [
              Container(color: AppColor.ratingColor, height: 20).expand(
                flex: (productReviewStat.percentage / 10).ceil(),
              ),
              Container(color: Vx.gray200, height: 20).expand(
                flex: ((100 - productReviewStat.percentage) / 10).ceil(),
              ),
            ],
          )
              .box
              .withRounded(value: 5)
              .border(color: Vx.gray400)
              .clip(Clip.antiAliasWithSaveLayer)
              .make()
              .expand(flex: 8),
          UiSpacer.hSpace(8),
          //
          "${NumberFormat("#.##").format(productReviewStat.percentage)}%"
              .text.medium
              .color(AppColor.primaryColor)
              .maxLines(1)
              .make()
              .expand(flex: 2),
        ],
      ).pOnly(bottom: Vx.dp12);
      items.add(item);
    }
    return items;
  }
}
