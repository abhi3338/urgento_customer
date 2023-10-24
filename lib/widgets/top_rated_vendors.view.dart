import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/top_vendors.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/top_rated_vendor.list_item.dart';
import 'package:fuodz/widgets/states/vendor.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TopRatedVendors extends StatelessWidget {
  const TopRatedVendors(
    this.vendorType, {
    Key key,
  }) : super(key: key);

  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopVendorsViewModel>.reactive(
      viewModelBuilder: () => TopVendorsViewModel(
        context,
        vendorType,
        params: {"type": "rated"},
        enableFilter: false,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            Visibility(
              visible: model.isBusy,
              child: BusyIndicator().centered(),
            ),
            //
            Visibility(
              visible: model.vendors != null && model.vendors.isNotEmpty,
              child: VStack(
                [
                  //
                  "Top Rated".tr().text.lg.medium.make().p12(),

                  //vendors list
                  CustomListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    dataSet: model.vendors,
                    isLoading: model.isBusy,
                    itemBuilder: (context, index) {
                      //
                      final vendor = model.vendors[index];
                      return TopRatedVendorListItem(
                        vendor: vendor,
                        onPressed: model.vendorSelected,
                      );
                    },
                    emptyWidget: EmptyVendor(),
                  ).h(model.vendors.isEmpty ? 220 : 140),
                ],
              ).py12(),
            ),
          ],
        );
      },
    );
  }
}
