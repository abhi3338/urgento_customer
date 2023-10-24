import 'dart:convert';
import 'dart:developer';

import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/banner.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class BannerRequest extends HttpService {
  //
  Future<List<Banner>> banners({
    bool byLocation = false,
    int vendorTypeId,
    Map params,
  }) async {
    final apiResult = await get(
      Api.banners,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
        ...(params != null ? params : {}),

        "latitude": LocationService?.currenctAddress?.coordinates?.latitude,
        "longitude": LocationService?.currenctAddress?.coordinates?.longitude
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    log("banner response======>>>>>>>${apiResponse.body}");
    log("banner response======>>>>>>>${vendorTypeId}");
    log("banner response======>>>>>>>${   LocationService?.currenctAddress?.coordinates?.latitude}");
    log("banner response======>>>>>>>${  LocationService?.currenctAddress?.coordinates?.longitude }");

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Banner.fromJSON(jsonObject))
          .toList();
    } else {
      throw apiResponse.message;
    }
  }
}
