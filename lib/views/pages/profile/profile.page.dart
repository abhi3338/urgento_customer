import 'package:flutter/material.dart' hide MenuItem;
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/resources/resources.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/profile.card.dart';
import 'package:fuodz/widgets/menu_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/constants/app_strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return BasePage(
            body: VStack(
              [
                //
                "Settings".tr().text.xl2.semiBold.make(),
                "Profile & App Settings".tr().text.lg.light.make(),

                //profile card
                ProfileCard(model).py12(),

                //menu
                VStack(
                  [
                    //
                    MenuItem(
                      title: "Notifications".tr(),
                      onPressed: model.openNotification,
                      ic: AppIcons.bell,
                    ),

                    //
                    MenuItem(
                      title: "Rate & Review".tr(),
                      onPressed: model.openReviewApp,
                      ic: AppIcons.rating,
                    ),

                    //
                    MenuItem(
                      title: "Faqs".tr(),
                      onPressed: model.openFaqs,
                      ic: AppIcons.compliant,
                    ),
                    //
                    MenuItem(
                      title: "Privacy Policy".tr(),
                      onPressed: model.openPrivacyPolicy,
                      ic: AppIcons.compliant,
                    ),
                    //
                    MenuItem(
                      title: "Terms & Conditions".tr(),
                      onPressed: model.openTerms,
                      ic: AppIcons.termsAndConditions,
                    ),
                    //
                    MenuItem(
                      title: "Contact Us".tr(),
                      onPressed: model.openContactUs,
                      ic: AppIcons.communicate,
                    ),
                    //
                    MenuItem(
                      title: "Live Support".tr(),
                      onPressed: (){

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));



                      },
                      ic: AppIcons.livesupport,
                    ),

                    MenuItem(
                      title: "Whats App Chat".tr(),
                      onPressed: (){
                        launchWhatsApp();




                      },
                      ic: AppIcons.livesupport,
                    ),


                    //
                    MenuItem(
                      title: "Cancellation and refund policy".tr(),
                      onPressed: model.openCancel,
                      ic: AppIcons.shipping,
                    ),
                    //

                    MenuItem(
                      title: "Shipping policy".tr(),
                      onPressed: model.openShipping,
                      ic: AppIcons.shipping,
                    ),
                    //

                    MenuItem(
                      title: "Offers".tr(),
                      onPressed: model.openOffer,
                      ic: AppIcons.offer,
                    ),
                    //

                    MenuItem(
                      title: "Announcements".tr(),
                      onPressed: model.openAnnounce,
                      ic: AppIcons.announcement,
                    ),
                    //

                    MenuItem(
                      title: "Coupon".tr(),
                      onPressed: model.openCoupon,
                      ic: AppIcons.Coupon,
                    ),
                    //
                    MenuItem(
                      title: "Language".tr(),
                      divider: false,
                      ic: AppIcons.translation,
                      onPressed: model.changeLanguage,
                    ),

                    //
                    MenuItem(
                      title: "Version".tr(),
                      suffix: model.appVersionInfo.text.make(),
                    ),
                  ],
                ),

                //
                "Copyright ©%s %s all right reserved"
                    .tr()
                    .fill([
                  "${DateTime.now().year}",
                  AppStrings.companyName,
                ])
                    .text
                    .center
                    .sm
                    .makeCentered()
                    .py20(),
                //
                UiSpacer.verticalSpace(space: context.percentHeight * 10),
              ],
            ).p20().scrollVertical(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}