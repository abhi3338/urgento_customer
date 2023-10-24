import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor/best_selling_products.vm.dart';
import 'package:fuodz/widgets/custom_dynamic_grid_view.dart';
import 'package:fuodz/widgets/list_items/commerce_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts(
    this.vendorType, {
    this.imageHeight,
    Key key,
  }) : super(key: key);

  final VendorType vendorType;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BestSellingProductsViewModel>.reactive(
      viewModelBuilder: () => BestSellingProductsViewModel(
        context,
        vendorType,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const SizedBox.shrink();
        }
        return VStack(
          [
            //
            UiSpacer.verticalSpace(),
            "Best Selling".tr().text.make().px12().py2(),
            CustomDynamicHeightGridView(
              noScrollPhysics: true,
              separatorBuilder: (context, index) =>
                  UiSpacer.smHorizontalSpace(),
              itemCount: model.products.length,
              isLoading: model.isBusy,
              itemBuilder: (context, index) {
                //
                return CommerceProductListItem(
                  model.products[index],
                  height: imageHeight ?? 80,
                  // onPressed: model.productSelected,
                  // qtyUpdated: model.addToCartDirectly,
                );
              },
            ).px12().py2(),
          ],
        );
      },
    );
  }
}
