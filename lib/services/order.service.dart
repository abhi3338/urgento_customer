import 'dart:async';
import 'dart:convert';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/order.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';


class OrderService {
  //

//Hnadle background message
  static Future<dynamic> openOrderPayment(Order order, dynamic vm) async {
    //
    print("paymentMethod is123===>>>>${order?.paymentMethod?.name}");

    if ((order?.paymentMethod?.slug ?? "offline") != "offline") {
      return vm.openWebpageLink(order.paymentLink);
    }
    if ((order?.paymentMethod?.slug ?? "razorpay") != "razorpay") {
      return MyApp();
    }


    else {
      return vm.openExternalWebpageLink(order.paymentLink);
    }
  }
}
