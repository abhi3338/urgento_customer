import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/driver.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/tax_order_location.history.dart';
import 'package:fuodz/models/vehicle.dart';
import 'package:fuodz/models/vehicle_type.dart';
import 'package:fuodz/services/http.service.dart';

class TaxiRequest extends HttpService {
  //
  Future<List<VehicleType>> getVehicleTypes() async {
    final apiResult = await get("${Api.vehicleTypes}");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((object) => VehicleType.fromJson(object))
          .toList();
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<List<VehicleType>> getVehicleTypePricing(
    DeliveryAddress pickup,
    DeliveryAddress dropoff, {
    String countryCode,
  }) async {
    //
    print("countryCode ==> $countryCode");
    //
    final apiResult = await get(
      "${Api.vehicleTypePricing}",
      queryParameters: {
        "pickup": "${pickup.latitude},${pickup.longitude}",
        "dropoff": "${dropoff.latitude},${dropoff.longitude}",
        "country_code": "$countryCode",
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((object) => VehicleType.fromJson(object))
          .toList();
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> locationAvailable(
    double latitude,
    double longitude,
  ) async {
    final apiResult = await get(
      Api.taxiLocationAvailable,
      queryParameters: {
        "latitude": latitude,
        "longitude": longitude,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> placeNeworder({Map<String, dynamic> params}) async {
    final apiResult = await post(
      "${Api.newTaxiBooking}",
      params,
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<Order> getOnGoingTrip() async {
    final apiResult = await get(
      "${Api.currentTaxiBooking}",
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    //
    if (apiResponse.allGood) {
      //if there is order
      if (apiResponse.body["order"] != null) {
        return Order.fromJson(apiResponse.body["order"]);
      } else {
        return null;
      }
    }

    //
    throw apiResponse.body;
  }

  //
  Future<ApiResponse> cancelTrip(int id) async {
    final apiResult = await get(
      "${Api.cancelTaxiBooking}/$id",
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<Driver> getDriverInfo(int id) async {
    final apiResult = await get(
      "${Api.taxiDriverInfo}/$id",
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    final driver = Driver.fromJson(apiResponse.body["driver"]);
    driver.vehicle = Vehicle.fromJson(apiResponse.body["vehicle"]);
    return driver;
  }

  Future<ApiResponse> rateDriver(
    int orderId,
    int driverId,
    double newTripRating,
    String review,
  ) async {
    //
    final apiResult = await post(
      "${Api.rating}",
      {
        //
        "driver_id": driverId,
        "order_id": orderId,
        "rating": newTripRating,
        "review": review,
      },
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<TaxiOrderLocationHistory>> locationHistory() async {
    final apiResult = await get(Api.taxiTripLocationHistory);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    return (apiResponse.body as List)
        .map((e) => TaxiOrderLocationHistory.fromJson(e))
        .toList();
  }
}
