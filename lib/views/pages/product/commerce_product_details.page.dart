import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/views/pages/commerce/widgets/similar_commerce_products.view.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_details.header.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_details_cart.bottom_sheet.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_options.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_price.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_qty.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_seller_tile.dart';
import 'package:fuodz/views/pages/product/widgets/product_image.gallery.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/html_text_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductDetailsPage extends StatelessWidget {
  CommerceProductDetailsPage({this.product, Key key}) : super(key: key);

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
          showLeadingAction: true,
          elevation: 0,
          appBarColor: Colors.transparent,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              //product image
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  top: false,
                  child: Hero(
                    tag: model.product.heroTag,
                    child: ProductImagesGalleryView(model.product),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: VStack(
                  [
                    //product header
                    CommerceProductDetailsHeader(
                      product: model.product,
                      model: model,
                    ),
                    UiSpacer.divider(),
                    //price
                    CommerceProductPrice(model: model),
                    UiSpacer.divider(),
                    //options
                    CommerceProductOptions(model),
                    UiSpacer.divider(),
                    //qty
                    CommerceProductQtyEntry(model: model),
                    UiSpacer.divider(),
                    //vendor/seller details
                    CommerceSellerTile(model: model),
                    UiSpacer.divider().pOnly(bottom: Vx.dp12),

                    //product details
                    HtmlTextView(model.product.description),

                    //similar products
                    SimilarCommerceProducts(product),
                  ],
                )
                    .pOnly(bottom: context.percentHeight * 30)
                    .box
                    .outerShadow
                    .color(context.theme.colorScheme.background)
                    .topRounded(value: 20)
                    .clip(Clip.antiAlias)
                    .make(),
              ),
            ],
          ).box.color(AppColor.faintBgColor).make(),
          bottomSheet: CommerceProductDetailsCartBottomSheet(model: model),
        );
      },
    );
  }
}
