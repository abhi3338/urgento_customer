import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/cart.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';

class ApplyCoupon extends StatelessWidget {
  const ApplyCoupon(this.vm,this.discount, {Key key}) : super(key: key);

  final CartViewModel vm;
  final double discount;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [

        SectionCouponsView(
          null,
          title: "Coupons".tr(),
          scrollDirection: Axis.horizontal,
          itemWidth: context.percentWidth * 60,
          height: 90,
          itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          couponTEC: vm.couponTEC,
          isCartPage: true,
          canApplyCoupon: vm.canApplyCoupon,
          updateApply: vm.updateApply,
          applyCoupon: vm.applyCoupon,
          applyString: vm.applyStr,
          discount: discount,
          loadingWidget: const SizedBox.shrink(),
        ),
        UiSpacer.divider(),
        UiSpacer.verticalSpace(space: 10),
        //
        "Add Coupon".tr().text.semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        //
        vm.isAuthenticated()
            ? CustomTextFormField(
                hintText: "Enter Coupon Code".tr(),
                textEditingController: vm.couponTEC,
                errorText: vm.hasErrorForKey(vm.coupon)
                    ? vm.error(vm.coupon).toString()
                    : null,
                onChanged: vm.couponCodeChange,
                suffixIcon: CustomButton(
                  child:
                  "Apply".tr().text.bold.lg.makeCentered(),
                  isFixedHeight: true,
                  loading: vm.busy(vm.coupon),
                  onPressed: vm.canApplyCoupon ? vm.applyCoupon : null,
                ).w(100).p8(),
              )
            : VStack(
                [
                  //
                  EmptyState(
                    auth: true,
                    showImage: false,
                    actionPressed: vm.openLogin,
                  ),
                ],
              ),
      ],
    );
  }
}
