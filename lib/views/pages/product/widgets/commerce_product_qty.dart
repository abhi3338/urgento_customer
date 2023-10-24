import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductQtyEntry extends StatelessWidget {
  const CommerceProductQtyEntry({this.model, Key key}) : super(key: key);

  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;
    //
    return Visibility(
      visible: model.product.hasStock,
      child: VStack(
        [
          //
          HStack(
            [
              //
              "Quantity:".tr().text.make().expand(flex: 2),
              //
              HStack(
                [
                  VxStepper(
                    defaultValue: model.product.selectedQty ?? 1,
                    min: 1,
                    max: (model.product.availableQty != null &&
                            model.product.availableQty > 0)
                        ? model.product.availableQty
                        : 20,
                    disableInput: true,
                    onChange: model.updatedSelectedQty,
                    actionIconColor: AppColor.primaryColor,
                  ).box.border(
                    color: AppColor.primaryColor,
                  ).roundedLg.p1.make(),
                ],
              ).expand(flex: 4),
            ],
          ),
          UiSpacer.verticalSpace(),
          //total quantity price
          HStack(
            [
              //
              "Total Price:".tr().text.make().expand(flex: 2),
              UiSpacer.smHorizontalSpace(),
              //
              CurrencyHStack(
                [
                  currencySymbol.text.sm.bold
                      .color(context.primaryColor)
                      .make(),
                  model.total
                      .currencyValueFormat()
                      .text
                      .xl
                      .bold
                      .color(context.primaryColor)
                      .make(),
                ],
                crossAlignment: CrossAxisAlignment.end,
              ).expand(flex: 4)
            ],
          ),
        ],
      ).py12().px20(),
    );
  }
}
