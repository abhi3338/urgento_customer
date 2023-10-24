import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/views/pages/parcel/widgets/form_step_controller.dart';
import 'package:fuodz/views/pages/parcel/widgets/list_item/package_stop_recipient.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:velocity_x/velocity_x.dart';

class PackageRecipientInfo extends StatelessWidget {
  const PackageRecipientInfo({this.vm, Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: vm.recipientInfoFormKey,
      child: VStack(
        [
          //
          CustomListView(
            dataSet: vm.recipientNamesTEC,
            itemBuilder: (context, index) {
              DeliveryAddress stop;
              if (index == 0) {
                stop = vm.packageCheckout.pickupLocation;
              } else {
                stop = vm.packageCheckout.stopsLocation[index - 1].deliveryAddress;
              }
              final recipientNameTEC = vm.recipientNamesTEC[index];
              final recipientPhoneTEC = vm.recipientPhonesTEC[index];
              final noteTEC = vm.recipientNotesTEC[index];
              //
              return PackageStopRecipientView(
                stop,
                recipientNameTEC,
                recipientPhoneTEC,
                noteTEC,
                isOpen: index == vm.openedRecipientFormIndex,
                index: index + 1,
              );
            },
            padding: EdgeInsets.only(top: Vx.dp16),
          ).expand(),

          //
          FormStepController(
            onPreviousPressed: () => vm.nextForm(2),
            onNextPressed: vm.validateRecipientInfo,
          ),
        ],
      ),
    );
  }
}
