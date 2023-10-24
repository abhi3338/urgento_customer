import 'package:flutter/material.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'step_one/new_taxi_order_entry.collapsed.dart';
import 'step_one/new_taxi_order_entry.panel.dart';

class NewTaxiOrderLocationEntryView extends StatelessWidget {
  const NewTaxiOrderLocationEntryView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewTaxiOrderLocationEntryViewModel>.reactive(
      viewModelBuilder: () => NewTaxiOrderLocationEntryViewModel(context, vm),
      onModelReady: (vm) => WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          vm.initialise();
        },
      ),
      builder: (context, taxiNewOrderViewModel, child) {
        return Visibility(
          visible: vm.currentStep(1),
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlidingUpPanel(
              color: Colors.transparent,
              panel: NewTaxiOrderEntryPanel(taxiNewOrderViewModel),
              collapsed: NewTaxiOrderEntryCollapsed(taxiNewOrderViewModel),
              controller: taxiNewOrderViewModel.panelController,
              minHeight: taxiNewOrderViewModel.customViewHeight,
              maxHeight: context.screenHeight,
              onPanelClosed: taxiNewOrderViewModel.notifyListeners,
            ),
          ),
        );
      },
    );
  }
}
