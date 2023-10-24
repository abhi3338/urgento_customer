import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/services/social_media_login.service.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_register.view_model.dart';
import 'package:fuodz/view_models/register.view_model.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewRegisterView extends StatefulWidget {

  final String phoneNo;
  final Country country;

  const NewRegisterView({Key key, this.phoneNo = '', this.country}) : super(key: key);

  @override
  State<NewRegisterView> createState() => _NewRegisterViewState();
}

class _NewRegisterViewState extends State<NewRegisterView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewRegisterViewModel>.reactive(
      viewModelBuilder: () => NewRegisterViewModel(context),
      onModelReady: (model) {
        model.phoneTEC.text = widget.phoneNo;
        model.selectedCountry = widget.country;
        model.initialise();
      },
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          appBarColor: Colors.transparent,
          actions: [],
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              FlutterIcons.arrow_left_fea,
              color: AppColor.primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
              child: VStack(
                [
                  Image.asset(
                    AppImages.onboarding2,
                  ).hOneForth(context).centered(),
                  //
                  VStack(
                    [
                      //
                      "Join Us".tr().text.xl2.semiBold.make(),
                      "Create an account now".tr().text.light.make(),

                      //form
                      Form(
                        key: model.formKey,
                        child: VStack(
                          [
                            //
                            CustomTextFormField(
                              labelText: "Name".tr(),
                              textEditingController: model.nameTEC,
                              validator: FormValidator.validateName,
                            ).py12(),
                            //
                            CustomTextFormField(
                              labelText: "Email".tr(),
                              isReadOnly: true,
                              onTap: () => SocialMediaLoginService().newGoogleLogin(model),
                              keyboardType: TextInputType.emailAddress,
                              textEditingController: model.emailTEC,
                              validator: FormValidator.validateEmail,
                            ).py12()
                            ,
                            //
                            HStack(
                              [
                                CustomTextFormField(
                                  prefixIcon: HStack(
                                    [
                                      //icon/flag
                                      Flag.fromString(
                                        model.selectedCountry.countryCode,
                                        width: 20,
                                        height: 20,
                                      ),
                                      UiSpacer.horizontalSpace(space: 5),
                                      //text
                                      ("+" + model.selectedCountry.phoneCode)
                                          .text
                                          .make(),
                                    ],
                                  ).px8().onInkTap(model.showCountryDialPicker),
                                  labelText: "Phone".tr(),
                                  hintText: "",
                                  keyboardType: TextInputType.phone,
                                  textEditingController: model.phoneTEC,
                                  validator: FormValidator.validatePhone,
                                ).expand(),
                              ],
                            ).py12(),


                            AppStrings.enableReferSystem
                            ? CustomTextFormField(
                              labelText: "Referral Code(optional)".tr(),
                              textEditingController: model.referralCodeTEC,
                            )
                            .py12()
                            : UiSpacer.emptySpace(),
                            //
                            

                            

                            //
                            CustomButton(
                              title: "Create Account".tr(),
                              loading: model.isBusy,
                              onPressed: model.finishAccountRegistration,
                            ).centered().py12(),

                            // //register
                            // "OR".tr().text.light.makeCentered(),
                            // CustomButton(
                            //   title: "Already have an Account".tr(),

                            //   onPressed: model.openLogin,
                            // ).centered().py12(),

                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                      ).py20(),
                    ],
                  ).wFull(context).p20(),

                  //
                ],
              ).scrollVertical(),
            ),
          ),
        );
      },
    );
  }
}