import 'package:flutter/material.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/views/pages/parcel/widgets/form_step_controller.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PackageDeliveryParcelInfo extends StatelessWidget {
  const PackageDeliveryParcelInfo({this.vm, Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: vm.packageInfoFormKey,
      child: VStack(
        [
          //
          VStack(
            [
              "Package Parameters".tr().text.xl.medium.make().py20(),
              //
              ("Weight".tr() + " (kg)").text.make(),
              CustomTextFormField(
                underline: true,
                hintText: "Enter package weight".tr(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textEditingController: vm.packageWeightTEC,
                validator: (value) => FormValidator.validateCustom(
                  value,
                  name: "Weight".tr(),
                  rules: vm.requireParcelInfo ? "required|gt:0":''
                ),
              ),
              UiSpacer.formVerticalSpace(),
              //
              ("Length".tr() + " (cm)").text.make(),
              CustomTextFormField(
                underline: true,
                hintText: "Enter package length".tr(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textEditingController: vm.packageLengthTEC,
                validator: (value) => FormValidator.validateCustom(
                  value,
                  name: "Length".tr(),
                  rules: vm.requireParcelInfo ?"required|gt:0":''
                ),
              ),
              UiSpacer.formVerticalSpace(),
              //
              //
              ("Width".tr() + " (cm)").text.make(),
              CustomTextFormField(
                underline: true,
                hintText: "Enter package width".tr(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textEditingController: vm.packageWidthTEC,
                validator: (value) => FormValidator.validateCustom(
                  value,
                  name: "Width".tr(),
                  rules: vm.requireParcelInfo ?"required|gt:0":''
                ),
              ),
              UiSpacer.formVerticalSpace(),

              //
              ("Height".tr() + " (cm)").text.make(),
              CustomTextFormField(
                underline: true,
                hintText: "Enter package height".tr(),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                textEditingController: vm.packageHeightTEC,
                validator: (value) => FormValidator.validateCustom(
                  value,
                  name: "Height".tr(),
                  rules: vm.requireParcelInfo ?"required|gt:0":''
                ),
              ),

              //finish btn
              UiSpacer.formVerticalSpace(),
            ],
          ).scrollVertical().expand(),

          //
          FormStepController(
            onPreviousPressed: () => vm.nextForm(3),
            onNextPressed: vm.validateDeliveryParcelInfo,
          ),
        ],
      ),
    );
  }
}
