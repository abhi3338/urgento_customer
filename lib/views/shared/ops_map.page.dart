import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/ops_map.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OPSMapPage extends StatelessWidget {
  const OPSMapPage({
    this.useCurrentLocation,
    this.region,
    this.initialPosition,
    Key key,
  }) : super(key: key);

  final bool useCurrentLocation;
  final String region;
  final LatLng initialPosition;
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: ViewModelBuilder<OPSMapViewModel>.reactive(
        viewModelBuilder: () => OPSMapViewModel(context),
        builder: (ctx, vm, child) {
          return SafeArea(
            child: VStack(
              [
                HStack(
                  [
                    //close btn
                    Icon(
                      FlutterIcons.arrow_back_mdi,
                    ).p2().onInkTap(() {
                      context.pop();
                    }),
                    UiSpacer.horizontalSpace(),
                    //auto complete
                    TypeAheadFormField<Address>(
                      keepSuggestionsOnLoading: false,
                      hideSuggestionsOnKeyboardHide: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: vm.searchTEC,
                        decoration: InputDecoration(
                          hintText: 'Search address'.tr(),
                        ),
                      ),
                      minCharsForSuggestions: 3,
                      //0.9 seconds
                      debounceDuration: Duration(milliseconds: 900),
                      suggestionsCallback: (keyword) async {
                        return await vm.fetchPlaces(keyword);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title:
                              suggestion.featureName.text.base.semiBold.make(),
                          subtitle: suggestion.addressLine.text.sm.make(),
                        );
                      },

                      onSuggestionSelected: vm.addressSelected,
                    ).expand(),
                  ],
                ).px20().py4(),

                //google map body
                Stack(
                  children: [
                    //
                    GoogleMap(
                      myLocationEnabled: useCurrentLocation,
                      myLocationButtonEnabled: useCurrentLocation,
                      initialCameraPosition: CameraPosition(
                        target: initialPosition ?? LatLng(0.00, 0.00),
                        zoom: initialPosition != null ? 16 : 10,
                      ),
                      padding: vm.googleMapPadding,
                      onMapCreated: vm.onMapCreated,
                      onCameraMove: vm.mapCameraMove,
                      markers: Set<Marker>.of(vm.gMarkers.values),
                    ),

                    // //center marker
                    // Padding(
                    //   padding: vm.googleMapPadding,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: new Icon(
                    //       Icons.location_on,
                    //       size: 50.0,
                    //       color: AppColor.primaryColor,
                    //     ),
                    //   ),
                    // ),

                    //loading indicator
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.busy(vm.selectedAddress),
                        child: BusyIndicator().centered().p32(),
                      ),
                    ),
                    //selected address details
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.selectedAddress != null,
                        child: MeasureSize(
                          onChange: vm.updateMapPadding,
                          child: VStack(
                            [
                              //address full
                              vm.selectedAddress?.featureName?.text?.semiBold
                                  ?.center?.xl
                                  ?.maxLines(3)
                                  ?.overflow(TextOverflow.ellipsis)
                                  ?.make(),
                              UiSpacer.verticalSpace(space: 5),
                              vm.selectedAddress?.addressLine?.text?.light
                                  ?.center?.sm
                                  ?.maxLines(2)
                                  ?.overflow(TextOverflow.ellipsis)
                                  ?.make(),
                              UiSpacer.verticalSpace(),
                              //submit
                              CustomButton(
                                title: "Select".tr(),
                                onPressed: vm.submit,
                              ),
                            ],
                          )
                              .box
                              .shadow2xl
                              .color(context.theme.colorScheme.background)
                              .p20
                              .make(),
                        ),
                      ),
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }
}
