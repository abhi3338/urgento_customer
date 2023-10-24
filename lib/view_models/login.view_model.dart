import 'dart:developer';
import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/social_media_login.service.dart';
import 'package:fuodz/traits/qrcode_scanner.trait.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/views/pages/auth/new_ui_login/new_register.page.dart';
import 'package:fuodz/views/pages/auth/new_ui_login/otp_verification.view.dart';
import 'package:fuodz/views/pages/auth/register.page.dart';
import 'package:fuodz/widgets/bottomsheets/account_verification_entry.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginViewModel extends MyBaseViewModel with QrcodeScannerTrait {
  //the textediting controllers
  TextEditingController phoneTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  //
  AuthRequest authRequest = AuthRequest();
  SocialMediaLoginService socialMediaLoginService = SocialMediaLoginService();
  bool otpLogin = AppStrings.enableOTPLogin;
  Country selectedCountry;
  String accountPhoneNumber;
  ProfileViewModel profileViewModel;

  LoginViewModel(BuildContext context) {
    this.viewContext = context;
    this.profileViewModel = new ProfileViewModel(context);
    this.profileViewModel.initialise();
  }

  void initialise() {
    //
    emailTEC.text = kReleaseMode ? "" : "client@demo.com";
    passwordTEC.text = kReleaseMode ? "" : "password";

    //phone login
    try {
      this.selectedCountry = Country.parse(AppStrings.countryCode
          .toUpperCase()
          .replaceAll("AUTO,", "")
          .split(",")[0]);
    } catch (error) {
      this.selectedCountry = Country.parse("us");
    }
  }

  toggleLoginType() {
    otpLogin = !otpLogin;
    notifyListeners();
  }
  void callup() {
    launchUrlString("tel:${AppStrings.emergencyContact}");
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

  String temporaryValue = "";

  void processOTPLogin() async {
    //
    accountPhoneNumber = "+${selectedCountry.phoneCode}${phoneTEC.text}";
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState.validate()) {
      //
      if (AppStrings.isFirebaseOtp) {
        processFirebaseOTPVerification();
      } else {
        processCustomOTPVerification();
      }
    }
  }

  int resendToken;

  void onVerificationCompleted(PhoneAuthCredential credential) async {
    print("verificationCompleted ==>  Yes");
    print("SmsCode: ${credential.smsCode}");
    _firebaseOTP.value = credential.smsCode.toString();
    notifyListeners();
  }

  //PROCESSING VERIFICATION
  processFirebaseOTPVerification([bool isOtpVerificationScreen = false]) async {
    setBusyForObject(otpLogin, true);



    //7600249118

    //firebase authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: accountPhoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: onVerificationCompleted,
      //autoRetrievedSmsCodeForTesting: "123456",
      verificationFailed: (FirebaseAuthException e) {
        log("Error message ==> ${e.message}");
        if (e.code == 'invalid-phone-number') {
          viewContext.showToast(
              msg: "Invalid Phone Number".tr(), bgColor: Colors.red);
        } else {
          viewContext.showToast(msg: e.message, bgColor: Colors.red);
        }
        //
        setBusyForObject(otpLogin, false);
      },
      codeSent: (String verificationId, int resendToken) async {
        firebaseVerificationId = verificationId;
        this.resendToken = resendToken;
        print("codeSent ==>  $firebaseVerificationId");

        if (!isOtpVerificationScreen) {
          showVerificationEntry(isOtpVerificationScreen);
        }
        setBusyForObject(otpLogin, false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout called");
      },
    );
  }

  processCustomOTPVerification() async {
    setBusyForObject(otpLogin, true);
    try {
      await authRequest.sendOTP(accountPhoneNumber);
      setBusyForObject(otpLogin, false);
      showVerificationEntry();
    } catch (error) {
      setBusyForObject(otpLogin, false);
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
  }

  Future<void> firebaseOtpVerification() async {
    
  }

  ValueNotifier<String> _firebaseOTP = ValueNotifier<String>('');

  //
  void showVerificationEntry([bool isOptVerificationScreen]) async {
    //
    setBusy(false);
    //

    if (!isOptVerificationScreen) {
      await viewContext.push(
        (context) => AccountVerificationEntry(
          vm: this,
          phone: accountPhoneNumber,
          onResendCode: () async {
            processFirebaseOTPVerification();
          },
          onSubmit: (smsCode) async {
            if (AppStrings.isFirebaseOtp) {
              await verifyFirebaseOTP(smsCode);
            } else {
              verifyCustomOTP(smsCode);
            }
          },
        ),
      );
    }
  }

  //
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(otpLogin, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId,
        smsCode: smsCode,
      );

      //
      await finishOTPLogin(phoneAuthCredential);
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(otpLogin, false);
  }

  void verifyCustomOTP(String smsCode) async {
    //
    setBusy(true);
    // Sign the user in (or link) with the credential
    try {
      final apiResponse = await authRequest.verifyOTP(
        accountPhoneNumber,
        smsCode,
        isLogin: true,
      );

      print("ApiResponse: ${apiResponse.message}");
      print("ApiResponse: ${apiResponse.allGood}");
      print("ApiResponse: ${apiResponse.body}");
      print("ApiResponse: ${apiResponse.code}");
      print("ApiResponse: ${apiResponse.errors}");

      //
      await handleDeviceLogin(apiResponse);
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusy(false);
  }

  //Login to with firebase token
  finishOTPLogin(AuthCredential authCredential) async {
    //
    setBusyForObject(otpLogin, true);
    // Sign the user in (or link) with the credential
    try {
      //
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );

      print("UserCredentials: ${userCredential}");
      //
      String firebaseToken = await userCredential.user.getIdToken();
      final apiResponse = await authRequest.verifyFirebaseToken(
        accountPhoneNumber,
        firebaseToken,
      );
      
      //
      await handleDeviceLogin(apiResponse);
    } on FirebaseAuthException catch (e) {
      viewContext.showToast(msg: "${e.message}", bgColor: Colors.red);
    } catch (error) {
      //viewContext.showToast(msg: "$error", bgColor: Colors.red);
      openRegister(phone: accountPhoneNumber);
    }
    //
    setBusyForObject(otpLogin, false);
  }

  //REGULAR LOGIN
  void processLogin() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState.validate()) {
      //

      setBusy(true);

      final apiResponse = await authRequest.loginRequest(
        email: emailTEC.text,
        password: passwordTEC.text,
      );

      //
      await handleDeviceLogin(apiResponse);

      setBusy(false);
    }
  }

  //QRCode login
  void initateQrcodeLogin() async {
    //
    final loginCode = await openScanner(viewContext);
    if (loginCode == null) {
      toastError("Operation failed/cancelled".tr());
    } else {
      setBusy(true);

      try {
        final apiResponse = await authRequest.qrLoginRequest(
          code: loginCode,
        );
        //
        await handleDeviceLogin(apiResponse);
      } catch (error) {
        print("QR Code login error ==> $error");
      }

      setBusy(false);
    }
  }

  ///
  ///
  ///
  handleDeviceLogin(ApiResponse apiResponse) async {
    try {
      if (apiResponse.hasError()) {

        print("API RESPONSE ERROR");
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Login Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
        setBusy(true);
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        setBusy(false);
        //viewContext.pop(true);
        viewContext.navigator.pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      print("API RESPONSE ERROR");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      print("API RESPONSE ERROR");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error}",
      );
    }
  }

  ///

  void openRegister({
    String email,
    String name,
    String phone,
  }) async {
    // viewContext.push(
    //   (context) => RegisterPage(
    //     email: email,
    //     name: name,
    //     phone: phone,
    //   ),
    // );
    viewContext.push(
      (context) => NewRegisterView(phoneNo: phoneTEC.text, country: selectedCountry),
    );
  }

  void openForgotPassword() {
    viewContext.navigator.pushNamed(
      AppRoutes.forgotPasswordRoute,
    );
  }
}
