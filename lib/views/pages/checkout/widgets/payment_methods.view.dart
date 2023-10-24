import 'package:flutter/material.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/payment_method.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView(this.vm, {Key key}) : super(key: key);

  final CheckoutBaseViewModel vm;


  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Payment Methods".tr().text.semiBold.xl.make(),
        CustomGridView(
          noScrollPhysics: true,
          dataSet: vm.paymentMethods,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          isLoading: vm.busy(vm.paymentMethods),
          itemBuilder: (context, index) {
            //
            final paymentMethod = vm.paymentMethods[index];
            print("paymentMethods===>>>>${paymentMethod.name}");
            return PaymentOptionListItem(
              paymentMethod,
              selected: vm.isSelected(paymentMethod),
              onSelected: vm.changeSelectedPaymentMethod,
            );
          },
        ).pOnly(top: Vx.dp16),
        //
        // Divider(thickness: 3).py12(),
      ],
    );
  }
}
