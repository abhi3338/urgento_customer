import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/cart.vm.dart';
import 'package:fuodz/view_models/coupons.vm.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/coupon.list_item.dart';
import 'package:fuodz/widgets/section.title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/utils.dart';

int TempvendorId = 0;

class SectionCouponsView extends StatelessWidget {
    SectionCouponsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = SearchFilterType.sales,
    this.itemWidth,
    this.viewType,
    this.separator,
    this.byLocation = false,
    this.itemsPadding,
    this.titlePadding,
    this.height,
    this.bPadding = 0,
    this.couponTEC,
        this.isCartPage = false,
        this.canApplyCoupon,
          this.updateApply,
          this.applyCoupon,
          this.applyString,
          this.discount,
          this.isDetailPage = false,
    Key key,
          this.loadingWidget,
  }) : super(key: key);

  final VendorType vendorType;
    final Widget loadingWidget;
  final Axis scrollDirection;
  final SearchFilterType type;
  final String title;
  final double height;
  final double itemWidth;
  final dynamic viewType;
  final Widget separator;
  final bool byLocation;
  final EdgeInsets itemsPadding;
  final EdgeInsets titlePadding;
  final double bPadding;
  final TextEditingController couponTEC;
  final bool isCartPage;
  bool canApplyCoupon;
  Function updateApply;
  Function applyCoupon;
  final String applyString;
  double discount;
  final bool isDetailPage;

  @override
  Widget build(BuildContext context) {
    tempContext = context;
    return ViewModelBuilder<CouponsViewModel>.reactive(
      viewModelBuilder: () => CouponsViewModel(
        context,
        vendorType,
          isCartPagevm: isCartPage,
          isDetailPagevm: isDetailPage
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        model.isCartPagevm  = isCartPage;
        Widget listView = CustomListView(
          scrollDirection: scrollDirection,
          padding: itemsPadding ?? EdgeInsets.symmetric(horizontal: 10),
          dataSet: model.coupons,
          isLoading: model.isBusy,
          noScrollPhysics: scrollDirection != Axis.horizontal,
          itemBuilder: (context, index) {
            //
            final coupon = model.coupons[index];
            // print("vendorType===>>${model.vendorType.id}");
             print("vendorType===>>${jsonEncode(coupon)}");
             print("code===>>${jsonEncode(coupon.code)}");
            //
            return Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CouponListItem(
                    coupon,
                    onPressed: isCartPage || isDetailPage ? null : model.couponSelected,
                  ).w(itemWidth ?? (context.percentWidth * 90)),
                ),
                isCartPage?  Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    child: Container(decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                    ),padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),child: Text(applyCouponIndex == index ? "Applied" : "Apply",style: TextStyle(color: Vx.white))),
                    onTap: (){
                      couponTEC.text = coupon.code;
                      updateApply();
                      applyCoupon();
                      applyCouponIndex = index;
                    },
                  ),
                ) : SizedBox()
              ],
            );
          },
          separatorBuilder: separator != null ? (ctx, index) => separator : null,
        );

        //
        return (model.coupons.isEmpty)
            ? UiSpacer.emptySpace()
            : VStack(
                [
                  //
                  Visibility(
                    visible: title != null && title.isNotBlank,
                    child: Padding(
                      padding: titlePadding ?? EdgeInsets.all(12),
                      child: Text(
                        "$title",
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
                    ),
                  ),

                  //vendors list
                  if (scrollDirection == Axis.horizontal)
                    listView.h(height ?? 195)
                  else
                    listView,
                  //
                  UiSpacer.vSpace(bPadding),
                ],
              );
      },
    );
  }

}
