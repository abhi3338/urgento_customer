import 'package:flutter/material.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/views/pages/order/widgets/basic_taxi_trip_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_driver_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/taxi_order_trip_verification.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/order_summary.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widgets/taxi_trip_map.preview.dart';

import 'package:fuodz/utils/map.utils.dart';

class TaxiOrderDetailPage extends StatefulWidget {
  const TaxiOrderDetailPage({this.order, Key key}) : super(key: key);

  //
  final Order order;

  @override
  _TaxiOrderDetailPageState createState() => _TaxiOrderDetailPageState();
}

class _TaxiOrderDetailPageState extends State<TaxiOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: ViewModelBuilder<OrderDetailsViewModel>.reactive(
        viewModelBuilder: () => OrderDetailsViewModel(context, widget.order),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            title: "Trip Details".tr(),
            elevation: 0,
            showAppBar: true,
            showLeadingAction: true,
            isLoading: vm.isBusy,
            body: VStack(
              [
                //taxi trip map preview
                TaxiTripMapPreview(vm.order),
                //basic info
                BasicTaxiTripInfoView(vm.order),
                UiSpacer.vSpace(),

                //payment status
                OrderPaymentInfoView(vm)
                    .wFull(context)
                    .box
                    .shadowXs
                    .color(context.theme.colorScheme.background)
                    .make(),
                //driver
                OrderDriverInfoView(vm.order),
                //trip codes
                TaxiOrderTripVerificationView(vm.order),

                //order summary
                OrderSummary(
                  subTotal: vm.order.subTotal,
                  discount: vm.order.discount ?? 0,
                  driverTip: vm.order.tip,
                  total: vm.order.total,
                  isAdditionalExpanded: vm.isExpanded,
                  onToggleExpanded: vm.expandedToggle,
                  mCurrencySymbol:
                      "${vm.order.taxiOrder.currency != null ? vm.order.taxiOrder.currency.symbol : AppStrings.currencySymbol}",
                )
                    .px20()
                    .py12()
                    .box
                    .shadowXs
                    .color(context.theme.colorScheme.background)
                    .make()
                    .pSymmetric(v: 20),
                UiSpacer.vSpace(),
              ],
            ).scrollVertical(),
          );
        },
      ),
    );
  }
}
