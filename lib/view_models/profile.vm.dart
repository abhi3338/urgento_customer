import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:custom_faqs/custom_faqs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/view_models/payment.view_model.dart';
import 'package:fuodz/views/pages/loyalty/loyalty_point.page.dart';
import 'package:fuodz/views/pages/profile/account_delete.page.dart';
import 'package:fuodz/views/pages/splash.page.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/bottomsheets/referral.bottomsheet.dart';
import 'package:fuodz/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:velocity_x/velocity_x.dart';
/*import 'package:share/share.dart';*/
import 'package:fuodz/constants/app_images.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ProfileViewModel extends PaymentViewModel {
  //
  String appVersionInfo = "";
  bool authenticated = false;
  User currentUser;

  //
  AuthRequest _authRequest = AuthRequest();
  StreamSubscription authStateListenerStream;

  ProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Future<void> initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    authenticated = await AuthServices.authenticated();
    if (authenticated) {
      currentUser = await AuthServices.getCurrentUser(force: true);
    } else {
      listenToAuthChange();
    }
    notifyListeners();
  }

  dispose() {
    super.dispose();
    authStateListenerStream?.cancel();
  }

  listenToAuthChange() {
    authStateListenerStream?.cancel();
    authStateListenerStream =
        AuthServices.listenToAuthState().listen((event) async {
      if (event != null && event) {
        authenticated = event;
        currentUser = await AuthServices.getCurrentUser(force: true);
        notifyListeners();
        authStateListenerStream?.cancel();
      }
    });
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    final result = await viewContext.navigator.pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result) {
      initialise();
    }
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    viewContext.navigator.pushNamed(
      AppRoutes.changePasswordRoute,
    );
  }

//
  openRefer() async {
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReferralBottomsheet(this),
    );
  }

  //
  openLoyaltyPoint() {
    viewContext.nextPage(LoyaltyPointPage());
  }

  openWallet() {
    viewContext.navigator.pushNamed(AppRoutes.walletRoute);
  }

  /**
   * Delivery addresses
   */
  openDeliveryAddresses() {
    viewContext.navigator.pushNamed(
      AppRoutes.deliveryAddressesRoute,
    );
  }

  //
  openFavourites() {
    viewContext.navigator.pushNamed(
      AppRoutes.favouritesRoute,
    );
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        viewContext.pop();
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    viewContext.pop();

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Logout".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      viewContext.navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openNotification() async {
    viewContext.navigator.pushNamed(
      AppRoutes.notificationsRoute,
    );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  openFaqs() {
    viewContext.nextPage(
      CustomFaqPage(
        title: 'Faqs'.tr(),
        link: Api.baseUrl + Api.faqs,
      ),
    );
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    openWebpageLink(url);
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    showModalBottomSheet(
      context: viewContext,
      builder: (context) {
        return AppLanguageSelector();
      },
    );
  }

  openLogin() async {
    await viewContext.navigator.pushNamed(
      AppRoutes.loginRoute,
    );
    //
    initialise();
  }

  openShipping() async {
    final url = Api.shipping;
    openWebpageLink(url);
  }

  openCancel() async {
    final url = Api.cancel;
    openWebpageLink(url);
  }

  openOffer() async {
    final url = Api.offers;
    openWebpageLink(url);
  }

  openAnnounce() async {
    final url = Api.Announcements;
    openWebpageLink(url);
  }

  openCoupon() async {
    final url = Api.Coupon;
    openWebpageLink(url);
  }

/*
  void shareReferralCode() {
    Share.share(
      "%s is inviting you to join %s via this referral code: %s just enter it while registering account on urgento app, you will get upto  %s 60 off , free delivery,cashback and get a chance to win movie tickets or exciting gifts. and i will get %s when u make first order so please download Urgento app from below links.".tr().fill(
            [
              currentUser.name,
              AppStrings.appName,
              currentUser.code,
              "${AppStrings.currencySymbol}",
              "${AppStrings.currencySymbol} ${AppStrings.referAmount}",
            ],
          ) +
          "\n" +
          AppStrings.androidDownloadLink +
          "\n" +
          AppStrings.iOSDownloadLink +
          "\n",
    );
  }*/




  void shareReferralCode() async{

    final bytes = await rootBundle.load('${AppImages.share}');
    final list = bytes.buffer.asUint8List();
    final tempDir  = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/icon.png');
    if (!file.existsSync()) {
      await file.create(recursive: true);
      //file.writeAsStringSync("test for share documents file");
      file.writeAsBytes(list);
    }
    Share.shareXFiles(<XFile>[XFile(file.path)], text: "%s is inviting you to join %s via this referral code: %s just enter it while registering account on urgento app, you will get upto  %s 60 off , free delivery,cashback and get a chance to win movie tickets or exciting gifts. and i will get %s when u make first order so please download Urgento app from below links.".tr().fill(
          [
            currentUser.name,
            AppStrings.appName,
            currentUser.code,
            "${AppStrings.currencySymbol}",
            "${AppStrings.currencySymbol} ${AppStrings.referAmount}",
          ],
        ) +
            "\n" +
            AppStrings.androidDownloadLink +
            "\n" +
            AppStrings.iOSDownloadLink +
            "\n", );
    // await Share.shareFiles(['${file.path}'], text: "%s is inviting you to join %s via this referral code: %s just enter it while registering account on urgento app, you will get upto  %s 60 off , free delivery,cashback and get a chance to win movie tickets or exciting gifts. and i will get %s when u make first order so please download Urgento app from below links.".tr().fill(
    //   [
    //     currentUser.name,
    //     AppStrings.appName,
    //     currentUser.code,
    //     "${AppStrings.currencySymbol}",
    //     "${AppStrings.currencySymbol} ${AppStrings.referAmount}",
    //   ],
    // ) +
    //     "\n" +
    //     AppStrings.androidDownloadLink +
    //     "\n" +
    //     AppStrings.iOSDownloadLink +
    //     "\n",);
  }



  //
  deleteAccount() {
    viewContext.nextPage(AccountDeletePage());
  }
}
