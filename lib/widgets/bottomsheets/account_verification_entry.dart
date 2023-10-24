import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_leading.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountVerificationEntry extends StatefulWidget {
  const AccountVerificationEntry({
    this.onSubmit,
    this.onResendCode,
    this.vm,
    Key key,
    this.phone = "",
  }) : super(key: key);

  final Function(String) onSubmit;
  final Function onResendCode;
  final dynamic vm;
  final String phone;

  @override
  _AccountVerificationEntryState createState() =>
      _AccountVerificationEntryState();
}

class _AccountVerificationEntryState extends State<AccountVerificationEntry> {
  TextEditingController pinTEC = new TextEditingController();

  int maxSecond = 30;
  int currentSecond = 0;

  String smsCode;
  //int resendSecs = 20;
  //int resendSecsIncreamental = 5;
  //int maxResendSeconds = 30;
  bool loading = false;

  Timer _timer;

  void _initializeCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSecond == 0) {
        _timer.cancel();
        _timer = null;
      } else {
        setState(() {
          currentSecond--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentSecond = maxSecond;
    _initializeCountdown();
    //startCountDown();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinWidth = context.percentWidth * 70;
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBarColor: AppColor.primaryColor,
      title: "Verification Code".tr(),
      elevation: 0,
      leading: CustomLeading().onInkTap(() => context.pop()),
      body: VStack([

        "Enter Verification Code".tr().text.bold.xl.make(),

        ("Enter the 6-digit verification code sent to".tr() + " ${widget.phone}")
        .text
        .gray600
        .sm
        .make()
        .py2(),

        PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          textStyle: context.textTheme.bodyLarge.copyWith(fontSize: 16),
          controller: pinTEC,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            fieldHeight: 50,
            fieldWidth: pinWidth / 7,
            activeFillColor: AppColor.primaryColor,
            selectedColor: AppColor.primaryColor,
            inactiveColor: AppColor.accentColor,
          ),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: false,
          onCompleted: (pin) {
            if (currentSecond == 0) {
              widget.vm.toastError("Otp is expired. Please try to send again.");
              return;
            }
            smsCode = pin;
            widget.onSubmit(smsCode);
          },
          onChanged: (value) {
            smsCode = value;
          },
        ).w(pinWidth).centered().p12(),

        HStack([

          CustomOutlineButton(
            loading: loading,
            title: currentSecond > 0
            ? ("Resend in".tr() + " $currentSecond " + "sec".tr())
            : ("Resend".tr()),
            titleStyle: context.textTheme.bodyLarge.copyWith(
              color: currentSecond <= 0
              ? Utils.textColorByTheme()
              : Colors.grey.shade500,
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
            onPressed: currentSecond > 0 ? null : () => _onResendOtp(),
          ).expand(),

          UiSpacer.hSpace(10),

          CustomOutlineButton(
            title: "Edit Phone No.".tr(),
            titleStyle: context.textTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Utils.textColorByTheme(),
            ),
            onPressed: () => context.pop(),
          ).expand(),

        ]),

        CustomButton(
          title: "Verify".tr(),
          loading: loading || widget.vm.busy(widget.vm.otpLogin) || widget.vm.isBusy,
          onPressed: () async {
            if (smsCode == null || smsCode.length != 6) {
              widget.vm.toastError("Verification code required".tr());
            } else if (currentSecond == 0) {
              widget.vm.toastError("Otp is expired. Please try to send again.");
            } else {
              setState(() {
                loading = true;
              });
              await widget.onSubmit(smsCode);
              setState(() {
                loading = false;
              });
            }
          },
        ).wFull(context).py12(),

        // Visibility(
        //   visible: currentSecond == 0,
        //     child: HStack([
        //
        //       "Didn't receive the code?".tr().text.make(),
        //
        //       Visibility(
        //         visible: currentSecond > 0,
        //         child: "($currentSecond)"
        //         .text
        //         .bold
        //         .color(AppColor.primaryColorDark)
        //         .make()
        //         .px4(),
        //       ),
        //
        //       Visibility(
        //         visible: currentSecond == 0,
        //         child: CustomTextButton(
        //           loading: loading,
        //           title: "Resend".tr(),
        //           onPressed: () async => _onResendOtp(),
        //           ),
        //         ),
        //       ],
        //       crossAlignment: CrossAxisAlignment.center,
        //       alignment: MainAxisAlignment.center,
        //     ).py12(),
        //   ),

        ],
      ).p20().hFull(context),
    );
  }

  Future<void> _onResendOtp() async {
    pinTEC.clear();
    setState(() {
      loading = true;
    });
    await widget.vm.processFirebaseOTPVerification(true);
    setState(() {
      loading = false;
      currentSecond = maxSecond;
    });
    _initializeCountdown();
  }
}

class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
          () => 'Your code is 54321',
    );
  }
}
