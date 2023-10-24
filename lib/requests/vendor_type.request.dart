import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class VendorTypeRequest extends HttpService {
  //
  Future<List<VendorType>> index() async {

    //String apiUrl = Api.vendorTypes+"?latitude=18.7900&longitude=78.2881";
    String apiUrl = Api.vendorTypes+"?latitude=${LocationService?.currenctAddress?.coordinates?.latitude}&longitude=${LocationService?.currenctAddress?.coordinates?.longitude}";
    print("apiUrlsdsdsd ==> ${apiUrl}");
    final apiResult = await get(apiUrl);
    //final apiResult = await get(Api.vendorTypes);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      print("apiResponse.body as List ==> ${apiResponse.body as List}");
      return (apiResponse.body as List) .map((e) => VendorType.fromJson(e)).toList();
    }

    throw apiResponse.message;
  }
}
