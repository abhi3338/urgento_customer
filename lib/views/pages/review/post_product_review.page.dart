import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/order_product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_review.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PostProductReviewPage extends StatelessWidget {
  const PostProductReviewPage(this.orderProduct, {Key key}) : super(key: key);
  final OrderProduct orderProduct;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductReviewViewModel>.reactive(
      viewModelBuilder: () => ProductReviewViewModel(
        context,
        orderProduct.product,
        false,
        orderId: orderProduct.orderId,
      ),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          title: "Product Review".tr(),
          showLeadingAction: true,
          body: VStack(
            [
              HStack(
                [
                  //
                  CustomImage(
                    imageUrl: orderProduct.product.photo,
                    width: 40,
                    height: 40,
                  ),
                  UiSpacer.hSpace(12),
                  //
                  orderProduct.product.name.text
                      .maxLines(3)
                      .ellipsis
                      .semiBold
                      .lg
                      .make()
                      .expand(),
                  //
                ],
              ).p12(),
              UiSpacer.divider().py8(),

              //rating
              VxRating(
                value: 3,
                size: 42,
                selectionColor: AppColor.ratingColor,
                normalColor: Vx.gray400,
                maxRating: 5.0,
                stepInt: true,
                onRatingUpdate: vm.updateRating,
              ),
              UiSpacer.vSpace(),

              //review
              "Enter review below:".tr().text.make().py4().wFull(context),
              UiSpacer.vSpace(5),
              CustomTextFormField(
                minLines: 3,
                maxLines: 5,
                hintText: "Review".tr(),
                textEditingController: vm.reviewTEC,
                keyboardType: TextInputType.multiline,
              ),
              UiSpacer.vSpace(),
              //submit
              CustomButton(
                title: "Submit".tr(),
                loading: vm.busy(vm.rating),
                onPressed: vm.submitReview,
              ).wFull(context)
            ],
            crossAlignment: CrossAxisAlignment.center,
          ).scrollVertical(
            padding: EdgeInsets.all(20),
          ),
        );
      },
    );
  }
}
