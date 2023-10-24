import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/views/pages/auth/login/compain_login_type.view.dart';
import 'package:fuodz/views/pages/auth/login/email_login.view.dart';
import 'package:fuodz/views/pages/auth/login/social_media.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login/scan_login.view.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.required = false, Key key}) : super(key: key);

  final bool required;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (widget.required) {
              context.pop();
            }
            return true;
          },
          child: BasePage(
            showLeadingAction: !widget.required,
            showAppBar: !widget.required,
            appBarColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                FlutterIcons.arrow_left_fea,
                color: AppColor.primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            isLoading: model.isBusy,
            body: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                child: VStack(
                  [
                    //
                    VStack(
                      [
                        //
                        HStack(
                          [
                            VStack(
                              [
                                "Welcome Back".tr().text.xl2.semiBold.make(),
                                "Login to continue".tr().text.light.make(),
                              ],
                            ).expand(),
                            Image.asset(
                              AppImages.appLogo,
                            )
                                .h(60)
                                .w(60)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                          ],
                        ),

                        //LOGIN Section
                        AppStrings.enableOTPLogin
                            ? CombinedLoginTypeView(model)
                            : EmailLoginView(model),

                        HStack(
                          [
                            UiSpacer.divider().expand(),
                            "OR".tr().text.light.make().px8(),
                            UiSpacer.divider().expand(),
                          ],
                        ),

                        "New user?".tr().text.light.makeCentered(),
                        UiSpacer.verticalSpace(),
                        CustomButton(
                          title: "Create An Account".tr(),
                          onPressed: model.openRegister,
                        )
                      ],
                    ).wFull(context).px20().pOnly(top: Vx.dp20),
                    //
                    //register
                    HStack(
                      [
                        UiSpacer.divider().expand(),
                        "OR".tr().text.light.make().px8(),
                        UiSpacer.divider().expand(),
                      ],
                    ).py8().px20(),
                    UiSpacer.verticalSpace(),
                    SocialMediaView(model, bottomPadding: 10),
                    ScanLoginView(model),
                  ],
                ).scrollVertical(),
              ),
            ),
          ),
        );
      },
    );
  }
}
