import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class TopVendorsViewModel extends MyBaseViewModel {
  TopVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.params,
    this.enableFilter = true,
  }) {
    this.viewContext = context;
  }

  //
  List<Vendor> vendors = [];
  final VendorType vendorType;
  final Map<String, dynamic> params;

  int selectedType = 1;
  final bool enableFilter;

  //
  VendorRequest _vendorRequest = VendorRequest();

  //
  initialise() {
    //
    fetchTopVendors();
  }

  //
  fetchTopVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.topVendorsRequest(
        byLocation: AppStrings.enableFatchByLocation,
        params: {
          "vendor_type_id": vendorType.id,
          ...(params != null ? params : {})
        },
      );

      //
      if (enableFilter) {
        if (selectedType == 2) {
          vendors = vendors.filter((e) => e.pickup == 1).toList();
        } else if (selectedType == 1) {
          vendors = vendors.filter((e) => e.delivery == 1).toList();
        }
      }
      clearErrors();
    } catch (error) {
      print("error ==> $error");
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  //
  changeType(int type) {
    selectedType = type;
    fetchTopVendors();
  }

  vendorSelected(Vendor vendor) async {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
