import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/services/http.service.dart';

class OrderRequest extends HttpService {
  //
  Future<List<Order>> getOrders(
      {int page = 1, Map<String, dynamic> params}) async {
    final apiResult = await get(
      Api.orders,
      queryParameters: {
        "page": page,
        ...(params != null ? params : {}),
      },
    );

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return Order.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> getOrderDetails({@required int id}) async {
    final apiResult = await get(Api.orders + "/$id");
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<String> updateOrder({int id, String status, String reason}) async {
    final apiResult = await patch(Api.orders + "/$id", {
      "status": status,
      "reason": reason,
    });
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.message;
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> trackOrder(String code, {int vendorTypeId}) async {
    //
    final apiResult = await post(
      Api.trackOrder,
      {
        "code": code,
        "vendor_type_id": vendorTypeId,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> updateOrderPaymentMethod({
    int id,
    int paymentMethodId,
    String status,
  }) async {
    //
    final apiResult = await patch(
      Api.orders + "/$id",
      {
        "payment_method_id": paymentMethodId,
        "payment_status": status,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message;
    }
  }
}
