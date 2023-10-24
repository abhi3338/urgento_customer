import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceDiscountSection extends StatefulWidget {
  const ServiceDiscountSection(
    this.vm, {
    this.toggle = false,
    Key key,
  }) : super(key: key);

  final dynamic vm;
  final bool toggle;

  @override
  _ServiceDiscountSectionState createState() => _ServiceDiscountSectionState();
}

class _ServiceDiscountSectionState extends State<ServiceDiscountSection> {
  bool show = true;

  @override
  void initState() {
    super.initState();
    //
    if (widget.toggle) {
      show = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            "Add Coupon".tr().text.semiBold.xl.make().expand(),
            widget.toggle
                ? Icon(
                    show ? FlutterIcons.close_ant : FlutterIcons.plus_ant,
                    color: AppColor.primaryColor,
                  ).onInkTap(() {
                    setState(() {
                      show = !show;
                    });
                  })
                : UiSpacer.emptySpace(),
          ],
        ),
        UiSpacer.verticalSpace(space: 10),
        //
        Visibility(
          visible: show,
          child: HStack(
            [
              //
              CustomTextFormField(
                hintText: "Coupon Code".tr(),
                textEditingController: widget.vm.couponTEC,
                errorText: widget.vm.hasErrorForKey(widget.vm.coupon)
                    ? widget.vm.error(widget.vm.coupon).toString()
                    : null,
                onChanged: widget.vm.couponCodeChange,
              ).expand(flex: 2),
              //
              UiSpacer.horizontalSpace(),
              Column(
                children: [
                  CustomButton(
                    title: "Apply".tr(),
                    isFixedHeight: true,
                    loading: widget.vm.busy(widget.vm.coupon),
                    onPressed:
                        widget.vm.canApplyCoupon ? widget.vm.applyCoupon : null,
                  ).h(Vx.dp56),
                  //
                  widget.vm.hasErrorForKey(widget.vm.coupon)
                      ? UiSpacer.verticalSpace(space: 12)
                      : UiSpacer.verticalSpace(space: 1),
                ],
              ).expand(),
            ],
          ),
        ),
      ],
    );
  }
}
