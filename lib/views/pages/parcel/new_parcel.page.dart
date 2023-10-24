import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_delivery_info.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_delivery_parcel_info.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_delivery_payment.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_delivery_summary.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_recipient_info.dart';
import 'package:fuodz/views/pages/parcel/widgets/package_type_selector.dart';
import 'package:fuodz/views/pages/parcel/widgets/vendor_package_type_selector.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewParcelPage extends StatelessWidget {
  const NewParcelPage(this.vendorType, {this.onFinish, Key key})
      : super(key: key);

  final VendorType vendorType;
  final Function onFinish;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewParcelViewModel>.reactive(
      viewModelBuilder: () => NewParcelViewModel(context, onFinish, vendorType),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          showCart: false,
          // title: "${vendorType.name}",
          appBarColor: AppColor.primaryColor,
          appBarItemColor: Utils.textColorByTheme(),
          body: VStack(
            [
              VStack(
                [
                  "Pick up or send anything"
                      .tr()
                      .text
                      .color(Utils.textColorByBrightness(context))
                      .bold
                      .xl3
                      .make(),
                  "Please complete the steps below to place an order"
                      .tr()
                      .text
                      .base
                      .color(Utils.textColorByBrightness(context))
                      .light
                      .make(),
                  UiSpacer.vSpace(12),
                  //
                  AnimatedSmoothIndicator(
                    activeIndex: vm.activeStep,
                    count: 7,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Color(0xFF000000),
                      dotColor: Colors.grey,
                      strokeWidth: 2,
                      paintStyle: PaintingStyle.stroke,
                    ),
                  ),
                  UiSpacer.vSpace(10),
                ],
              )
                  .p20()
                  .box

                  .color(context.theme.colorScheme.background,)
                  .make()
                  .wFull(context),

              //
              PageView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                controller: vm.pageController,
                children: [
                  //package type
                  PackageTypeSelector(vm: vm),

                  //
                  PackageDeliveryInfo(vm: vm),

                  //vendors from sort delivery
                  VendorPackageTypeSelector(vm: vm),

                  //receiver info
                  PackageRecipientInfo(vm: vm),

                  //parcel info
                  CustomVisibilty(
                    visible: vm.requireParcelInfo,
                    child: PackageDeliveryParcelInfo(vm: vm),
                  ),

                  //summary
                  PackageDeliverySummary(vm: vm),

                  //PAYMENT
                  PackageDeliveryPayment(vm: vm),
                ],
              ).box.make().px20().expand()
            ],
          ).pOnly(
            bottom: context.mq.viewInsets.bottom,
            // bottom: context.mq.viewPadding.bottom,
          ),
        );
      },
    );
  }
}
