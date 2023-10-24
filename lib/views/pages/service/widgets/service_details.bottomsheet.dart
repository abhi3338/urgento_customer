import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/service_details.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceDetailsBottomSheet extends StatelessWidget {
  const ServiceDetailsBottomSheet(this.vm, {Key key}) : super(key: key);
  final ServiceDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //hour selection
        Visibility(
          visible: !vm.service.isFixed,
          child: HStack(
            [
              //
              "${vm.service.duration.allWordsCapitilize() ?? vm.service.duration ?? ''}"
                  .tr()
                  .text
                  .medium
                  .xl
                  .make()
                  .expand(),
              VxStepper(
                defaultValue: 1,
                min: 1,
                max: 24,
                actionButtonColor: AppColor.primaryColor,
                disableInput: true,
                onChange: (value) {
                  vm.service.selectedQty = value;
                  vm.notifyListeners();
                },
              ),
            ],
          ),
        ),

        Visibility(
          visible: !vm.service.isFixed,
          child: UiSpacer.verticalSpace(),
        ),

        //
        CustomButton(
          title: "Continue".tr(),
          onPressed: vm.bookService,
        ),
        UiSpacer.verticalSpace(),
      ],
    )
        .p20()
        .box
        .shadowSm
        .color(context.theme.colorScheme.background)
        .topRounded(value: 20)
        .make();
  }
}
