import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/app_ui_sizes.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/view_models/vendor_details.vm.dart';
import 'package:fuodz/views/pages/vendor_details/vendor_category_products.page.dart';
import 'package:fuodz/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/notextcategoryitem.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/Other_Busy_Loading.dart';
import 'package:fuodz/utils/ui_spacer.dart';


class VendorDetailsWithSubcategoryPage extends StatelessWidget {
  VendorDetailsWithSubcategoryPage({this.vendor, Key key}) : super(key: key);

  final Vendor vendor;


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(context, vendor),
      onModelReady: (model) => model.getVendorDetails(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            VendorDetailsHeader(model),
            UiSpacer.verticalSpace(space: 5),
            "Shop by categories"
                .text
                .extraBold
                .black
                .xl
                .makeCentered(),

            //categories
            model.isBusy
                ? OtherBusyLoad().p20().centered()
                : CustomGridView(
              noScrollPhysics: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,

              childAspectRatio: (context.screenWidth / 5.3) / 100,
              crossAxisCount: AppStrings.categoryPerRow,
              dataSet: model.vendor.categories,
              padding: EdgeInsets.all(20),

              itemBuilder: (ctx, index) {
                final category = model.vendor.categories[index];
                return NoCategoryListItem(
                  h: AppStrings.categoryImageHeight + 40,



                  category: category,
                  onPressed: (category) {
                    //
                    category.hasSubcategories = category.subcategories.isNotEmpty;
                    context.nextPage(
                      VendorCategoryProductsPage(
                        category: category,
                        vendor: model.vendor,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ).scrollVertical().expand();
      },
    );
  }
}
