import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/ui_spacer.dart';
import '../../cart/cart.page.dart';

class VendorHeader extends StatefulWidget {
  const VendorHeader({
    Key key,
    this.model,
    this.showSearch = true,
    @required this.onrefresh,
  }) : super(key: key);

  final MyBaseViewModel model;
  final bool showSearch;
  final Function onrefresh;

  @override
  _VendorHeaderState createState() => _VendorHeaderState();
}

class _VendorHeaderState extends State<VendorHeader> {
  @override
  void initState() {
    super.initState();
    //
    if (widget.model.deliveryaddress == null) {
      widget.model.fetchCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        HStack(
          [

            Icon(
              FlutterIcons.location_pin_ent,
              color: Colors.black,
              size: 18,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    )),
                Container(
                  width: 125,
                  child: Text(
                    widget.model.deliveryaddress.address,
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the font size as needed
                      fontWeight:
                      FontWeight.w500, // Use FontWeight.bold for bold text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ).flexible(),

            Icon(
              FlutterIcons.chevron_down_ent,
              size: 20,
            ),
          ],
        )
            .onInkTap(() {
          widget.model.pickDeliveryAddress(
            vendorCheckRequired: false,
            onselected: widget.onrefresh,
          );
        }),
        UiSpacer.horizontalSpace(space: 10),
        CustomVisibilty(
          visible: widget.showSearch,
          child: Icon(
            FlutterIcons.cart_arrow_up_mco,
            size: 18,
          )
              .p8()
              .onInkTap(() {
            context.nextPage(CartPage());

          })
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .color(context.theme.colorScheme.background)
              .outerShadowSm
              .make(),
        ),
        UiSpacer.expandedSpace(),

        CustomVisibilty(
          visible: widget.showSearch,
          child: Icon(
            FlutterIcons.search_fea,
            size: 18,
          )
              .p8()
              .onInkTap(() {
            widget.model.openSearch();
          })
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .color(context.theme.colorScheme.background)
              .outerShadowSm
              .make(),
        ),
      ],
    )
        .px20()
        .py16()
        .safeArea()


        .pOnly(bottom: 5)
        .box

        .make();

  }
}
