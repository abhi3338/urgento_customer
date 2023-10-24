import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/view_models/checkout.vm.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';

class DeliveryTipView extends StatelessWidget {

  final String value;
  final CheckoutViewModel model;
  final String selectedValue;

  const DeliveryTipView({Key key, @required this.value, @required this.model, @required this.selectedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: (value.toLowerCase() == "custom" ? "Custom" : "${model.currencySymbol} ${value}".currencyFormat()) .trim().text.color(selectedValue != null ? selectedValue == value ? Colors.white : AppColor.primaryColor : Utils.textColorByBrightness(context)).center.fontWeight(FontWeight.w500).maxFontSize(14.0).minFontSize(14.0).make(),
    )
    .w(80.0)
    .box
    .color(selectedValue != null ? selectedValue == value ? AppColor.primaryColor : Colors.transparent : Colors.transparent)
    .margin(EdgeInsets.only(right: 8.0))
    .customRounded(BorderRadius.circular(18.0))
    .border(color: Utils.textColorByBrightness(context).withOpacity(0.4))
    .alignCenter
    .makeCentered()
    .centered();
  }
}
