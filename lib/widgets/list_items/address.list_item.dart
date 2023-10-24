import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddressListItem extends StatelessWidget {
  const AddressListItem(this.address, {this.onAddressSelected, Key key})
      : super(key: key);

  final Address address;
  final Function(Address) onAddressSelected;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        Icon(
          FlutterIcons.location_pin_ent,
          color: Colors.white,
          size: 16,
        ).box.p4.roundedFull.color(Colors.grey.shade400).make(),
        UiSpacer.hSpace(10),
        //
        VStack(
          [
            "${address.featureName}"
                .text
                .maxLines(2)
                .ellipsis
                .minFontSize(13)
                .maxFontSize(13)
                .medium
                .lg
                .make(),
            Visibility(
              visible: address.addressLine != null,
              child: "${address.addressLine}"
                  .text
                  .thin
                  .sm
                  .color(Colors.grey.shade600)
                  .make(),
            ),
          ],
        ).expand(),
      ],
      crossAlignment: CrossAxisAlignment.center,
      alignment: MainAxisAlignment.center,
    ).p12().onInkTap(() {
      onAddressSelected(address);
    }).material(color: Colors.transparent);
  }
}
