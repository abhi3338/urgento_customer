import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/views/pages/product/widgets/product_details.header.dart';
import 'package:fuodz/views/pages/product/widgets/product_details_cart.bottom_sheet.dart';
import 'package:fuodz/views/pages/product/widgets/product_option_group.dart';
import 'package:fuodz/views/pages/product/widgets/product_options.header.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/share.btn.dart';
import 'package:fuodz/widgets/cart_page_action.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/html_text_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:fuodz/utils/utils.dart';


class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({this.product, Key key}) : super(key: key);

  final Product product;

  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product),
      onModelReady: (model) => model.getProductDetails(),
      builder: (context, model, child) {
        return BasePage(
          title: model.product.name,
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          appBarColor: AppColor.faintBgColor,
          appBarItemColor: Utils.textColorByBrightness(context),
          showCart: true,
          actions: [
            SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: ShareButton(
                  model: model,
                ),
              ),
            ),
            UiSpacer.hSpace(10),
            PageCartAction(),
          ],
          body: CustomScrollView(
            slivers: [
              //product image
              SliverToBoxAdapter(
                child: BannerCarousel(
                  customizedBanners: model.product.photos.map((photoPath) {
                    return Container(
                      child: CustomImage(
                        imageUrl: photoPath,
                        boxFit: BoxFit.contain,
                        canZoom: true,
                      ),
                    );
                  }).toList(),
                  customizedIndicators: IndicatorModel.animation(
                    width: 10,
                    height: 6,
                    spaceBetween: 2,
                    widthAnimation: 50,
                  ),
                  margin: EdgeInsets.zero,
                  height: context.percentHeight * 30,
                  width: context.percentWidth * 100,
                  activeColor: AppColor.primaryColor,
                  disableColor: Colors.grey.shade300,
                  animation: true,
                  borderRadius: 0,
                  indicatorBottom: true,
                ).box.color(context.theme.colorScheme.background).make(),
              ),

              SliverToBoxAdapter(
                child: VStack(
                  [
                    //product header
                    ProductDetailsHeader(product: model.product),
                    //product description
                    UiSpacer.divider(height: 4, thickness: 5).py12(),
                    HtmlTextView(model.product.description).px20(),
                    UiSpacer.divider(height: 4, thickness: 5).py12(),

                    //options header
                    // Visibility(
                    //   visible: model.product.optionGroups.isNotEmpty,
                    //   child: ProductOptionsHeader(
                    //     description: "Select Add On's to add them to the product/service".tr(),
                    //   ),
                    // ),

                    // //more from vendor
                    // OutlinedButton(
                    //   onPressed: model.openVendorPage,
                    //   child: "View more from"
                    //       .tr()
                    //       .richText
                    //       .sm
                    //       .withTextSpanChildren(
                    //         [
                    //           " ${model.product.vendor.name}"
                    //               .textSpan
                    //               .semiBold
                    //               .make(),
                    //         ],
                    //       )
                    //       .make()
                    //       .py12(),
                    // ).centered().py16(),
                  ],
                )
                    .pOnly(bottom: context.percentHeight * 30)
                    .box
                    .outerShadow3Xl
                    .color(context.theme.colorScheme.background)
                    .topRounded(value: 20)
                    .clip(Clip.antiAlias)
                    .make(),
              ),
            ],
          ).box.color(AppColor.faintBgColor).make(),
          bottomSheet: ProductDetailsCartBottomSheet(model: model),
        );
      },
    );
  }

  //
  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return ProductOptionGroup(optionGroup: optionGroup, model: model)
          .pOnly(bottom: Vx.dp12);
    }).toList();
  }
}

/*
model.busy(model.product)
                              ? BusyIndicator().centered().py20()
                              : VStack(
                                  [
                                    ...buildProductOptions(model),
                                  ],
                                ),
*/