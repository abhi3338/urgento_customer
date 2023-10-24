import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/categories.vm.dart';
import 'package:fuodz/widgets/vendor_type_categories.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyCategories extends StatefulWidget {
  const PharmacyCategories(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;
  @override
  _PharmacyCategoriesState createState() => _PharmacyCategoriesState();
}

class _PharmacyCategoriesState extends State<PharmacyCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //categories
            VendorTypeCategories(
              widget.vendorType,
              showTitle: true,
              title: "We are here for you".tr(),
              description: "How can we help?".tr(),
              childAspectRatio: 1.4,
              crossAxisCount: AppStrings.categoryPerRow,
            ),

          ],
        );
      },
    );
  }
}
