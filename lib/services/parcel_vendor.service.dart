import 'package:fuodz/models/order_stop.dart';
import 'package:fuodz/models/vendor.dart';

class ParcelVendorService {
  static bool canServiceAllLocations(List<OrderStop> stops, Vendor vendor) {
    bool allowed = true;
    for (var stop in stops) {
      allowed = vendor.canServiceLocation(stop.deliveryAddress);
      if (!allowed) {
        break;
      }
    }
    return allowed;
  }
}
