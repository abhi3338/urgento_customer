import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor_details.vm.dart';
import 'package:fuodz/views/pages/vendor/vendor_reviews.page.dart';
import 'package:fuodz/widgets/buttons/call.button.dart';
import 'package:fuodz/widgets/buttons/route.button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/tags/close.tag.dart';
import 'package:fuodz/widgets/tags/delivery.tag.dart';
import 'package:fuodz/widgets/tags/open.tag.dart';
import 'package:fuodz/widgets/tags/pickup.tag.dart';
import 'package:fuodz/widgets/tags/time.tag.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/views/pages/vendor_details/vendor_category_products.page.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/Other_Busy_Loading.dart';
import 'package:fuodz/widgets/list_items/notextcategoryitem.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/taxi_custom_text_form_field.dart';


class VendorDetailsHeader extends StatefulWidget {
  const VendorDetailsHeader(this.model, {this.showFeatureImage = true, Key key}) : super(key: key);

  final VendorDetailsViewModel model;
  final bool showFeatureImage;

  @override
  State<VendorDetailsHeader> createState() => _VendorDetailsHeaderState();
}

class _VendorDetailsHeaderState extends State<VendorDetailsHeader> {
  int useMenu = 1;

  @override
  Widget build(BuildContext context) {
    TempvendorId = widget.model.vendor.id;
    print("123vendor id====>>>${widget.model.vendor.id}");
    return VStack(
      [
        VStack(
          [
            //vendor header
            VStack(






              [


                CustomImage(
                  imageUrl: widget.model.vendor.logo,
                  width: 568,
                  height: 160,
                  canZoom: false,
                ).box.clip(Clip.antiAlias).withRounded(value: 20).outerShadow.make(),
                UiSpacer.verticalSpace(space: 10),
                //vendor important details
                HStack(
                  [
                    //logo

                    //
                    VStack(
                      [ Text(
                        widget.model.vendor.name,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            height: 1.0,
                            fontWeight: FontWeight.w800,
                            fontFamily: GoogleFonts.rubik().fontFamily,
                            color: Utils.textColorByBrightness(context),
                            fontSize: 18.0,
                            letterSpacing: 0.025),
                      ),

                        UiSpacer.verticalSpace(space: 6),
                        // widget.model.vendor.name.text.semiBold.lg.textStyle(GoogleFonts.roboto()).make(),
                        Container(
                          width: 260,
                          child: CustomVisibilty(
                            visible: widget.model.vendor.address != null,
                            child:Text(
                              widget.model.vendor.address ?? '',
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: Utils.textColorByBrightness(context),
                                  fontSize: 12.0,
                                  letterSpacing: 0.025),
                            ),





                          ),
                        ),


                        Visibility(
                          visible: AppUISettings.showVendorPhone,
                          child: widget.model.vendor.phone.text.light.sm.textStyle(GoogleFonts.roboto()).make(),
                        ),
                      ],
                    ),
                    //icons
                    VStack(
                      [
                        //call button
                        if (widget.model.vendor.phone != null)
                          Visibility(
                            visible: AppUISettings.showVendorPhone,
                            child: CallButton(widget.model.vendor, size: 10),
                          )
                        else
                          UiSpacer.emptySpace(),
                      ],
                    ).pOnly(left: Vx.dp12),
                    UiSpacer.expandedSpace(),
    Wrap(
    spacing: Vx.dp12,
    children: [

    Container(
    decoration: BoxDecoration(
    color: Colors.white, // You can set the background color to match your design
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
      padding: const EdgeInsets.all(8.0),
      child: VStack(
      [
      HStack(
      [
      Text(
      widget.model.vendor.rating.numCurrency,
      textAlign: TextAlign.left,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
      height: 1.0,
      fontWeight: FontWeight.w800,
      fontFamily: GoogleFonts.rubik().fontFamily,
      color: Utils.textColorByBrightness(context),
      fontSize: 14.0,
      letterSpacing: 0.025,
      ),
      ),
      UiSpacer.horizontalSpace(space: 4),
      Icon(
      FlutterIcons.star_ent,
      color: Colors.yellow,
      size: 14,
      ),
      ],
      ),
      UiSpacer.formVerticalSpace(space: 4),
      Text(
      "${widget.model.vendor.reviews_count} Reviews",
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
      height: 1.0,
      fontWeight: FontWeight.w300,
      fontFamily: GoogleFonts.rubik().fontFamily,
      color: Utils.textColorByBrightness(context),
      fontSize: 10.0,
      letterSpacing: 0.025,
      ),
      ),
      ],
      ).onTap(() {
      context.nextPage(
      VendorReviewsPage(widget.model.vendor),
      );
      }),
    ),
    )

    ],
    ),
    //rating

     

    //
    //
    Visibility(
    visible: widget.model.vendor.distance != null,
    child: HStack(
    [
    Icon(
    FlutterIcons.direction_ent,
    color: AppColor.primaryColor,
    size: 10,
    ),
    " ${widget.model.vendor?.distance?.numCurrency}km"
        .text
        .minFontSize(6)
        .size(10)
        .make(),
    ],
    ),
    ),
    ],
    ).px8(),

                UiSpacer.verticalSpace(space: 3),

                Wrap(
                  children: [
                    //is open
                    widget.model.vendor.isOpen ? OpenTag() : CloseTag(),

                    //can deliver
                    widget.model.vendor.delivery == 1 ? DeliveryTag() : UiSpacer.emptySpace(),

                    //can pickup
                    widget.model.vendor.pickup == 1 ? PickupTag() : UiSpacer.emptySpace(),

                    //prepare time
                    TimeTag(
                      widget.model.vendor.prepareTime,
                      iconData: FlutterIcons.clock_outline_mco,
                    ),
                    //delivery time
                    TimeTag(
                      widget.model.vendor.deliveryTime,
                      iconData: FlutterIcons.ios_bicycle_ion,
                    ),
                  ],
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                ).p8(),
                UiSpacer.verticalSpace(space: 3),

                Text(
                  widget.model.vendor.description,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      height: 1.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      color: Utils.textColorByBrightness(context),
                      fontSize: 12.0,
                      letterSpacing: 0.025),
                ).px8(),

                SectionCouponsView(
                  widget.model.vendor.vendorType,
                  title: "".tr(),
                  scrollDirection: Axis.horizontal,
                  itemWidth: context.percentWidth * 40,
                  height: 90,
                  itemsPadding: EdgeInsets.all(10),
                  isDetailPage: true,
                ),

              ],
            ).p8(),

