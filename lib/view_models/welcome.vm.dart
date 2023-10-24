import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/vendor_type.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fuodz/constants/app_strings.dart';


class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
    this.profileViewModel = new ProfileViewModel(context);
    this.profileViewModel.initialise();



  }

  Widget selectedPage;
  List<VendorType> vendorTypes = [];
  VendorTypeRequest vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;
  StreamSubscription authStateSub;

  ProfileViewModel profileViewModel;

  //
  //
  initialise() async {
    await getVendorTypes();
    listenToAuth();
  }

  listenToAuth() {
    authStateSub = AuthServices.listenToAuthState().listen((event) {
      genKey = GlobalKey();
      notifyListeners();
    });
  }

  void callup() {
    launchUrlString("tel:${AppStrings.emergencyContact}");
  }

  getVendorTypes() async {
    setBusy(true);
    try {
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }


  updateVendorData(){
    setBusy(true);
    Future.delayed(Duration.zero, () async{
      vendorTypes.clear();
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
      setBusy(false);
    });
  }
}
