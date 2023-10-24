import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ReferralBottomsheet extends StatelessWidget {
  const ReferralBottomsheet(
    this.profileViewModel, {
    Key key,
  }) : super(key: key);

  //
  final ProfileViewModel profileViewModel;

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //image
        Image.asset(
          AppImages.refer,
          width: context.percentWidth * 60,
          height: context.percentWidth * 60,
        ).centered(),
        //title
        "Refer & Earn".tr().text.semiBold.xl.makeCentered().py4(),
        "Share this code with your family and friends and you could earn %s when they completed their first order."
            "They will get upto 60 off , free delivery,cashback  on every order and they get a chance to win movie tickets or exciting gifts."
            .tr()
            .fill([
              "${AppStrings.currencySymbol} ${AppStrings.referAmount}"
                  .currencyFormat(),
            ])
            .text
            .center
            .makeCentered(),
        UiSpacer.verticalSpace(),
        UiSpacer.verticalSpace(),
        //referral code
        HStack(
          [
            //code
            profileViewModel.currentUser.code.text.semiBold
                .make()
                .px32()
                .py12()
                .box
                .color(Vx.gray200)
                .make(),
            //share button
            "Share"
                .tr()
                .text
                .color(Utils.isDark(AppColor.primaryColor)
                    ? Colors.white
                    : Colors.black)
                .make()
                .box
                .p12
                .color(AppColor.primaryColor)
                .make()
                .material()
                .onInkTap(profileViewModel.shareReferralCode),
          ],
        ).box.roundedSM.clip(Clip.antiAlias).make().centered(),
      ],
    )
        .p20()
        .scrollVertical()
        .hThreeForth(context)
        .box
        .color(context.theme.colorScheme.background)
        .topRounded()
        .make();
  }
}
