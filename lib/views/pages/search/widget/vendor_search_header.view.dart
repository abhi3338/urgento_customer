import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/search.vm.dart';
import 'package:fuodz/views/pages/search/widget/search_type.tag.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/toogle_grid_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorSearchHeaderview extends StatelessWidget {
  const VendorSearchHeaderview(
    this.model, {
    this.showProducts = false,
    this.showVendors = false,
    this.showProviders = false,
    this.showServices = false,
    Key key,
  }) : super(key: key);

  final SearchViewModel model;
  final bool showVendors;
  final bool showProviders;
  final bool showProducts;
  final bool showServices;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        CustomVisibilty(
          visible: showServices,
          child: SearchTypeTag(
            title: "Services".tr(),
            onPressed: () => model.setSlectedTag(3),
            selected: model.selectTagId == 3,
          ),
        ),

        CustomVisibilty(
          visible: showProducts,
          child: SearchTypeTag(
            title: "Products".tr(),
            onPressed: () => model.setSlectedTag(2),
            selected: model.selectTagId == 2,
          ),
        ),

        // vendors
        CustomVisibilty(
          visible: showVendors,
          child: SearchTypeTag(
            title: "Vendors".tr(),
            onPressed: () => model.setSlectedTag(1),
            selected: model.selectTagId == 1,
          ),
        ),
        //providers
        CustomVisibilty(
          visible: showProviders,
          child: SearchTypeTag(
            title: "Providers".tr(),
            onPressed: () => model.setSlectedTag(1),
            selected: model.selectTagId == 1,
          ),
        ),
        UiSpacer.horizontalSpace().expand(),
        //toggle show grid or listview
        CustomVisibilty(
          visible: model.selectTagId == 2 || model.selectTagId == 3,
          child: ToogleGridViewIcon(
            showGrid: model.showGrid,
            onchange: model.toggleShowGird,
          ),
        ),
      ],
    ).py12();
  }
}
