import 'package:flutter/material.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_option_group.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductOptions extends StatelessWidget {
  const CommerceProductOptions(this.model, {Key key}) : super(key: key);
  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    //
    return Visibility(
      visible: model.product.optionGroups.isNotEmpty,
      child: model.busy(model.product)
          ? BusyIndicator().centered().py20()
          : VStack(
              [
                UiSpacer.vSpace(10),
                "Note: Long press option to see option full details".tr().text.sm.light.italic.make().px20(),
                UiSpacer.vSpace(5),
                ...buildProductOptions(model),
              ],
            ),
    );
  }

  //
  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return CommerceProductOptionGroup(optionGroup: optionGroup, model: model);
    }).toList();
  }
}
