import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/nearby_vendors.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/vendor.list_item.dart';
import 'package:fuodz/widgets/states/vendor.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/food_vendor.list_item.dart';

class NearByVendors extends StatelessWidget {
  const NearByVendors(
    this.vendorType, {
    Key key,
  }) : super(key: key);

  final VendorType vendorType;
  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      visible: !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<NearbyVendorsViewModel>.reactive(
        viewModelBuilder: () => NearbyVendorsViewModel(context, vendorType),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return const SizedBox.shrink();
          }

          return VStack(
            [
              //
              HStack(
                [
                  "Nearby Vendors".tr().text.medium.make().expand(),
                  //
                  CustomButton(
                    title: "Delivery".tr(),
                    titleStyle: context.textTheme.bodyLarge.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    onPressed: () => model.changeType(1),
                    color: model.selectedType == 1
                        ? AppColor.primaryColor
                        : Colors.grey.shade600,
                  ).h(32).px8(),
                  //
                  CustomButton(
                    title: "Pickup".tr(),
                    titleStyle: context.textTheme.bodyLarge.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    color: model.selectedType == 2
                        ? AppColor.primaryColor
                        : Colors.grey.shade600,
                    onPressed: () => model.changeType(2),
                  ).h(32),
                ],
              ).p12(),

              //vendors list
              CustomListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                dataSet: model.vendors,
                isLoading: model.isBusy,
                itemBuilder: (context, index) {
                  //
                  final vendor = model.vendors[index];
                  return FittedBox(
                    child: FoodVendorListItem(
                      vendor: vendor,
                      onPressed: model.vendorSelected,
                    ),
                  );
                },
                emptyWidget: EmptyVendor(),
              ).h(model.vendors.isEmpty ? 240 : 195),

              ViewAllVendorsView(vendorType: model.vendorType),
            ],
          );
        },
      ),
    );
  }
}
