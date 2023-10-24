import 'package:flutter/material.dart';
import 'package:fuodz/view_models/taxi_new_order_summary.vm.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/directional_chevron.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';

class NewTaxiOrderPaymentMethodSelectionView extends StatelessWidget {
  const NewTaxiOrderPaymentMethodSelectionView({this.vm, Key key})
      : super(key: key);

  final NewTaxiOrderSummaryViewModel vm;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        CustomImage(
          imageUrl: vm.taxiViewModel.selectedPaymentMethod?.photo,
        ).wh(40, 40),
        "${vm.taxiViewModel.selectedPaymentMethod?.name}"
            .text
            .color(Colors.black)
            .make()
            .px12()
            .expand(),
        DirectionalChevron(),
      ],
    )
        .onInkTap(
          vm.openPaymentMethodSelection,
        )
        .box
        .roundedSM
        .gray200
        .px8
        .make();
  }
}
