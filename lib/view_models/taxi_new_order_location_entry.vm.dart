import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/app_ui_sizes.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/tax_order_location.history.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NewTaxiOrderLocationEntryViewModel extends MyBaseViewModel {
  //
  NewTaxiOrderLocationEntryViewModel(BuildContext context, this.taxiViewModel) {
    this.viewContext = context;
  }

  TaxiRequest taxiRequest = TaxiRequest();
  GeocoderService geocoderService = GeocoderService();
  List<TaxiOrderLocationHistory> previousAddresses = [];
  List<TaxiOrderLocationHistory> shortPreviousAddressesList = [];
  final TaxiViewModel taxiViewModel;
  PanelController panelController = PanelController();
  double customViewHeight = AppUISizes.taxiNewOrderIdleHeight;
  bool showChooseOnMap = false;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Timer _debounce;
  List<Address> places = [];

  initialise() {
    fetchHistoryAddresses();
    handleEntryFocusChanges();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  //when the input is n focus or not
  handleEntryFocusChanges() {
    taxiViewModel.pickupLocationFocusNode.addListener(() {
      if (taxiViewModel.pickupLocationFocusNode.hasFocus ||
          taxiViewModel.dropoffLocationFocusNode.hasFocus) {
        showChooseOnMap = true;
        taxiViewModel.currentAddressSelectionStep = 1;
      } else {
        showChooseOnMap = false;
      }
      notifyListeners();
    });
    taxiViewModel.dropoffLocationFocusNode.addListener(() {
      if (taxiViewModel.pickupLocationFocusNode.hasFocus ||
          taxiViewModel.dropoffLocationFocusNode.hasFocus) {
        showChooseOnMap = true;
        taxiViewModel.currentAddressSelectionStep = 2;
      } else {
        showChooseOnMap = false;
      }
      notifyListeners();
    });
  }

  //location history
  fetchHistoryAddresses() async {
    //update
    updateLoadingheight();
    //
    setBusyForObject(previousAddresses, true);
    try {
      previousAddresses = await taxiRequest.locationHistory();
      if (previousAddresses.length > 3) {
        shortPreviousAddressesList = previousAddresses.sublist(0, 3);
      } else {
        shortPreviousAddressesList = previousAddresses;
      }
      notifyListeners();
      //update the height
      double extraHeight = (shortPreviousAddressesList.length * 55.00);
      resetStateViewheight(extraHeight);
    } catch (error) {
      print("Error getting previous location ==> $error");
      resetStateViewheight();
    }
    setBusyForObject(previousAddresses, false);
  }

  //
  updateLoadingheight() {
    customViewHeight = AppUISizes.taxiNewOrderHistoryHeight;
    notifyListeners();
  }

  resetStateViewheight([double height = 0]) {
    customViewHeight = AppUISizes.taxiNewOrderIdleHeight + height;
    notifyListeners();
  }

  closePanel() async {
    clearFocus();
    await panelController.close();
    notifyListeners();
  }

  clearFocus() {
    FocusScope.of(taxiViewModel.viewContext).requestFocus(new FocusNode());
  }

  openPanel() async {
    await panelController.open();
    notifyListeners();
  }

  //
  onDestinationSelected(TaxiOrderLocationHistory value) async {
    DeliveryAddress mDeliveryAddress = DeliveryAddress();
    taxiViewModel.checkout.deliveryAddress = null;

    mDeliveryAddress.address = value.address;
    mDeliveryAddress.latitude = value.latitude;
    mDeliveryAddress.longitude = value.longitude;
    //
    taxiViewModel.checkout.deliveryAddress = mDeliveryAddress;
    //
    await runBusyFuture(
      getLocationCityName(mDeliveryAddress),
      busyObject: previousAddresses,
    );
    //
    taxiViewModel.deliveryAddress = mDeliveryAddress;
    taxiViewModel.dropoffLocation = taxiViewModel.checkout.deliveryAddress;
    taxiViewModel.dropoffLocationTEC.text =
        taxiViewModel.checkout.deliveryAddress?.address;
    await panelController.open();
    taxiViewModel.notifyListeners();
  }

  void onDestinationPressed() async {
    //show sliding panel
    await openPanel();
    //focus on the destination entry input
    taxiViewModel.dropoffLocationFocusNode.requestFocus();
  }

  void onScheduleOrderPressed() async {
    //show sliding panel
    await openPanel();
    showSchedulePeriodPicker();
  }

  showSchedulePeriodPicker() async {
    //first the date
    selectedDate = await showDatePicker(
      context: viewContext,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        AppStrings.taxiMaxScheduleDays.toInt().days,
      ),
      fieldLabelText: 'Date'.tr(),
    );

    if (selectedDate == null) {
      return;
    }
    //then get time
    selectedTime = await showTimePicker(
      context: viewContext,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (selectedTime == null) {
      return;
    }

    //both selected
    taxiViewModel.checkout.pickupDate = Jiffy.unixFromMillisecondsSinceEpoch(
        selectedDate.millisecondsSinceEpoch)
        .format("y-MM-d");

    taxiViewModel.checkout.pickupTime =
    "${selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
    notifyListeners();
  }

  //
  void clearScheduleSelection() {
    taxiViewModel.checkout.pickupTime = null;
    taxiViewModel.checkout.pickupDate = null;
    taxiViewModel.notifyListeners();
    notifyListeners();
  }

  void handleChooseOnMap() async {
    //handle pickup
    int step = 1;
    if (taxiViewModel.pickupLocationFocusNode.hasFocus) {
      taxiViewModel.pickupLocationFocusNode.unfocus();
    } else {
      step = 2;
      taxiViewModel.dropoffLocationFocusNode.unfocus();
    }

    //
    taxiViewModel.currentAddressSelectionStep = step;
    if (taxiViewModel.deliveryAddress == null) {
      taxiViewModel.deliveryAddress = DeliveryAddress();
    }
    await taxiViewModel.showDeliveryAddressPicker();
    //
    taxiViewModel.notifyListeners();
    notifyListeners();
  }

  void searchPlace(String keyword) async {
    clearAlreadySelected();
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 1000),
          () async {
        // do something with query
        setBusyForObject(places, true);
        try {
          places = await geocoderService.findAddressesFromQuery(keyword);
        } catch (error) {
          print("search error ==> $error");
          places = [];
        }
        setBusyForObject(places, false);
        notifyListeners();
      },
    );
  }

  onAddressSelected(Address address) async {
    AlertService.showLoading();
    try {
      address = await GeocoderService().fecthPlaceDetails(address);
      DeliveryAddress mDeliveryAddress = new DeliveryAddress(
        address: address.addressLine,
        latitude: address.coordinates.latitude,
        longitude: address.coordinates.longitude,
        city: address.locality,
        state: address.adminArea,
        country: address.countryName,
      );
      //
      taxiViewModel.deliveryAddress = mDeliveryAddress;
      taxiViewModel.checkout.deliveryAddress = mDeliveryAddress;

      // taxiViewModel.deliveryAddress = await getLocationCityName(
      //   taxiViewModel.deliveryAddress,
      // );
      taxiViewModel.openLocationSelector(
        taxiViewModel.currentAddressSelectionStep,
        showpicker: false,
      );
      places = [];
      notifyListeners();
    } catch (error) {
      print("erro ===> $error");
    }
    AlertService.stopLoading();
    clearFocus();
  }

  clearAlreadySelected() {
    if (taxiViewModel.currentAddressSelectionStep == 1) {
      taxiViewModel.pickupLocation = null;
    } else {
      taxiViewModel.dropoffLocation = null;
    }
    notifyListeners();
  }

  ///
  moveToNextStep() async {
    if (taxiViewModel.pickupLocation == null ||
        taxiViewModel.dropoffLocation == null) {
      toastError("Please select pickup and drop-off location".tr());
    } else {
      taxiViewModel.checkLocationAvailabilityForStep2();
    }
  }
}