import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class NewRegisterViewModel extends MyBaseViewModel {
  
  AuthRequest _authRequest = new AuthRequest();

  TextEditingController nameTEC = new TextEditingController(text: !kReleaseMode ? "John Doe" : "");
  TextEditingController emailTEC = new TextEditingController(text: !kReleaseMode ? "john@mail.com" : "");
  TextEditingController phoneTEC = new TextEditingController(text: !kReleaseMode ? "557484181" : "");
  TextEditingController referralCodeTEC = new TextEditingController();

  Country selectedCountry;

  NewRegisterViewModel(BuildContext context) {
    this.viewContext = context;
    try {
      this.selectedCountry = Country.parse(AppStrings.countryCode.toUpperCase().replaceAll("AUTO,", "").split(",")[0]);
    } catch (error) {
      this.selectedCountry = Country.parse("us");
    }
  }

  showCountryDialPicker() {
    showCountryPicker(
      context: viewContext,
      showPhoneCode: true,
      onSelect: countryCodeSelected,
    );
  }

  countryCodeSelected(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  void finishAccountRegistration() async {
    setBusy(true);

    final apiResponse = await _authRequest.registerRequest(
      name: nameTEC.text,
      email: emailTEC.text,
      phone: "+${selectedCountry.phoneCode}${phoneTEC.text}",
      countryCode: selectedCountry.countryCode,
      password: "",
      code: referralCodeTEC.text,
    );

    setBusy(false);

    try {
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Registration Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        viewContext.navigator.pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error['message'] ?? error}",
      );
    }
  }
}
