import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/views/pages/product/widgets/add_to_cart.btn.dart';
import 'package:fuodz/views/pages/product/widgets/amazon/frequently_bought_together.view.dart';
import 'package:fuodz/views/pages/product/widgets/buy_now.btn.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_options.dart';
import 'package:fuodz/views/pages/product/widgets/product_fav.btn.dart';
import 'package:fuodz/widgets/buttons/share.btn.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/custom_image_slider.dart';
import 'package:fuodz/widgets/html_text_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widgets/amazon/amazon_customer_product_reviews.dart';

class AmazonStyledCommerceProductDetailsPage extends StatelessWidget {
  AmazonStyledCommerceProductDetailsPage({this.product, Key key})
      : super(key: key);

  final Product product;

  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product),
      onModelReady: (model) => model.getProductDetails(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          title: "Product details".tr(),
          showLeadingAction: true,
          // elevation: 0,
          // appBarColor: Colors.transparent,
          // appBarItemColor: AppColor.primaryColor,
          showCart: true,
          body: SingleChildScrollView(
            child: VStack(
              [
                //visit vendor
                VStack(
                  [
                    "Visit the %s Store"
                        .tr()
                        .fill([model.product.vendor.name])
                        .text
                        .color(Utils.textColorByBrightness(context))
                        .size(13)
                        .medium
                        .make()
                        .onInkTap(model.openVendorDetails),
                    UiSpacer.vSpace(5),
                    //product name
                    model.product.name.text.size(17).semiBold.make(),
                    UiSpacer.vSpace(5),
                    //rating
                    HStack(
                      [
                        VxRating(
                          size: 20,
                          maxRating: 5.0,
                          value: model.product.rating,
                          isSelectable: false,
                          onRatingUpdate: null,
                          selectionColor: AppColor.ratingColor,
                        ),
                        UiSpacer.hSpace(10),
                        "(${model.product.reviewsCount})"
                            .text
                            .color(Utils.textColorByBrightness(context))
                            .make(),
                      ],
                    ).onTap(() => scrollTo(model.productReviewsKey)),
                  ],
                ).p20(),
                //
                Stack(
                  children: [
                    //images
                    CustomImageSlider(
                      model.product.photos,
                      height: context.percentHeight * 32,
                      viewportFraction: 1.0,
                      autoplay: false,
                      boxFit: BoxFit.scaleDown,
                    ).py8(),
                    //fav
                    Positioned(
                      child: ProductFavButton(model: model),
                      bottom: 15,
                      left: !Utils.isArabic ? 15 : null,
                      right: !Utils.isArabic ? null : 15,
                    ),
                    //share link
                    Positioned(
                      child: ShareButton(model: model),
                      top: 0,
                      left: Utils.isArabic ? 5 : null,
                      right: Utils.isArabic ? null : 5,
                    )
                  ],
                ),
                //
                UiSpacer.vSpace(30),
                //discount price
                Visibility(
                  visible: model.product.showDiscount,
                  child: HStack(
                    [
                      "Was:".tr().text.gray700.make(),
                      UiSpacer.hSpace(4),
                      "${AppStrings.currencySymbol} ${model.product.price}"
                          .currencyFormat()
                          .text
                          .color(AppColor.primaryColor)
                          .size(14)
                          .semiBold
                          .make()
                          .expand(),
                    ],
                  ).px20(),
                ),
                UiSpacer.vSpace(10),
                //price
                HStack(
                  [
                    "Price:".tr().text.color(Utils.textColorByBrightness(context)).make(),
                    UiSpacer.hSpace(4),
                    "${AppStrings.currencySymbol} ${model.product.sellPrice}"
                        .currencyFormat()
                        .text
                        .color(Utils.textColorByBrightness(context))
                        .size(18)
                        .bold
                        .make()
                        .expand(),
                  ],
                ).py4().px20(),
                UiSpacer.vSpace(),
                //available stock
                CustomVisibilty(
                  visible: model.product.hasStock,
                  child: VStack(
                    [
                      //qty selector
                      "In Stock."
                          .text
                          .xl
                          .semiBold
                          .color(Utils.textColorByBrightness(context))
                          .make()
                          .px20(),
                      UiSpacer.vSpace(5),
                      DropdownButton<int>(
                        underline: UiSpacer.emptySpace(),
                        value: model.product.selectedQty ?? 1,
                        items: List.generate(
                          model.product.availableQty ?? 10,
                          (index) {
                            final mValue = index + 1;
                            return DropdownMenuItem(
                              value: mValue,
                              child: "Qty:  %s".tr().fill([mValue]).text.make(),
                            );
                          },
                        ),
                        onChanged: (value) {
                          model.product.selectedQty = value;
                          model.notifyListeners();
                        },
                      )
                          .px8()
                          .box
                          .roundedSM
                          .outerShadowSm
                          .clip(Clip.antiAlias)
                          .color(AppColor.accentColor.withOpacity(0.1))
                          .border(color: AppColor.primaryColor.withOpacity(0.8))
                          .make()
                          .px20(),

                      UiSpacer.vSpace(15),
                      //options
                      UiSpacer.divider(height: 4, thickness: 5).py12(),
                      CommerceProductOptions(model),
                      UiSpacer.divider(height: 4, thickness: 5).py12(),
                      //action buttons
                      UiSpacer.vSpace(15),
                      //add to cart
                      AddToCartButton(model).wFull(context).px20(),
                      UiSpacer.vSpace(10),
                      //buy now
                      BuyNowButton(model).wFull(context).px20(),
                    ],
                  ),
                ),
                //no stock
                CustomVisibilty(
                  visible: !model.product.hasStock,
                  child: "No stock"
                      .tr()
                      .text
                      .white
                      .makeCentered()
                      .p8()
                      .box
                      .red500
                      .roundedSM
                      .make()
                      .p8(),
                ).px20(),

                UiSpacer.divider(height: 4, thickness: 5).py12(),
                //frequently bought together
                FrequentlyBoughtTogetherView(model.product),
                //product details
                HtmlTextView(model.product.description).px20(),
                UiSpacer.divider(height: 4, thickness: 5).py12(),

                VStack(
                  [
                    // //product header
                    // CommerceProductDetailsHeader(
                    //   product: model.product,
                    //   model: model,
                    // ),
                    // UiSpacer.divider(),
                    // //price
                    // CommerceProductPrice(model: model),
                    // UiSpacer.divider(),
                    // //options
                    // CommerceProductOptions(model),
                    // UiSpacer.divider(),
                    // //qty
                    // CommerceProductQtyEntry(model: model),
                    // UiSpacer.divider(),
                    // //vendor/seller details
                    // CommerceSellerTile(model: model),
                    // UiSpacer.divider().pOnly(bottom: Vx.dp12),

                    // //product details
                    // HtmlTextView(model.product.description),

                    // //similar products
                    // SimilarCommerceProducts(product),
                    //customer reviews widget
                    UiSpacer.vSpace(20),
                    AmazonCustomerProductReview(
                      product: model.product,
                      key: model.productReviewsKey,
                    ),
                  ],
                ).px20(),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  scrollTo(GlobalKey viewKey) {
    Scrollable.ensureVisible(viewKey.currentContext);
  }
}
