import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppUISizes {
  //
  static const double taxiNewOrderIdleHeight = 250;
  static const double taxiNewOrderHistoryHeight = 150;
  static const double taxiNewOrderSummaryHeight = 400;

  static double getAspectRatio(BuildContext context, int rows, double height) {
    double width = context.screenWidth / rows;
    return height / width;
  }
}
