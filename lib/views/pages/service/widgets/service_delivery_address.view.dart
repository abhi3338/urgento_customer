import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/list_items/delivery_address.list_item.dart';
import 'package:fuodz/widgets/states/delivery_address.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceDeliveryAddressPickerView extends StatelessWidget {
  const ServiceDeliveryAddressPickerView(
    this.vm, {
    this.service,
    Key key,
  }) : super(key: key);
  final CheckoutBaseViewModel vm;
  final Service service;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: VStack(
        [
          //
          HStack(
            [
              //
              VStack(
                [
                  "Booking address".tr().text.semiBold.xl.make(),
                  "Please select %s address/location"
                      .tr()
                      .fill(["booking".tr()])
                      .text
                      .make(),
                ],
              ).expand(),
              //
              CustomButton(
                title: "Select".tr(),
                onPressed: vm.showDeliveryAddressPicker,
              ),
            ],
          ),
          //Selected delivery address box
          DottedBorder(
            borderType: BorderType.RRect,
            color: context.accentColor,
            strokeWidth: 1,
            strokeCap: StrokeCap.round,
            radius: Radius.circular(5),
            dashPattern: [3, 6],
            child: vm.deliveryAddress != null
                ? DeliveryAddressListItem(
                    deliveryAddress: vm.deliveryAddress,
                    action: false,
                    border: false,
                    showDefault: false,
                  )
                : EmptyDeliveryAddress(
                    selection: true,
                    isBooking: true,
                  ).py12().opacity(value: 0.90),
          ).wFull(context).py12().onInkTap(
                vm.showDeliveryAddressPicker,
              ),

          //within vendor range
          Visibility(
            visible: vm.delievryAddressOutOfRange,
            child: "Booking address is out of vendor service range"
                .tr()
                .text
                .sm
                .red500
                .make(),
          ),
        ],
      ).p12().box.roundedSM.border(color: Colors.grey).make().pOnly(
            bottom: Vx.dp20,
          ),
    );
  }
}
