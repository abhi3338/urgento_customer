import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/categories.vm.dart';
import 'package:fuodz/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class GroceryCategoryProducts extends StatelessWidget {
  const GroceryCategoryProducts(
      this.vendorType, {
        this.length =30,
        Key key,
      }) : super(key: key);

  final VendorType vendorType;
  final int length;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const SizedBox.shrink();
        }
        return VStack(
          [
            //
            ...(model.categories
                .sublist(
                0,
                model.categories.length < length
                    ? model.categories.length
                    : length

            )
                .map(
                  (category) {
                //
                return GroceryProductsSectionView(
                  category.name,
                  model.vendorType,
                  showGrid: false,
                  category: category,
                );
              },
            ).toList()),



          ],
        );
      },
    );
  }
}
