import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:velocity_x/velocity_x.dart';

class SocialMediaView extends StatelessWidget {
  const SocialMediaView(
    this.model, {
    this.bottomPadding = Vx.dp48,
    Key key,
  }) : super(key: key);

  final LoginViewModel model;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !Platform.isIOS || (Platform.isIOS && AppStrings.appleLogin),
      child: VStack(
        [
          //facebook
          Visibility(
            visible: AppStrings.facebbokLogin,
            child: SignInButton(
              Buttons.FacebookNew,
              onPressed: () {
                model.socialMediaLoginService.facebookLogin(model);
              },
            ).wFull(context).pOnly(bottom: Vx.dp4),
          ),
          //google
          Visibility(
            visible: AppStrings.googleLogin,
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                model.socialMediaLoginService.googleLogin(model);
              },
            ).wFull(context).pOnly(bottom: Vx.dp10),
          ),

          //apple
          Visibility(
            visible: Platform.isIOS && AppStrings.appleLogin,
            child: SignInWithAppleButton(
              onPressed: () => model.socialMediaLoginService.appleLogin(model),
            ),
          ),
        ],
      ).px24().pOnly(bottom: bottomPadding),
    );
  }
}
