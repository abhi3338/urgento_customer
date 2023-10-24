import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class SectionVendorsViewModel extends MyBaseViewModel {
  SectionVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.type = SearchFilterType.you,
    this.byLocation = false,
  }) {
    this.viewContext = context;
  }

  //
  List<Vendor> vendors = [];
  VendorType vendorType;
  SearchFilterType type;
  bool byLocation;
  VendorRequest _vendorRequest = VendorRequest();

  //
  initialise() {
    fetchVendors();
  }

  //
  fetchVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: byLocation ?? true,
        params: {
          "vendor_type_id": vendorType?.id,
          "type": type.name,
        },
      );

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  vendorSelected(Vendor vendor) async {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
