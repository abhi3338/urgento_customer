import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ParcelDeliveryDiscountSection extends StatefulWidget {
  const ParcelDeliveryDiscountSection(this.vm, {Key key}) : super(key: key);

  final NewParcelViewModel vm;

  @override
  State<ParcelDeliveryDiscountSection> createState() =>
      _ParcelDeliveryDiscountSectionState();
}

class _ParcelDeliveryDiscountSectionState
    extends State<ParcelDeliveryDiscountSection> {
  bool showClearButton = false;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Add Coupon".tr().text.semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        //
        HStack(
          [
            //
            CustomTextFormField(
              hintText: "Coupon Code".tr(),
              textEditingController: widget.vm.couponTEC,
              errorText: widget.vm.hasErrorForKey(widget.vm.coupon)
                  ? widget.vm.error(widget.vm.coupon).toString()
                  : null,
              onChanged: widget.vm.couponCodeChange,
            ).expand(),
            //

            Column(
              children: [
                //apply button
                Visibility(
                  visible: !showClearButton,
                  child: CustomButton(
                    title: "Apply".tr(),
                    shapeRadius: 0,
                    isFixedHeight: true,
                    loading: widget.vm.busy(widget.vm.coupon),
                    onPressed: widget.vm.canApplyCoupon
                        ? () {
                      if (widget.vm.couponTEC.text.isEmpty) {
                        //show validation error
                        widget.vm.setErrorForObject(
                            widget.vm.coupon, "Required".tr());
                        return;
                      }
                      //
                      widget.vm.applyCoupon();
                      //
                      setState(() {
                        showClearButton = true;
                      });
                    }
                        : null,
                  ).h(48),
                ),
                //clear button
                Visibility(
                  visible: showClearButton,
                  child: CustomButton(
                    icon: FlutterIcons.clear_mdi,
                    padding: EdgeInsets.all(0),
                    child: Icon(
                      FlutterIcons.clear_mdi,
                      color: Colors.white,
                      size: 20,
                    ),
                    color: Colors.red,
                    // isFixedHeight: true,
                    // loading: widget.vm.busy(widget.vm.coupon),
                    onPressed: () {
                      widget.vm.clearCoupon();
                      //
                      setState(() {
                        showClearButton = false;
                      });
                    },
                  ).h(Vx.dp32).w(32).pOnly(left: 8),
                ),
                //
                // widget.vm.hasErrorForKey(widget.vm.coupon)
                //     ? UiSpacer.verticalSpace(space: 12)
                //     : UiSpacer.verticalSpace(space: 1),
              ],
            ),
          ],
          crossAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}