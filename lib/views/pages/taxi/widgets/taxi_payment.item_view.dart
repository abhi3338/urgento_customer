import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';


class TaxiPaymentItemView extends StatelessWidget {
  const TaxiPaymentItemView(this.paymentMethod,
      {this.selected, this.onselected, Key key})
      : super(key: key);

  final PaymentMethod paymentMethod;
  final bool selected;
  final Function onselected;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        CustomImage(
          imageUrl: paymentMethod.photo,
          width: 30,
          height: 30,
        ),
        //
        UiSpacer.horizontalSpace(space: 10),
        "${paymentMethod.name}".text.color(Utils.textColorByBrightness(context)).make(),
      ],
    )
        .p4()
        .box
        .px8
        .roundedSM
        .border(
          color: selected ? AppColor.primaryColor : context.theme.dividerColor,
        )
        .make().onInkTap(onselected);
  }
}
