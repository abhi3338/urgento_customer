import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/tags/time.tag.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/route.button.dart';
import 'package:fuodz/widgets/tags/pickup.tag.dart';
import 'package:fuodz/widgets/tags/delivery.tag.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HorizontalVendorListItem extends StatelessWidget {
  //
  const HorizontalVendorListItem(this.vendor, {this.onPressed, Key key})
      : super(key: key);

  //
  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    //
    return VStack(
      [
        //
        Stack(
          children: [
            //
            Hero(
              tag: vendor.heroTag,
              child:  CachedNetworkImage(
    imageUrl: vendor.featureImage,
    width: double.infinity,

    )



    ),

            //location routing
            /*(!vendor.latitude.isEmptyOrNull && !vendor.longitude.isEmptyOrNull)
                ? Positioned(
              child: RouteButton(
                vendor,
                size: 12,
              ),
              bottom: 5,
              right: 10,
            )
                : UiSpacer.emptySpace(), */

           /* //
            Positioned(
              child: VStack(
                [
                  vendor.name.text.sm.medium.white
                      .maxLines(1)
                      .overflow(TextOverflow.ellipsis)
                      .make()
                      .px8()
                      .pOnly(top: Vx.dp8),
                ],
              ),
              left: 10,
              bottom: 5,
            ), */

            //closed
            Positioned(
              child: Visibility(
                visible: !vendor.isOpen,
                child: VxBox(
                  child: "Not Accepting Orders".tr().text.sm.white.bold.makeCentered(),
                )
                    .color(
                  AppColor.closeColor.withOpacity(0.6),
                )
                    .make(),
              ),
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
            ),
          ],
        ),
   HStack([


     /*Hero(
       tag: vendor.heroTag,
       child: CustomImage(imageUrl: vendor.logo)
           .wh(Vx.dp64, Vx.dp64)
           .box
           .clip(Clip.antiAlias)
           .roundedSM
           .make(),
     ), */

        VStack([
UiSpacer.verticalSpace(space: 10),
        //name
          /*
        vendor.name.text.sm.medium
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make()
            .px8()
            .pOnly(top: Vx.dp8),*/
        //
        //description


          //description
          //vm.vendor.description.text.sm.make(),






        //words
        Wrap(
          spacing: Vx.dp12,
          children: [
            //rating
            HStack(
              [
                "${vendor.rating.numCurrency} "
                    .text
                    .minFontSize(6)
                    .size(10)
                    .color(AppColor.ratingColor)
                    .medium
                    .make(),
                Icon(
                  FlutterIcons.star_ent,
                  color: AppColor.ratingColor,
                  size: 10,
                ),
              ],
            ),

            //
            //
            Visibility(
              visible: vendor.distance != null,
              child: HStack(
                [
                  Icon(
                    FlutterIcons.direction_ent,
                    color: AppColor.primaryColor,
                    size: 10,
                  ),
                  " ${vendor?.distance?.numCurrency}km"
                      .text
                      .minFontSize(6)
                      .size(10)
                      .make(),
                ],
              ),
            ),
          ],
        ).px8(),




//delivery fee && time


        //


        ])
    ]),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: context.screenWidth ,
            child: HtmlWidget(vendor.description),
          ),
        ),

        HStack(
          [
            //can deliver
            vendor.delivery == 1
                ? DeliveryTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),

            //can pickup
            vendor.pickup == 1
                ? PickupTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),


            HStack(

                [TimeTag(
                    vendor.prepareTime,
                    iconData: FlutterIcons.clock_outline_mco
                ),
                  UiSpacer.horizontalSpace(space: 5),
                  TimeTag(
                    vendor.deliveryTime,
                    iconData: FlutterIcons.ios_bicycle_ion,
                  ),
                ]


            )
          ],


          crossAlignment: CrossAxisAlignment.end,
        ).p8()
      ],
    )
        .onInkTap(
          () => this.onPressed(this.vendor),
    )
        .w(175)
        .box
        .outerShadow2Xl
        .color(context.theme.colorScheme.background,)
        .clip(Clip.antiAlias)
        .withRounded(value: 5)
        .make()
        .pOnly(bottom: Vx.dp8);





      VStack(
      [  Stack(
      children: [
        //

        Hero(
          tag: vendor.heroTag,
          child: CustomImage(
            imageUrl: vendor.featureImage,
            height: 180,
            width: context.screenWidth,
          ),
        ),
        UiSpacer.verticalSpace(space: 10),

        //closed
        Positioned(
          child: Visibility(
            visible: !vendor.isOpen,
            child: VxBox(
              child: "Closed".tr().text.lg.white.bold.makeCentered(),
            )
                .color(
              AppColor.closeColor.withOpacity(0.6),
            )
                .make(),
          ),
          bottom: 0,
          right: 0,
          left: 0,
          top: 0,
        ),

      ],
      ),


        UiSpacer.verticalSpace(space: 15),
        HStack(

            [

              Hero(
              tag: vendor.heroTag,
              child: CustomImage(imageUrl: vendor.logo)
                  .wh(Vx.dp64, Vx.dp64)
                  .box
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .make(),
            ),

              UiSpacer.horizontalSpace(space: 20),

    VStack(
    [


        //Details

    HStack(
    [
        VStack(
        [
          HStack(
              [
                //name
            vendor.name.text.medium.extraBold.xl
                .maxLines(2)
                .wrapWords(true)
                .lowercase
                .overflow(TextOverflow.ellipsis)
                .make(),





        ]),
          UiSpacer.horizontalSpace(space: 30),
          UiSpacer.verticalSpace(space: 5),

        HStack(

          [TimeTag(
              vendor.prepareTime,
              iconData: FlutterIcons.clock_outline_mco
          ),
          UiSpacer.horizontalSpace(space: 5),
          TimeTag(
            vendor.deliveryTime,
            iconData: FlutterIcons.ios_bicycle_ion,
          ),
    ]


        ) //description

        ],
        ),
    ],
    ),
        //rating

      ],
    )

      ]),
        UiSpacer.verticalSpace(space: 8),

        "${vendor.description}"
            .text
            .minFontSize(10)
            .size(12)
            .maxLines(4)
            .overflow(TextOverflow.fade)
            .make()
            .px8(),

        UiSpacer.verticalSpace(space: 8),

        HStack(
          [  UiSpacer.horizontalSpace(space: 7),



            HStack(
                [



                  Icon(
                    FlutterIcons.star_ant,
                    size: 15,
                    color: Colors.yellow[800],
                  ).pOnly(right: 2),
                  vendor.rating.text.xl.make(),

                  UiSpacer.horizontalSpace(space: 7),

                  vendor.delivery == 1
                      ? DeliveryTag().pOnly(right: 10)
                      : UiSpacer.emptySpace(),

                  //can pickup
                  vendor.pickup == 1
                      ? PickupTag().pOnly(right: 10)
                      : UiSpacer.emptySpace(),




                ]),






            UiSpacer.verticalSpace(space: 15),
          ],


          crossAlignment: CrossAxisAlignment.center,
          alignment: MainAxisAlignment.center,
        ).pOnly(right: 20),










    ])
          .onInkTap(
            () => this.onPressed(this.vendor),
      )
          .w(175)
          .box
          .outerShadow
          .color(context.theme.colorScheme.background)
          .clip(Clip.antiAlias)
          .withRounded(value: 5)
          .make()
          .pOnly(bottom: Vx.dp8);
  }
}

