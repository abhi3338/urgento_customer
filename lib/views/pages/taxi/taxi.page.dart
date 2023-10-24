import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/views/pages/taxi/widgets/new_order_step_1.dart';
import 'package:fuodz/views/pages/taxi/widgets/new_order_step_2.dart';
import 'package:fuodz/views/pages/taxi/widgets/taxi_rate_driver.view.dart';
import 'package:fuodz/views/pages/taxi/widgets/taxi_trip_ready.view.dart';
import 'package:fuodz/views/pages/taxi/widgets/trip_driver_search.dart';
import 'package:fuodz/views/pages/taxi/widgets/unsupported_taxi_location.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_leading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  _TaxiPageState createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> with WidgetsBindingObserver {
  //
  TaxiViewModel taxiViewModel;

  @override
  void initState() {
    super.initState();
    taxiViewModel = TaxiViewModel(context, widget.vendorType);
  }

  //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState. resumed) {
    // }
    taxiViewModel.setGoogleMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TaxiViewModel>.reactive(
      viewModelBuilder: () => taxiViewModel,
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          leading: IconButton(
            alignment: Alignment.center,
            autofocus: true,
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
            iconSize: 28.0,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          body: Stack(
            children: [
              //google map
              GoogleMap(
                initialCameraPosition: vm.mapCameraPosition,
                onMapCreated: vm.onMapCreated,
                padding: vm.googleMapPadding,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: vm.selectedVehicleType != null
                    ? vm.gMapMarkers.where((element) => element.markerId.value.endsWith(vm.selectedVehicleType.name) || element.markerId.value == "sourcePin" || element.markerId.value == "destPin").toSet()
                    : vm.gMapMarkers,
                polylines: vm.gMapPolylines,
              ),

              //custom leading appbar
              Visibility(
                visible: !AppStrings.isSingleVendorMode,
                child: CustomLeading(
                  padding: 10,
                  size: 24,
                  color: AppColor.primaryColor,
                  bgColor: Utils.textColorByTheme(),
                  iconColor: Colors.black,
                ).safeArea().positioned(
                  top: 0,
                  left: !Utils.isArabic ? 20 : null,
                  right: Utils.isArabic ? 20 : null,
                ),
              ),

              //show when location is not supported
              UnSupportedTaxiLocationView(vm),

              //new taxi order form - Step 1
              NewTaxiOrderLocationEntryView(vm),

              //new taxi order form - step 2
              NewTaxiOrderSummaryView(vm),

              //
              Visibility(
                visible: vm.currentStep(3),
                child: TripDriverSearch(vm),
              ),
              //
              Visibility(
                visible: vm.currentStep(4),
                child: TaxiTripReadyView(vm),
              ),
              //
              Visibility(
                visible: vm.currentStep(6),
                child: TaxiRateDriverView(vm),
              ),
            ],
          ),
        );
      },
    );
  }
}
