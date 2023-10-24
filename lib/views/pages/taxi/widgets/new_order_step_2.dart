import 'package:flutter/material.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_summary.vm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'step_two/new_taxi_order_summary.collapsed.dart';
import 'step_two/new_taxi_order_summary.panel.dart';

class NewTaxiOrderSummaryView extends StatelessWidget {
  const NewTaxiOrderSummaryView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewTaxiOrderSummaryViewModel>.reactive(
        viewModelBuilder: () => NewTaxiOrderSummaryViewModel(context, vm),
        onModelReady: (vm) => WidgetsBinding.instance.addPostFrameCallback(
              (_) {
            vm.initialise();
          },
        ),
        builder: (context, taxiNewOrderSummaryViewModel, child) {
          return Visibility(
            visible: vm.currentStep(2),
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlidingUpPanel(
                color: Colors.transparent,
                controller: taxiNewOrderSummaryViewModel.panelController,
                minHeight: taxiNewOrderSummaryViewModel.customViewHeight,
                maxHeight: context.screenHeight,
                onPanelClosed: taxiNewOrderSummaryViewModel.notifyListeners,
                collapsed:
                taxiNewOrderSummaryViewModel.panelController.isAttached && !taxiNewOrderSummaryViewModel.panelController.isPanelShown
                    ? const SizedBox.shrink()
                    : NewTaxiOrderSummaryCollapsed(taxiNewOrderSummaryViewModel),
                panel: NewTaxiOrderSummaryPanel(taxiNewOrderSummaryViewModel),
              ).pOnly(
                bottom: context.mq.viewInsets.bottom,
              ),
            ),
          );
        });
  }
}
