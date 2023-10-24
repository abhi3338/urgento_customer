import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/utils/utils.dart';

class OrderDetailsDriverInfoView extends StatelessWidget {
  const OrderDetailsDriverInfoView(this.vm, {Key key}) : super(key: key);
  final OrderDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return vm.order.driver != null
        ? VStack(
            [
              vm.order.driver != null
                  ? HStack(
                      [
                        //
                        VStack(
                          [
                            "Delivery Boy".tr().text.gray500.medium.make(),
                            UiSpacer.verticalSpace(space: 10),
                        HStack([

                          CustomImage(
                            imageUrl: vm.order.driver.photo,
                            width: 50,
                            height: 50,
                          ),
                          UiSpacer.horizontalSpace(space: 10),

                          VStack([

                            "${vm.order.driver.name}"
                                .text
                                .medium
                                .xl
                                .make()
                                .pOnly(bottom: Vx.dp20),

                            HStack(
                              [
                                Icon(
                                  FlutterIcons.star_ant,
                                  size: 14,
                                  color: Utils.textColorByTheme(),
                                ),
                                UiSpacer.hSpace(2),
                                //
                                "${vm.order.driver.rating}"
                                    .text
                                    .sm
                                    .color(Utils.textColorByTheme())
                                    .make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            )
                                .pSymmetric(v: 2, h: 6)
                                .box
                                .roundedLg
                                .color(AppColor.ratingColor)
                                .makeCentered(),



                          ])

                          ])




                          ],
                        ).expand(),
                        //call
                        vm.order.canChatDriver
                            ? CustomButton(
                                icon: FlutterIcons.phone_call_fea,
                                iconColor: Colors.white,
                                color: AppColor.primaryColor,
                                shapeRadius: Vx.dp48,
                                onPressed: vm.callDriver,
                              ).wh(Vx.dp64, Vx.dp40).p12()
                            : UiSpacer.emptySpace(),
                      ],
                    )
                  : UiSpacer.emptySpace(),
              if (vm.order.canChatDriver)
                Visibility(
                  visible: AppUISettings.canDriverChat,
                  child: CustomButton(
                    icon: FlutterIcons.chat_ent,
                    iconColor: Colors.white,
                    title: "Chat with driver".tr(),
                    color: AppColor.primaryColor,
                    onPressed: vm.chatDriver,
                  ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
                )
              else
                UiSpacer.emptySpace(),

              //rate driver
              vm.order.canRateVendor
                  ? CustomButton(
                      icon: FlutterIcons.rate_review_mdi,
                      iconColor: Colors.white,
                      title: "Rate The Delivery Boy".tr(),
                      color: AppColor.primaryColor,
                      onPressed: vm.rateDriver,
                    ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20)
                  : UiSpacer.emptySpace(),
            ],
          ).p12().card.make().p20()
        : UiSpacer.emptySpace();
  }
}
