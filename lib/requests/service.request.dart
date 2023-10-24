import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class ServiceRequest extends HttpService {
  //
  Future<List<Service>> getServices({
    Map<String, dynamic> queryParams,
    int page = 1,
    bool byLocation = false,
  }) async {
    final apiResult = await get(
      Api.services,
      queryParameters: {
        ...(queryParams != null ? queryParams : {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      if (page == null || page == 0) {
        return (apiResponse.body as List)
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      } else {
        return apiResponse.data
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      }
    }

    throw apiResponse.message;
  }

  //
  Future<Service> serviceDetails(int id) async {
    //
    final apiResult = await get("${Api.services}/$id");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Service.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }
}
