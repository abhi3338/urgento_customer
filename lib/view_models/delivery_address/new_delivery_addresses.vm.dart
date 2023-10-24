import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/othertextform.dart';


class NewDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  bool isDefault = false;
  double longitude = 0.0;
  double latitude = 0.0;
  DeliveryAddress deliveryAddress = new DeliveryAddress();

  final addressFormKey = GlobalKey<FormState>();

  //
  NewDeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
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

  //

  void toggleDefault(bool value) {
    isDefault = value;
    //deliveryAddress.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  Future openCompleteAddressSheet(DeliveryAddress address) {
    return showModalBottomSheet(
        context: viewContext,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))
        ),
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: VStack([

                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border(bottom: BorderSide(color: Colors.grey.shade300))
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      alignment: Alignment.centerLeft,
                      child: "Enter complete address".text.start.minFontSize(18.0).maxFontSize(18.0).color(AppColor.primaryColor).fontWeight(FontWeight.w600).make(),
                    ).h(50.0),

                    UiSpacer.verticalSpace(space: 8.0),

                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Form(
                          key: addressFormKey,
                          child: VStack([

                            OCustomTextFormField(
                              labelText: "eg Home , Office , Hostel , Others".tr(),
                              textEditingController: nameTEC,
                              validator: FormValidator.validateName,
                            ),

                            UiSpacer.verticalSpace(space: 8.0),

                            OCustomTextFormField(
                              labelText: "Choose Address".tr(),
                              isReadOnly: true,
                              textEditingController: addressTEC,
                              validator: (value) => FormValidator.validateEmpty(value, errorTitle: "Address".tr()),
                            ).py2(),

                            UiSpacer.verticalSpace(space: 8.0),

                            OCustomTextFormField(
                              labelText: "Enter Complete Address with floor,land mark ".tr(),
                              textEditingController: descriptionTEC,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              textInputAction: TextInputAction.newline,
                              textAlignment: TextAlign.start,
                            ).py2(),

                            CheckboxListTile(
                              checkColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: AppColor.primaryColor,
                              controlAffinity: ListTileControlAffinity.platform,
                              visualDensity: VisualDensity.adaptivePlatformDensity,
                              value: isDefault,
                              onChanged: (bool value) {
                                isDefault = value;
                                setState(() {});
                              },
                              title: "Default".tr().text.make(),
                            )

                          ], axisSize: MainAxisSize.min),
                        ),
                      ),
                    ),

                    CustomButton(
                      isFixedHeight: true,
                      height: Vx.dp48,
                      title: "Save".tr(),
                      onPressed: () async {
                        if (addressFormKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();

                          saveNewDeliveryAddress(address);
                        }
                      },
                      loading: isBusy,
                    ).centered()
                        .pSymmetric(h: 18.0, v: 8.0),

                  ], axisSize: MainAxisSize.min),
                );
              }
          );
        }
    );
  }

  bool shouldChangeAddress = false;

  void onCameraMove(CameraPosition position) {
    shouldChangeAddress = true;
    notifyListeners();
  }

  //
  saveNewDeliveryAddress(DeliveryAddress address) async {
    setBusy(true);
    DeliveryAddress deliveryAddress = new DeliveryAddress(name: nameTEC.text, longitude: longitude, latitude: latitude, address: addressTEC.text, description: descriptionTEC.text, isDefault: isDefault ? 1 : 0);

    ApiResponse apiResponse = null;
    if (address != null) {
      address.latitude = latitude;
      address.longitude = longitude;
      address.address = addressTEC.text;
      //address.latLng = LatLng(address.latitude, address.longitude);
      address.description = descriptionTEC.text;
      address.name = nameTEC.text;
      address.isDefault = isDefault ? 1 : 0;
      apiResponse = await deliveryAddressRequest.updateDeliveryAddress(address,);
    } else {
      apiResponse = await deliveryAddressRequest.saveDeliveryAddress(deliveryAddress,);
    }

    if (apiResponse == null) return;

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "New Delivery Address".tr(),
      text: apiResponse.message,
      onConfirmBtnTap: () {
        viewContext.pop();
        viewContext.pop(true);
        Navigator.pop(viewContext);
      },
    );

    setBusy(false);
  }

  //

}
