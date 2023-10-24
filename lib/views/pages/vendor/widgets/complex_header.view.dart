import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/ui_spacer.dart';
import '../../../../widgets/cards/custom.visibility.dart';

class ComplexVendorHeader extends StatelessWidget {
  const ComplexVendorHeader({
    Key key,
    this.model,
    this.searchShowType,
    @required this.onrefresh,
  }) : super(key: key);

  final MyBaseViewModel model;
  final int searchShowType;
  final Function onrefresh;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        HStack(
          [
            Icon(
              FlutterIcons.home_fea,
              color: Colors.black,
              size: 18,
            ).onInkTap(
              model.useUserLocation,
            ).p8().box
                .roundedSM
                .clip(Clip.antiAlias)
                .color(context.theme.colorScheme.background)
                .outerShadowSm
                .make(),

            UiSpacer.horizontalSpace(space: 5),

            HStack(
              [
                Text("Deliver To ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )),
                Container(
                  width: 160,
                  child: Text(
                    model.deliveryaddress.address,
                    style: TextStyle(
                      fontSize: 16.0, // Adjust the font size as needed
                      fontWeight:
                      FontWeight.w500, // Use FontWeight.bold for bold text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ).flexible(),
            UiSpacer.hSpace(1),
            Icon(
              FlutterIcons.chevron_down_ent,
              size: 20,
            ),
          ],
        )
            .onInkTap(() {
          model.pickDeliveryAddress(
            vendorCheckRequired: false,
            onselected: onrefresh,
          );
        }),
        UiSpacer.horizontalSpace(space: 2),

        Icon(
            FlutterIcons.search_fea,
            size: 18,
          )
              .p8()
              .onInkTap(() {
            model.openSearch(showType: searchShowType ?? 4);
          })
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .color(context.theme.colorScheme.background)
              .outerShadowSm
              .make(),

      ],
    );




  }
}
