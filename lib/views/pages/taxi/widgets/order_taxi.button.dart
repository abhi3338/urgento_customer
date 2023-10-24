import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTaxiButton extends StatelessWidget {
  const OrderTaxiButton(this.vm, {Key key}) : super(key: key);

  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = (vm.selectedVehicleType != null &&
        vm.selectedVehicleType.currency != null
        ? vm.selectedVehicleType.currency.symbol
        : AppStrings.currencySymbol);
    //
    return Visibility(
      visible: vm.selectedVehicleType != null,
      child: CustomButton(
        loading: vm.isBusy,
        child: HStack(
          [
            //"Order Now".tr().text.medium.lg.make(),
            "Book ${vm.selectedVehicleType != null ? vm.selectedVehicleType.name : ""}".tr().text.medium.lg.make(),
            UiSpacer.hSpace(10),
            CurrencyHStack(
              [
                "${currencySymbol} ".text.semiBold.xl.make(),
                Visibility(
                  visible: (vm.subTotal > vm.total),
                  child: HStack(
                    [
                      "${vm.subTotal.currencyValueFormat()}"
                          .text
                          .medium
                          .lineThrough
                          .make(),
                      "${vm.total.currencyValueFormat()}"
                          .text
                          .semiBold
                          .xl
                          .make(),
                    ],
                  ),
                ),
                Visibility(
                  visible: !(vm.subTotal > vm.total),
                  child: "${vm.total.currencyValueFormat()}"
                      .text
                      .semiBold
                      .xl
                      .make(),
                ),
              ],
            ),
          ],
        ),
        onPressed: vm.selectedVehicleType != null ? vm.processNewOrder : null,
      ).wFull(context),
    );
  }
}
