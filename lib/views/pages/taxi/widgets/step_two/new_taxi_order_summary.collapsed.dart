import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_summary.vm.dart';
import 'package:fuodz/views/pages/taxi/widgets/order_taxi.button.dart';
import 'package:fuodz/views/pages/taxi/widgets/step_two/new_taxi_order_payment_method.selection_view.dart';
import 'package:fuodz/views/pages/taxi/widgets/taxi_discount_section.dart';
import 'package:fuodz/views/pages/taxi/widgets/step_two/new_taxi_order_vehicle_type.list_view.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/utils/utils.dart';

class NewTaxiOrderSummaryCollapsed extends StatelessWidget {
  const NewTaxiOrderSummaryCollapsed(
    this.newTaxiOrderSummaryViewModel, {
    Key key,
  }) : super(key: key);

  final NewTaxiOrderSummaryViewModel newTaxiOrderSummaryViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = newTaxiOrderSummaryViewModel.taxiViewModel;
    return MeasureSize(
      onChange: (size) {
        vm.updateGoogleMapPadding(height: size.height + Vx.dp48);
      },
      child: Stack(
        children: [
          VStack(
            [
              //
              HStack(
                [
                  //previous
                  CustomTextButton(
                    padding: EdgeInsets.zero,
                    title: "Back".tr(),
                    titleColor: Utils.textColorByBrightness(context),
                    onPressed: () => vm.closeOrderSummary(clear: false),
                  ).h(24),
                  UiSpacer.swipeIndicator().px12().expand(),
                  //cancel book
                  CustomTextButton(
                    padding: EdgeInsets.zero,
                    title: "Cancel".tr(),
                    titleColor: Colors.red,
                    onPressed: vm.closeOrderSummary,
                  ).h(24),
                ],
              ),
              UiSpacer.vSpace(10),

              //vehicle types
              TaxiVehicleTypeListView(vm: vm),
            ],
          ).p20(),
          //action group
          VStack(
            [
              HStack(
                [
                  //selected payment method
                  NewTaxiOrderPaymentMethodSelectionView(
                    vm: newTaxiOrderSummaryViewModel,
                  ).expand(flex: 6),
                  UiSpacer.hSpace(),
                  //discount section
                  GestureDetector(
                    child: TaxiDiscountSection(vm, fullView: false),
                    onTap: newTaxiOrderSummaryViewModel.openPanel,
                  ).box.roundedSM.gray200.px8.make().expand(flex: 4),
                ],
              ),
              UiSpacer.vSpace(10),
              OrderTaxiButton(vm),
            ],
          )
              .p16()
              .box
              .color(context.theme.colorScheme.background)
              .shadow5xl
              .make()
              .positioned(
                bottom: 0,
                left: 0,
                right: 0,
              ),
        ],
      )
          .box
          .color(context.theme.colorScheme.background)
          .topRounded(value: 20)
          .outerShadowXl
          .make()
    );
  }
}
