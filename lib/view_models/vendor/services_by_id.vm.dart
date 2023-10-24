import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/category.request.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/service/service_details.page.dart';
import 'package:velocity_x/velocity_x.dart';

class ServicesByIdViewModel extends MyBaseViewModel {

  ServicesByIdViewModel(BuildContext context, VendorType vendorType) {
    this.viewContext = context;
    this.vendorType = vendorType;
    this.CatId = CatId;
  }

  List<Service> servicesDataList = [];
  VendorType vendorType;
  int CatId;


  initialise({bool all = false}) async {
    setBusy(true);
    try {
      SearchRequest searchRequest = SearchRequest();
      // Use CatId to set the id for the Category object
      Search search = Search(
        type: "service",
        category: Category(id: this.CatId), // Use this.CatId as the id
        vendorType: this.vendorType,
        viewType: SearchType.services,
      );
      search.byLocation = true;
      servicesDataList =
          (await searchRequest.searchRequest(type: "service", search: search))
              .cast<Service>();
      clearErrors();
    } catch (error) {
      print("categories.vm.dart: ${error}");
      setError(error);
    }
    setBusy(false);
  }

  serviceSelected(Service service) {
    viewContext.push(
          (context) => ServiceDetailsPage(service),
    );
  }
}