import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'otp_verification.view.dart';

class NewCombinedLoginTypeView extends StatefulWidget {
  
  final LoginViewModel model;
  
  const NewCombinedLoginTypeView(this.model, {Key key}) : super(key: key);

  @override
  State<NewCombinedLoginTypeView> createState() => _NewCombinedLoginTypeViewState();
}

class _NewCombinedLoginTypeViewState extends State<NewCombinedLoginTypeView> {
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        UiSpacer.vSpace(),

        Form(
          key: widget.model.formKey,
          child: VStack(
            [
              HStack(
                [
                  CustomTextFormField(
                    prefixIcon: HStack(
                      [
                        
                        Flag.fromString(
                          widget.model.selectedCountry.countryCode,
                          width: 20,
                          height: 20,
                        ),
                        
                        UiSpacer.horizontalSpace(space: 5),
                        
                        ("+" + widget.model.selectedCountry.phoneCode).text.make(),

                      ],
                
                    )
                    .px8()
                    .onInkTap(widget.model.showCountryDialPicker),
                    labelText: "Phone".tr(),
                    hintText: "",
                    keyboardType: TextInputType.phone,
                    textEditingController: widget.model.phoneTEC,
                    validator: FormValidator.validatePhone,

                  ).expand()
                ]
              ).py12(),

              CustomButton(
                  title: "Continue".tr(),
                loading: widget.model.busy(widget.model.otpLogin),
                onPressed: widget.model.processOTPLogin,
              )
              .centered()
              .py12(),

            ],
            crossAlignment: CrossAxisAlignment.end,
          ),
        ).py20()
      ]
    );
  }

  
}