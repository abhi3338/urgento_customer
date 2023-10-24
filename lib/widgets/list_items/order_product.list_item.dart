import 'package:flutter/material.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/order_product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/views/pages/order/widgets/order_digitial_product_download.dart';
import 'package:fuodz/widgets/bottomsheets/order_product_action.bottomsheet.dart';
import 'package:fuodz/widgets/buttons/arrow_indicator.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderProductListItem extends StatelessWidget {
  const OrderProductListItem({
    this.orderProduct,
    this.order,
    Key key,
  }) : super(key: key);

  final OrderProduct orderProduct;
  final Order order;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //other status
        CustomVisibilty(
          visible: order == null || !order.isCommerce,
          child: HStack(
            [
              //qty
              "x ${orderProduct.quantity}".text.semiBold.make(),
              VStack(
                [
                  //
                  orderProduct.product.name.text.make(),
                  Visibility(
                    visible: orderProduct.options != null &&
                        orderProduct.options.isNotEmpty,
                    child: "${orderProduct.options}".text.sm.gray500.medium.make(),
                  ),
                ],
              ).px12().expand(),
              "${AppStrings.currencySymbol}${orderProduct.price}"
                  .currencyFormat()
                  .text
                  .semiBold
                  .make(),
              //
            ],
          ),
        ),

        //completed order
        CustomVisibilty(
          visible: order != null && order.isCommerce,
          child: VStack(
            [
              HStack(
                [
                  //
                  CustomImage(
                    imageUrl: orderProduct.product.photo,
                    width: 70,
                    height: 70,
                  ),
                  UiSpacer.hSpace(6),

                  VStack(
                    [
                      //
                      orderProduct.product.name.text
                          .maxLines(2)
                          .ellipsis
                          .light
                          .make(),
                      orderProduct.options != null
                          ? orderProduct.options.text.sm.gray500.medium.make()
                          : UiSpacer.emptySpace(),

                      HStack(
                        [
                          //qty
                          "Qty: %s"
                              .tr()
                              .fill([orderProduct.quantity])
                              .text
                              .semiBold
                              .make(),
                          //
                          UiSpacer.hSpace(15),
                          //price
                          "Price: %s"
                              .tr()
                              .fill(
                                [
                                  "${AppStrings.currencySymbol}${orderProduct.price}"
                                      .currencyFormat()
                                ],
                              )
                              .text
                              .semiBold
                              .make(),
                        ],
                      ),
                    ],
                  ).px12().expand(),
                  //
                  UiSpacer.hSpace(6),
                  ArrowIndicator(26),
                  //
                ],
              ),
              UiSpacer.divider().py8(),
              //digital download
              DigitialProductOrderDownload(order, orderProduct),
            ],
          ).onInkTap(
            () {
              //show bottomsheet
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (ctx) {
                  return OrderProductActionBottomSheet(orderProduct);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
