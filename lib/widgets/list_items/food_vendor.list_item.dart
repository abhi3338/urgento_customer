import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/route.button.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/tags/delivery.tag.dart';
import 'package:fuodz/widgets/tags/time.tag.dart';
import 'package:fuodz/widgets/tags/pickup.tag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/utils.dart';
import '../../views/pages/vendor/vendor_reviews.page.dart';

class FoodVendorListItem extends StatelessWidget {
  const FoodVendorListItem({
    this.vendor,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Stack(
          children: [
            //
            Hero(
              tag: vendor.heroTag,
              child: CachedNetworkImage(
                imageUrl: vendor.featureImage,
                width: double.infinity,

              ),
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
                : UiSpacer.emptySpace(),*/

            //


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
        UiSpacer.verticalSpace(space: 5),
        //name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "${vendor.name}",
            textAlign: TextAlign.left,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(

                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.rubik().fontFamily,
                color: Color(0xFF0B0C17),
                fontSize: 10.0,
                letterSpacing: 0.025),
          ),
        ),
        UiSpacer.verticalSpace(space: 2),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Text(
        //     "${vendor.description}",
        //     textAlign: TextAlign.left,
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //     style: TextStyle(
        //         height: 1.0,
        //         fontWeight: FontWeight.w400,
        //         fontFamily: GoogleFonts.rubik().fontFamily,
        //         color: Color(0xFF494C61),
        //         fontSize: 8.0,
        //         letterSpacing: 0.025),
        //   ),
        // ),



      /*  vendor.name.text.sm.medium
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make()
            .px8()
            .pOnly(top: Vx.dp8), */
        //
        //description
        // "${vendor.description}"
        //     .text
        //     .gray400
        //     .minFontSize(9)
        //     .size(9)
        //     .maxLines(1)
        //     .overflow(TextOverflow.ellipsis)
        //     .make()
        //     .px8(),
        //words
        Wrap(
          spacing: Vx.dp12,
          children: [
            //rating
            HStack(
              [     Container(
                  width: 120,
                  child: Text(
                    "${vendor.description}",
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        height: 1.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: Color(0xFF494C61),
                        fontSize: 8.0,
                        letterSpacing: 0.025),
                  ),

              ),UiSpacer.expandedSpace(),
                Container(
                  width: 36,
                height: 26,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.background, // You can set the background color to match your design
                  borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Offset from the top
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: VStack(
                    [
                      HStack(
                        [
                          Text(
                            vendor.rating.numCurrency,
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.0,
                              fontWeight: FontWeight.w800,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              color: Utils.textColorByBrightness(context),
                              fontSize: 8.0,
                              letterSpacing: 0.025,
                            ),
                          ),
                          UiSpacer.horizontalSpace(space: 1),
                          Icon(
                            FlutterIcons.star_ent,
                            color: Colors.yellow,
                            size: 10,
                          ),
                        ],
                      ),
                      UiSpacer.formVerticalSpace(space: 4),
                      Text(
                        "${vendor.reviews_count} Reviews",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          color: Utils.textColorByBrightness(context),
                          fontSize: 4.0,
                          letterSpacing: 0.025,
                        ),
                      ),
                    ],
                  ).onTap(() {
                    context.nextPage(
                      VendorReviewsPage(vendor),
                    );
                  }),
                ),
              )
                // "${vendor.rating.numCurrency} "
                //     .text
                //     .minFontSize(6)
                //     .size(10)
                //     .color(AppColor.ratingColor)
                //     .medium
                //     .make(),
                // Icon(
                //   FlutterIcons.star_ent,
                //   color: Colors.yellow,
                //   size: 10,
                // ),
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
        HStack(
          [
            //can deliver
            vendor.delivery == 1
                ? DeliveryTag()
                : UiSpacer.emptySpace(),

            //can pickup
            vendor.pickup == 1
                ? PickupTag()
                : UiSpacer.emptySpace(),

            UiSpacer.horizontalSpace(space: 5),
            TimeTag(
                vendor.prepareTime,
                iconData: FlutterIcons.clock_outline_mco
            ),
            UiSpacer.horizontalSpace(space: 5),
            TimeTag(
              vendor.deliveryTime,
              iconData: FlutterIcons.ios_bicycle_ion,
            ),

          ],
          crossAlignment: CrossAxisAlignment.end,
        ).p8(),


      ],
    )
        .onInkTap(
          () => this.onPressed(this.vendor),
        )
        .w(175)
        .box
    .outerShadow

        .color(context.theme.colorScheme.background, )
        .clip(Clip.antiAlias)
        .withRounded(value: 5)
        .make()
        .pOnly(bottom: Vx.dp8);
  }
}
