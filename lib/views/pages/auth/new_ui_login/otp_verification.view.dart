import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:velocity_x/velocity_x.dart';

class OtpVerificationView extends StatefulWidget {

  final LoginViewModel loginModel;
  final String codeSentId;
  final String autoReadOtp;

  OtpVerificationView(this.loginModel, {Key key, @required this.codeSentId, @required this.autoReadOtp}) : super(key: key);

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {

  final pinTEC = new TextEditingController();

  @override
  void dispose() {
    pinTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("HELLO BROTHER");
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBarColor: Colors.transparent,
      elevation: 0,
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
                AppImages.otpImage
              )
              .h(240.0)
              .w(240.0),

              SizedBox().h(8.0),

              "OTP Verification".tr().text.xl2.semiBold.make(),

              SizedBox().h(8.0),

              Text.rich(
                TextSpan(
                  text: "Enter OTP Code sent to ",
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB6BACA)
                  ),
                  children: [
                    TextSpan(
                      text: widget.loginModel.accountPhoneNumber,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      )
                    )
                  ]
                )
              ),

              SizedBox().h(32.0),

              PinCodeTextField(
                appContext: context,
                length: 6,
                autoDismissKeyboard: true,
                autoFocus: true,
                enablePinAutofill: true,
                obscureText: false,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                textStyle: context.textTheme.bodyLarge.copyWith(fontSize: 16),
                controller: pinTEC,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 45,
                  borderRadius: BorderRadius.circular(4.0),
                  activeColor: Colors.green,
                  activeFillColor: Colors.green,
                  selectedFillColor: AppColor.primaryColor,
                  selectedColor: AppColor.primaryColor,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: false,
                onCompleted: (pin) {
                  
                },
                onChanged: (value) {
                  
                },
              )
              .centered()
              .pSymmetric(h: 24.0),

              SizedBox().h(16.0),

              // GestureDetector(
              //   onTap: () {},
              //   child: VStack(
              //     [
              //       "Didn't receive OTP code?".tr().text.hexColor("#B1B5C6").medium.minFontSize(16.0).make(),
              //       const SizedBox().h(4.0),
              //       "Resend Code".tr().text.color(AppColor.primaryColor).bold.underline.makeCentered(),
              //     ],
              //     crossAlignment: CrossAxisAlignment.center,
              //     axisSize: MainAxisSize.min,
              //   ),
              // ).pOnly(bottom: 36.0),

              CustomButton(
                color: AppColor.primaryColor,
                onPressed: () async {
                  final phoneAuthCredential = await PhoneAuthProvider.credential(verificationId: widget.codeSentId, smsCode: pinTEC.text);
                  print("PhoneAuthCredential: ${phoneAuthCredential.asMap()}");
                  
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: "Verify & Proceed".text.color(Colors.white).xl.medium.makeCentered(),
              ).p12()

            ],
            crossAlignment: CrossAxisAlignment.center,
          ).whFull(context)
          .p12()
          .scrollVertical(),
        ),
      ),
    );
  }
}