            VStack(
              [
                CustomSlidingSegmentedControl<int>(
                  isStretch: true,
                  initialValue: 1,
                  children: {
                    1: Text("Shop by menu"),
                    2: Text("Shop by category"),
                  },
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppColor.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.5,
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 300),
                  highlightColor: Colors.red,
                  splashColor: Colors.green,
                  curve: Curves.easeInToLinear,
                  onValueChanged: (value) {
                    setState(() {
                      useMenu = value;
                    });
                  },
                ).p16().centered(),
                //
                Column(
                  children: [
                    if (useMenu == 1)
                      ...[
                        UiSpacer.verticalSpace(space: 2),
                      ]
                    else
                      ...[
                        CustomVisibilty(
                          visible: (!widget.model.vendor.hasSubcategories && !widget.model.vendor.isServiceType),
                          child:  CustomGridView(
                            noScrollPhysics: true,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: (context.screenWidth / 5) / 100,
                            crossAxisCount: AppStrings.categoryPerRow,
                            dataSet: widget.model.vendor.categories,
                            itemBuilder: (ctx, index) {
                              final category = widget.model.vendor.categories[index];
                              return NoCategoryListItem(
                                h: AppStrings.categoryImageHeight + 40,
                                category: category,
                                onPressed: (category) {
                                  category.hasSubcategories = category.subcategories.isNotEmpty;
                                  context.nextPage(
                                    VendorCategoryProductsPage(
                                      category: category,
                                      vendor: widget.model.vendor,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ]
                  ],
                ),
              ],
            ),
          ],
        ).p8(),
        //search bar

        // Add your search bar widget here
      ],
    );
  }
}
