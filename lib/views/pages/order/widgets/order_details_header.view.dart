import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  const OrderDetailsHeaderView(this.vm, {Key key}) : super(key: key);
  final OrderDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //code & total amount
        HStack(
          [
            //
            VStack(
              [
                "Code".tr().text.gray500.medium.sm.make(),
                "#${vm.order.code}".text.medium.xl.make(),
              ],
            ).expand(),
            //total amount
            CurrencyHStack(
              [
                AppStrings.currencySymbol.text.medium.lg.make().px4(),
                (vm.order.total ?? 0.00).currencyValueFormat().text.medium.xl2.make(),
              ],
            ),
          ],
        ).pOnly(bottom: Vx.dp20),
        HStack(
          [
            VStack(
              [
                "Verification Code".tr().text.gray500.medium.sm.make(),
                "${vm.order.verificationCode}".text.medium.xl.make(),
              ],
            ).expand(),
            //qr code icon
            Icon(
              FlutterIcons.qrcode_ant,
              size: 28,
            ).onInkTap(vm.showVerificationQRCode),
          ],
        ).wFull(context).pOnly(bottom: Vx.dp20),
      ],
    );
  }
}
