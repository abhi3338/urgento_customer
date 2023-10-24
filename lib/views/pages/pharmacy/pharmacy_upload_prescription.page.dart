import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/pharmacy_upload_prescription.vm.dart';
import 'package:fuodz/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:fuodz/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyUploadPrescription extends StatelessWidget {
  const PharmacyUploadPrescription(this.vendor, {Key key}) : super(key: key);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PharmacyUploadPrescriptionViewModel>.reactive(
      viewModelBuilder: () => PharmacyUploadPrescriptionViewModel(
        context,
        vendor,
      ),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          title: ("Upload Prescription".tr() + " ${vendor.name}"),
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          body: VStack(
            [
              // prescription photo
              Stack(
                children: [
                  //
                  vm.prescriptionPhoto != null
                      ? Image.file(
                    vm.prescriptionPhoto,
                    fit: BoxFit.fill,
                  ).wFull(context).hFull(context)
                      : UiSpacer.emptySpace(),

                  Align(
                    alignment: Alignment.center,
                    child: VStack([

                      CustomButton(
                        child: HStack([
                          Icon(Icons.image, size: 18,),
                          UiSpacer.horizontalSpace(space: 10),
                          "Upload from gallery".text.make(),
                        ])
                            .centered(),
                        shapeRadius: 30,
                        height: 20,
                        onPressed: () => vm.changePhoto(imageSource: ImageSource.gallery),
                      )
                          .px(context.percentWidth * 15)
                          .centered(),

                      SizedBox().h(12.0),

                      CustomButton(
                        child: HStack([
                          Icon(FlutterIcons.camera_ant, size: 18,),
                          UiSpacer.horizontalSpace(space: 10),
                          "Capture with Camera".text.make(),
                        ])
                            .centered(),
                        shapeRadius: 30,
                        height: 20,
                        onPressed: () => vm.changePhoto(imageSource: ImageSource.camera),
                      )
                          .px(context.percentWidth * 15)
                          .centered()
                    ]),
                  ),

                  // CustomButton(
                  //   child: HStack(
                  //     [
                  //       Icon(
                  //         FlutterIcons.camera_ant,
                  //         size: 18,
                  //       ),
                  //       UiSpacer.horizontalSpace(space: 10),
                  //       "Upload Photo".text.make(),
                  //     ],
                  //   ).centered(),
                  //   shapeRadius: 30,
                  //   height: 20,
                  //   titleStyle: context.textTheme.bodyLarge.copyWith(
                  //     fontSize: 11,
                  //   ),
                  //   onPressed: vm.changePhoto,
                  // ).px(context.percentWidth * 25).centered(),

                ],
              )
                  .h(context.percentHeight * 30)
                  .wFull(context),

              // slots
              UiSpacer.verticalSpace(),
              ScheduleOrderView(vm),
              //
              OrderDeliveryAddressPickerView(vm),

              //place order
              UiSpacer.verticalSpace(),
              CustomTextFormField(
                labelText: "Note".tr(),
                textEditingController: vm.noteTEC,
              ),
              UiSpacer.verticalSpace(),
              CustomButton(
                title: "PLACE ORDER REQUEST".tr(),
                loading: vm.isBusy,
                onPressed: vm.prescriptionPhoto != null ? () => vm.processOrderPlacement() : null,
                // onPressed: vm.prescriptionPhoto != null
                //     ? () => vm.placeOrder(ignore: true)
                //     : null,
              ).wFull(context),
            ],
          ).p20().scrollVertical().pOnly(
            bottom: context.mq.viewInsets.bottom,
          ),
        );
      },
    );
  }
}