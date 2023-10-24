import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/checkout_base.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ScheduleOrderView extends StatelessWidget {
  const ScheduleOrderView(this.vm, {Key key}) : super(key: key);
  final CheckoutBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.vendor.allowScheduleOrder != null && !vm.vendor.allowScheduleOrder) {
      return SizedBox();
    }

    return Visibility(
      visible: vm.vendor.allowScheduleOrder,

      child: VStack(
        [
          if (vm.vendor.allowScheduleOrder != null && vm.vendor.allowScheduleOrder)
          HStack(
            [
              //
                Checkbox(
                  value: vm.isScheduled,
                  fillColor: MaterialStateProperty.all(AppColor.primaryColor),
                  onChanged: vm.vendor.allowScheduleOrder != null && vm.vendor.allowScheduleOrder
                      ? null
                      : vm.toggleScheduledOrder,
                  //onChanged: null,
                  //tristate: false,
                  visualDensity: VisualDensity.adaptivePlatformDensity,

                ),
              //
              VStack(
                [
                  "Schedule Order".tr().text.xl.semiBold.make(),
                  "If you want your order to be delivered/prepared at scheduled date/time"
                      .tr()
                      .text
                      .make(),
                ],
              ).expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ).wFull(context).onInkTap(
                () => vm.toggleScheduledOrder(!vm.isScheduled),
              ),

          //delivery time slots
          if (vm.vendor.allowScheduleOrder != null && vm.vendor.allowScheduleOrder)
          Visibility(
            visible: vm.isScheduled,
            child: VStack(
              [
                //date slot
                UiSpacer.verticalSpace(),
                "Date slot".tr().text.lg.make(),
                CustomListView(
                  scrollDirection: Axis.horizontal,
                  dataSet: vm.vendor.deliverySlots,
                  itemBuilder: (context, index) {
                    final dateDeliverySlot = vm.vendor.deliverySlots[index];

                    final formmatedDeliverySlot =
                        DateFormat("yyyy-MM-dd", "en").format(
                      dateDeliverySlot.date,
                    );
                    bool selected =
                        (formmatedDeliverySlot == vm.checkout.deliverySlotDate);
                    //

                    return Jiffy(dateDeliverySlot.date)
                        .format("EEEE dd MMM yyyy")
                        .text
                        .color(
                          selected ? Colors.white : null,
                        )
                        .makeCentered()
                        .px8()
                        .py4()
                        .box
                        .roundedSM
                        .border(color: AppColor.primaryColor)
                        .color(
                          selected ? AppColor.primaryColor : Colors.transparent,
                        )
                        .make()
                        .onInkTap(
                          () => vm.changeSelectedDeliveryDate(
                            formmatedDeliverySlot,
                            index,
                          ),
                        );
                  },
                ).h(Vx.dp32).py8(),
                //
                UiSpacer.verticalSpace(space: 10),
                "Time slot".tr().text.lg.make(),
                UiSpacer.verticalSpace(space: 10),
                CustomGridView(
                  // scrollDirection: Axis.horizontal,
                  noScrollPhysics: true,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  dataSet: vm.availableTimeSlots,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3,
                  crossAxisCount: 3,
                  itemBuilder: (context, index) {
                    //
                    final today = DateFormat("yyyy-MM-dd", "en").format(
                      DateTime.now(),
                    );
                    final availableTimeSlot = vm.availableTimeSlots[index];
                    final formmatedDeliveryTimeSlot =
                        DateFormat("HH:mm:ss", "en").format(
                      DateTime.parse("$today $availableTimeSlot"),
                    );

                    //check if selected
                    bool selected = formmatedDeliveryTimeSlot ==
                        vm.checkout.deliverySlotTime;
                    //
                    return Jiffy("$today $availableTimeSlot")
                        .format("hh:mm a")
                        .text
                        .color(
                          selected ? Colors.white : null,
                        )
                        .makeCentered()
                        .box
                        .roundedSM
                        .border(color: AppColor.primaryColor)
                        .color(
                          selected ? AppColor.primaryColor : Colors.transparent,
                        )
                        .make()
                        .onInkTap(
                          () => vm.changeSelectedDeliveryTime(
                            formmatedDeliveryTimeSlot,
                          ),
                        );
                  },
                ),
                // CustomGridView(dataSet: dataSet, itemBuilder: itemBuilder),
              ],
            ),
          ),
        ],
      ).p12().box.roundedSM.border(color: Colors.grey).make().pOnly(
            bottom: Vx.dp20,
          ),
    );
  }
}
