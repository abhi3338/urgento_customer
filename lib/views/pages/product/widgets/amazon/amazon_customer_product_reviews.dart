import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/product_review.vm.dart';
import 'package:fuodz/views/pages/product/widgets/amazon/product_review_sumup.view.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/product_review.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AmazonCustomerProductReview extends StatelessWidget {
  const AmazonCustomerProductReview({this.product, Key key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductReviewViewModel>.reactive(
      viewModelBuilder: () => ProductReviewViewModel(context, product, true),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            //review summary
            HStack(
              [
                ProductReviewSumupView(product).expand(),

                //arrow
                Icon(
                  Utils.isArabic
                      ? FlutterIcons.chevron_left_fea
                      : FlutterIcons.chevron_right_fea,
                  size: 32,
                ),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).onTap(
              () => vm.openAllReviews(),
            ),

            UiSpacer.divider().py12(),
            //recent reviews
            CustomListView(
              noScrollPhysics: true,
              isLoading: vm.busy(vm.productReviews),
              dataSet: vm.productReviews,
              itemBuilder: (ctx, index) {
                final productReview = vm.productReviews[index];
                return ProductReviewListItem(productReview);
              },
            ),

            CustomVisibilty(
              visible: vm.productReviews.isNotEmpty,
              child: CustomButton(
                child: HStack(
                  [
                    "Sell all reviews".text.xl.semiBold.make().expand(),
                    Icon(
                      Utils.isArabic
                          ? FlutterIcons.chevron_left_fea
                          : FlutterIcons.chevron_right_fea,
                    ),
                  ],
                ),
                onPressed: () => vm.openAllReviews(),
                height: 50,
              ).wFull(context).py12(),
            ),
          ],
        );
      },
    );
  }
}
