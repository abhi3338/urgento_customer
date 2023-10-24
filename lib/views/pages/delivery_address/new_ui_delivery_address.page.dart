import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/delivery_address/new_delivery_addresses.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_strings.dart';
import '../../../services/location.service.dart';

class NewUIAddressPage extends StatelessWidget {

  const NewUIAddressPage({Key key, this.deliveryAddress}) : super(key: key);

  final DeliveryAddress deliveryAddress;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => NewDeliveryAddressesViewModel(context),
      onModelReady: (vm) {
        if (deliveryAddress != null) {
          vm.latitude = deliveryAddress.latitude;
          vm.longitude = deliveryAddress.longitude;
          vm.isDefault = deliveryAddress.isDefault != 0;
          vm.nameTEC.text = deliveryAddress.name;
          vm.addressTEC.text = deliveryAddress.address;
          vm.descriptionTEC.text = deliveryAddress.description;
        }
        vm.initialise();
      },
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Choose Delivery Location".tr(),
          body: Stack(
            children: [

              PlacePicker(
                apiKey: AppStrings.googleMapApiKey,
                autocompleteLanguage: translator.activeLocale.languageCode,
                automaticallyImplyAppBarLeading: false,
                selectInitialPosition: true,
                //hintText: "Your order will be delivered here Move pin to your exact location",
                region: AppStrings.countryCode.trim().split(",").firstWhere(
                  (e) => !e.toLowerCase().contains("auto"),
                  orElse: () {
                    return "";
                  },
                ),
                pinBuilder: (context, PinState pinState) {
                  if (pinState == PinState.Preparing) {
                    return Container();
                  } else {
                    return Stack(
                      children: <Widget>[
                        Center(
                          child: Image.asset(
                            "assets/images/icons/custom_pin.png",
                            height: 180.0,
                            width: 180.0,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return null;
                },
                onPlacePicked: (PickResult value) => Navigator.of(context).pop(value),
                onCameraMove: vm.onCameraMove,
                initialPosition: deliveryAddress != null
                ? deliveryAddress.latLng
                : LocationService.currenctAddress != null
                ? LatLng(LocationService.currenctAddress?.coordinates?.latitude, LocationService.currenctAddress?.coordinates?.longitude)
                : null,
                useCurrentLocation: true,
                enableMyLocationButton: true,
                selectedPlaceWidgetBuilder: (BuildContext context, PickResult selectedPlace, SearchingState state, bool isSearchBarFocused,) {
                  if (state == SearchingState.Searching) {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: VStack([

                      // Container(
                      //   padding: const EdgeInsets.all(12.0),
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      //       border: Border.all(color: AppColor.primaryColor),
                      //       color: Colors.white
                      //     ),
                      //     padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      //     child: HStack([
                      //       Icon(Icons.my_location_rounded, size: 18.0),
                      //       const SizedBox().w(8.0),
                      //       "Use current location".text.center.color(AppColor.primaryColor).minFontSize(14.0).maxFontSize(14.0).make()
                      //     ], axisSize: MainAxisSize.min),
                      //   ),
                      // ),

                      if (selectedPlace.formattedAddress != null && selectedPlace.formattedAddress.trim().isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                            shape: BoxShape.rectangle
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: VStack([

                            Text(
                              !vm.shouldChangeAddress
                              ? deliveryAddress != null
                              ? deliveryAddress.address
                              : selectedPlace.formattedAddress
                              : selectedPlace.formattedAddress,
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                              ),
                            ),

                            const SizedBox().h(24.0),

                            CustomButton(
                              child: Center(child: "Enter complete address".text.center.fontWeight(FontWeight.w500).maxFontSize(16.0).minFontSize(16.0).color(Colors.white).make(),),
                              color: AppColor.primaryColor,
                              height: 35.0,
                              isFixedHeight: true,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (vm.shouldChangeAddress) {

                                  if (deliveryAddress != null) {
                                    vm.longitude = selectedPlace.geometry.location.lng;
                                    vm.latitude = selectedPlace.geometry.location.lat;
                                    vm.addressTEC.text = selectedPlace.formattedAddress;
                                  } else {
                                      vm.longitude = selectedPlace.geometry.location.lng;
                                      vm.latitude = selectedPlace.geometry.location.lat;
                                      vm.nameTEC.clear();
                                      vm.isDefault = false;
                                      vm.addressTEC.text = selectedPlace.formattedAddress;
                                  }

                                } else {

                                  if (deliveryAddress == null) {
                                    vm.longitude = selectedPlace.geometry.location.lng;
                                    vm.latitude = selectedPlace.geometry.location.lat;
                                    vm.nameTEC.clear();
                                    vm.isDefault = false;
                                    vm.addressTEC.text = selectedPlace.formattedAddress;
                                  }
                                }
                                vm.openCompleteAddressSheet(deliveryAddress);
                              },
                              shapeRadius: 8.0,
                            ).wFull(context)

                          ], axisSize: MainAxisSize.min),
                        ).wFull(context),

                    ]),
                  );
                }
              )

            ],
          ),
        );
      }
    );
  }
}


