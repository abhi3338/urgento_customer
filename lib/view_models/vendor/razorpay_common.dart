import 'dart:convert';
import 'package:fuodz/razor_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayData{
  final _razorpay = Razorpay();
  double finalAmount;
  bool isRazorpayLoading = false;

  void createOrder(double amounts) async {
    finalAmount = amounts * 100;
    isRazorpayLoading = true;
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> body = {
      "amount": finalAmount,
      "currency": "INR",
      "receipt": 'fyu'
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      isRazorpayLoading = false;
      openGateway(jsonDecode(res.body)['id']);
    }else{
      isRazorpayLoading = false;
    }
    print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': finalAmount, //in the smallest currency sub-unit.
      'name': 'Urgento',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'powered by a work connect private limited',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': '9123456789',
        'email': 'ary@example.com',
      },
      'theme.color':'#000000'
    };
    _razorpay.open(options);
  }
}