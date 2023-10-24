import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    this.order,
    this.onPayPressed,
    this.orderPressed,
    Key key,
  }) : super(key: key);

  final Order order;
  final Function onPayPressed;
  final Function orderPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            //
            VStack(
              [
                //
                HStack(
                  [
                    "#${order.code}".text.medium.make().expand(),
                    "${AppStrings.currencySymbol} ${order.total}"
                        .currencyFormat()
                        .text
                        .lg
                        .semiBold
                        .make(),
                  ],
                ),
                Divider(height: 4),

                //
                "${order.vendor.name}".text.lg.medium.make().py4(),
                //amount and total products
                HStack(
                  [
                    (order.isPackageDelivery
                            ? order.packageType.name
                            : order.isSerice
                                ? "${order?.orderService?.service?.category?.name}"
                                : "%s Product(s)"
                                    .tr()
                                    .fill([order.orderProducts.length ?? 0]))
                        .text
                        .medium
                        .make()
                        .expand(),
                    "${order.status}"
                        .tr()
                        .allWordsCapitilize()
                        .text
                        .color(
                          AppColor.getStausColor(order.status),
                        )
                        .medium
                        .make(),
                  ],
                ),
                //time & status
                HStack(
                  [
                    //time
                    Visibility(
                      visible: order.paymentMethod != null,
                      child: "${order.paymentMethod?.name}".text.medium.make(),
                    ).expand(),
                    VxTextBuilder(Jiffy(order.createdAt).format('dd E, MMM y'))
                        .sm
                        .make(),
                    //EEEE dd MMM yyyy
                  ],
                ),
              ],
            ).p12().expand(),
          ],
        ),

        //
        //payment is pending
        order.isPaymentPending != null && order.isPaymentPending
            ? CustomButton(
                title: "PAY FOR ORDER".tr(),
                titleStyle: context.textTheme.bodyLarge.copyWith(
                  color: Colors.white,
                ),
                icon: FlutterIcons.credit_card_fea,
                iconSize: 18,
                onPressed: onPayPressed,
                shapeRadius: 0,
              )
            : UiSpacer.emptySpace(),
      ],
    )
        .box
        .border(color: Colors.grey[200])
        .make()
        .onInkTap(orderPressed)
        .card
        .elevation(0.5)
        .clip(Clip.antiAlias)
        .roundedSM
        .make();
  }
}
