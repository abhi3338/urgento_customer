import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressListItem extends StatelessWidget {
  const DeliveryAddressListItem({
    this.deliveryAddress,
    this.onEditPressed,
    this.onDeletePressed,
    this.action = true,
    this.border = true,
    this.borderColor,
    this.showDefault = true,
    Key key,
  }) : super(key: key);

  final DeliveryAddress deliveryAddress;
  final Function onEditPressed;
  final Function onDeletePressed;
  final bool action;
  final bool border;
  final bool showDefault;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    if (deliveryAddress == null) {
      return shimmerView(context);
    }
    return VStack(
      [
        //
        HStack(
          [
            //
            VStack(
              [
                deliveryAddress.name.text.semiBold.lg.make(),
                deliveryAddress.address.text.sm
                    .maxLines(3)
                    .overflow(TextOverflow.ellipsis)
                    .make(),
                "${deliveryAddress.description}".text.sm.make(),
                (deliveryAddress.defaultDeliveryAddress && showDefault)
                    ? "Default"
                        .tr()
                        .text
                        .xs
                        .italic
                        .maxLines(3)
                        .overflow(TextOverflow.ellipsis)
                        .make()
                    : UiSpacer.emptySpace(),
              ],
            ).p12().expand(),
            //
            this.action
                ? VStack(
                    [
                      //delete icon
                      Icon(
                        FlutterIcons.delete_ant,
                        size: 16,
                        color: Colors.white,
                      )
                          .wFull(context)
                          .onInkTap(this.onDeletePressed)
                          .py12()
                          .box
                          .red500
                          .make(),
                      //edit icon
                      Icon(
                        FlutterIcons.edit_ent,
                        size: 16,
                        color: Colors.white,
                      )
                          .wFull(context)
                          .onInkTap(this.onEditPressed)
                          .py12()
                          .box
                          .blue500
                          .make(),
                    ],
                    axisSize: MainAxisSize.max,
                    // crossAlignment: CrossAxisAlignment.center,
                  ).w(context.percentWidth * 15)
                : UiSpacer.emptySpace(),
          ],
        )
            .box
            .roundedSM
            .clip(Clip.antiAlias)
            .border(
              color: borderColor != null
                  ? borderColor
                  : (border ? context.accentColor : Colors.transparent),
              width: border ? 1 : 0,
            )
            .make(),

        //
        //can deliver
        CustomVisibilty(
          visible: deliveryAddress.can_deliver != null &&
              !deliveryAddress.can_deliver,
          child: "Vendor does not service this location"
              .tr()
              .text
              .red500
              .xs
              .thin
              .make()
              .px12()
              .py2(),
        ),
      ],
    );
  }

  Widget shimmerView(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        child: VStack([
          
          HStack([

            VStack([])
            .p12()
            .expand(),
            
            VStack([
              
              Container()
              .wFull(context)
              .py12()
              .box
              .red500
              .make(),
                      
              Container()
              .wFull(context)
              .onInkTap(this.onEditPressed)
              .py12()
              .box
              .blue500
              .make(),

            ],axisSize: MainAxisSize.max)
            .w(context.percentWidth * 15)
            ,
          ])
          .box
          .roundedSM
          .clip(Clip.antiAlias)
          .border(
            color: borderColor != null ? borderColor : (border ? context.accentColor : Colors.transparent),
            width: border ? 1 : 0,
          )
          .make(),
        ]),
      ).h(80.0),
    );
  }
}
