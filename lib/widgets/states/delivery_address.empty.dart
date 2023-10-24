import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmptyDeliveryAddress extends StatelessWidget {
  const EmptyDeliveryAddress({
    Key key,
    this.selection = false,
    this.isBooking = false,
  }) : super(key: key);

  final bool selection;
  final bool isBooking;
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.addressPin,
      title: selection
          ? "No ${!isBooking ? 'Delivery' : 'Booking'} Address Selected".tr()
          : "No ${!isBooking ? 'Delivery' : 'Booking'} Address Found".tr(),
      description: selection
          ? "Please select a ${!isBooking ? 'delivery' : 'booking'} address".tr()
          : "When you add ${!isBooking ? 'delivery' : 'booking'} addresses, they will appear here".tr(),
    );
  }
}
