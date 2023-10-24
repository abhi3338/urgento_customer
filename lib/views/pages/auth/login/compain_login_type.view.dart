import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/views/pages/auth/login/email_login.view.dart';
import 'package:fuodz/views/pages/auth/login/otp_login.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CombinedLoginTypeView extends StatefulWidget {
  const CombinedLoginTypeView(this.model, {Key key}) : super(key: key);

  final LoginViewModel model;

  @override
  State<CombinedLoginTypeView> createState() => _CombinedLoginTypeViewState();
}

class _CombinedLoginTypeViewState extends State<CombinedLoginTypeView> {
  bool useOTP = true;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        UiSpacer.vSpace(),
        CustomSlidingSegmentedControl<int>(
          isStretch: true,
          initialValue: 1,
          children: {
            1: Text("Phone Number".tr()),
            2: Text("Email Address".tr()),
          },
          decoration: BoxDecoration(
            color: context.theme.colorScheme.background,
            borderRadius: BorderRadius.circular(25),
            border: Border.fromBorderSide(
              BorderSide(
                color: AppColor.primaryColor,
                width: 1.5,
              ),
            ),
          ),
          thumbDecoration: BoxDecoration(
            color: context.theme.colorScheme.background,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 5.0,
                spreadRadius: 1.5,
                offset: Offset(
                  0.0,
                  2.0,
                ),
              ),
            ],
          ),
          duration: Duration(milliseconds: 300),
          highlightColor: Colors.red,
          splashColor: Colors.green,
          curve: Curves.easeInToLinear,
          onValueChanged: (value) {
            setState(() {
              useOTP = value == 1;
            });
          },
        ).centered(),
        //
        useOTP ? OTPLoginView(widget.model) : EmailLoginView(widget.model),
      ],
    );
  }
}
