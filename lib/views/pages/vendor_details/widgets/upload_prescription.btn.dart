import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor_details.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class UploadPrescriptionFab extends StatelessWidget {
  const UploadPrescriptionFab(this.model, {Key key}) : super(key: key);

  final VendorDetailsViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.vendor.isPharmacyType && AppStrings.enableUploadPrescription
        ? FloatingActionButton.extended(
            onPressed: model.uploadPrescription,
            backgroundColor: AppColor.primaryColor,
            label: "Upload Prescription".tr().text.white.make(),
            icon: Icon(
              FlutterIcons.pills_faw5s,
              color: Colors.white,
              size: 22,
            ),
          )
        : UiSpacer.emptySpace();
  }
}
