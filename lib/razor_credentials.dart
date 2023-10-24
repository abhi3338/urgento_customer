import 'package:fuodz/constants/api.dart';
import 'package:http/http.dart'as http;

const String keyId = "rzp_live_sJTyptGfZaJtcc";
//const String keyId = "rzp_test_Besj6dawjm7mXt";
const String keySecret = "ILdIkyemdGdImvFwFZciV2WE";
//const String keySecret = "tiTHwS3naW75jjZa84v086k9";

// for create new order
int orderId = 0;

// for orderpage
int orderPageOrderId = 0;

// for orderDetailPage
int orderdetailPageOrderId = 0;

//  for walletUpdatePage
int userId = 0;
double Wallamount = 0.0;

// for recent order in send parcel
int recentUserId = 0;

// for sendParcel
int parcelOrderId = 0;

//for servicebooking
int serviceBookingId = 0;

//for taxibooking
int taxiBookingId = 0;





Future UpdateOrderStatus({id}) async{

  var request = http.Request('POST', Uri.parse('${Api.baseUrl}/updateOrderStatus?id=$id'));

  // final response = await request.send();
  // final respStr = await response.stream.bytesToString();
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  print("response===>>>>${response}");

  if (response.statusCode == 200) {
    print(response.body);
  }
  else {
    print(response.reasonPhrase);
  }
}

Future UpdateWalletBalance({userId,amount,isSuccess}) async{

  var request = http.Request('POST', Uri.parse('${Api.baseUrl}/updateWalletAmount?userId=$userId&amount=$amount&isSucess=$isSuccess'));

  // final response = await request.send();
  // final respStr = await response.stream.bytesToString();
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  print("update wallet response===>>>>${response}");

  if (response.statusCode == 200) {
    print(response.body);
  }
  else {
    print(response.reasonPhrase);
  }
}