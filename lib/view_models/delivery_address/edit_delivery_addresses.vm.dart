import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EditDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress deliveryAddress;

  //
  EditDeliveryAddressesViewModel(BuildContext context, this.deliveryAddress) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    nameTEC.text = deliveryAddress.name;
    addressTEC.text = deliveryAddress.address;
    descriptionTEC.text = deliveryAddress.description;
    isDefault = deliveryAddress.isDefault == 1;
    notifyListeners();
  }

  //
  showAddressLocationPicker() async {
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      addressTEC.text = locationResult.formattedAddress;
      deliveryAddress.address = locationResult.formattedAddress;
      deliveryAddress.latitude = locationResult.geometry.location.lat;
      deliveryAddress.longitude = locationResult.geometry.location.lng;
      // From coordinates
      setBusy(true);
      deliveryAddress = await getLocationCityName(deliveryAddress);
      setBusy(false);
      notifyListeners();
    } else if (result is Address) {
      Address locationResult = result;
      addressTEC.text = locationResult.addressLine;
      deliveryAddress.address = locationResult.addressLine;
      deliveryAddress.latitude = locationResult.coordinates.latitude;
      deliveryAddress.longitude = locationResult.coordinates.longitude;
      deliveryAddress.city = locationResult.locality;
      deliveryAddress.state = locationResult.adminArea;
      deliveryAddress.country = locationResult.countryName;
    }
  }

  void toggleDefault(bool value) {
    isDefault = value;
    deliveryAddress.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  updateDeliveryAddress() async {
    if (formKey.currentState.validate()) {
      //
      deliveryAddress.name = nameTEC.text;
      deliveryAddress.description = descriptionTEC.text;
      //
      setBusy(true);
      //
      final apiRespose = await deliveryAddressRequest.updateDeliveryAddress(
        deliveryAddress,
      );

      //
      CoolAlert.show(
        context: viewContext,
        type: apiRespose.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Update Delivery Address".tr(),
        text: apiRespose.message,
        onConfirmBtnTap: () {
          viewContext.pop();
          viewContext.pop(true);
        },
      );
      //
      setBusy(false);
    }
  }
}
