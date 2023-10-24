import 'package:flutter/material.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CurrencyHStack extends StatelessWidget {
  CurrencyHStack(
    this.children, {
    this.alignment,
    this.crossAlignment,
    this.axisSize,
    this.textSize,
    this.textColor,
    Key key,
  }) : super(key: key);

  final List<dynamic> children;
  final MainAxisAlignment alignment;
  final CrossAxisAlignment crossAlignment;
  final MainAxisSize axisSize;
  final double textSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final listItems = children.map((e) {
      if (e is Widget) {
        return e;
      } else {
        return "$e"
            .text
            .size(textSize ?? 12)
            .color(textColor ?? Utils.textColorByTheme())
            .make();
      }
    }).toList();
    return HStack(
      !Utils.currencyLeftSided ? listItems.reversed.toList() : listItems,
    );
  }
}
