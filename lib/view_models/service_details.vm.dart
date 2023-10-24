import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/requests/service.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/auth/login.page.dart';
import 'package:fuodz/views/pages/auth/new_ui_login/new_login.view.dart';
import 'package:fuodz/views/pages/service/service_booking_summary.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/constants/app_strings.dart';

class ServiceDetailsViewModel extends MyBaseViewModel {
  //
  ServiceDetailsViewModel(BuildContext context, this.service) {
    this.viewContext = context;
  }

  //
  ServiceRequest serviceRequest = ServiceRequest();
  Service service;
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;

  void getServiceDetails() async {
    //
    setBusyForObject(service, true);

    try {
      final oldProductHeroTag = service.heroTag;
      service = await serviceRequest.serviceDetails(service.id);
      service.heroTag = oldProductHeroTag;

      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(service, false);
  }

  //
  void openVendorPage() {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: service.vendor,
    );
  }

  bookService() async {
    if (!AuthServices.authenticated()) {
      // final result = await viewContext.push(
      //   (context) => LoginPage(),
      // );

      final result = await viewContext.push(
            (context) => NewUILogin(),
      );
      //
      if (result == null || !(result is bool)) {
        return;
      }
    }

    viewContext.push(
          (context) => ServiceBookingSummaryPage(service),
    );
  }
}
