import 'package:flutter/material.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ParcelOrderPayer extends StatelessWidget {
  const ParcelOrderPayer(this.vm, {Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Order Payer".tr().text.xl.semiBold.make(),
        "Who is paying for order?".tr().text.sm.make(),
        //
        Wrap(
          children: [
            //sender
            HStack(
              [
                Radio(
                  value: true,
                  groupValue: vm.packageCheckout.payer,
                  onChanged: (value) {
                    vm.packageCheckout.payer = value;
                    vm.notifyListeners();
                  },
                ),
                //receiver
                "Sender".tr().text.make().p4(),
              ],
            ),

            //receiver
            HStack(
              [
                Radio(
                  value: false,
                  groupValue: vm.packageCheckout.payer,
                  onChanged: (value) {
                    vm.packageCheckout.payer = value;
                    vm.notifyListeners();
                  },
                ),
                //receiver
                "Receiver".tr().text.make().p4(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
