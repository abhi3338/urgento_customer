import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_summary.vm.dart';
import 'package:fuodz/views/pages/taxi/widgets/order_taxi.button.dart';
import 'package:fuodz/views/pages/taxi/widgets/step_two/new_taxi_order_payment_method.selection_view.dart';
import 'package:fuodz/views/pages/taxi/widgets/step_two/new_taxi_order_vehicle_type.list_view.dart';
import 'package:fuodz/views/pages/taxi/widgets/taxi_discount_section.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiOrderSummaryPanel extends StatelessWidget {
  const NewTaxiOrderSummaryPanel(
    this.newTaxiOrderSummaryViewModel, {
    Key key,
  }) : super(key: key);

  final NewTaxiOrderSummaryViewModel newTaxiOrderSummaryViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = newTaxiOrderSummaryViewModel.taxiViewModel;
    return MeasureSize(
      onChange: (size) {
        vm.updateGoogleMapPadding(height: size.height + Vx.dp40);
      },
      child: VStack(
        [
          VStack(
            [
              //
              HStack(
                [
                  //previous
                  CustomTextButton(
                    padding: EdgeInsets.zero,
                    title: "Back".tr(),
                    titleColor: Colors.red,
                    onPressed: newTaxiOrderSummaryViewModel.closePanel,
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
              UiSpacer.verticalSpace(),
              //vehicle types
              TaxiVehicleTypeListView(vm: vm, min: false).expand(),
              UiSpacer.vSpace(),
            ],
          ).safeArea().p20().expand(),
          VStack(
            [
              //discount section
              TaxiDiscountSection(vm, fullView: true).box.p8.make().py8(),
              //selected payment method
              NewTaxiOrderPaymentMethodSelectionView(
                vm: newTaxiOrderSummaryViewModel,
              ),
              UiSpacer.vSpace(10),
              OrderTaxiButton(vm),
            ],
          )
              .safeArea(top: false)
              .pSymmetric(h: 20, v: 12)
              .box
              .shadow2xl
              .color(context.theme.colorScheme.background)
              .make(),
        ],
      )
          .box
          .color(context.theme.colorScheme.background)
          .topRounded(value: 5)
          .make(),
    );
  }
}
