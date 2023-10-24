
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/section_vendors.vm.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/food_vendor.list_item.dart';
import 'package:fuodz/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:fuodz/widgets/list_items/vendor.list_item.dart';
import 'package:fuodz/widgets/section.title.dart';
import 'package:fuodz/widgets/states/vendor.empty.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/utils.dart';

class SectionVendorsView extends StatelessWidget {
  const SectionVendorsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = SearchFilterType.fresh,
    this.itemWidth,
    this.viewType,
    this.separator,
    this.byLocation = false,
    this.itemsPadding,
    this.titlePadding,
    Key key,
        this.loadingWidget
  }) : super(key: key);

  final VendorType vendorType;
  final Axis scrollDirection;
  final SearchFilterType type;
  final String title;
  final double itemWidth;
  final dynamic viewType;
  final Widget separator;
  final bool byLocation;
  final EdgeInsets itemsPadding;
  final EdgeInsets titlePadding;
  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      visible: !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<SectionVendorsViewModel>.reactive(
        viewModelBuilder: () => SectionVendorsViewModel(
          context,
          vendorType,
          type: type,
          byLocation: byLocation,
        ),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //
          Widget listView = CustomListView(
            scrollDirection: scrollDirection,
            padding: itemsPadding ?? EdgeInsets.symmetric(horizontal: 10),
            dataSet: model.vendors,
            isLoading: model.isBusy,
            loadingWidget: loadingWidget,
            noScrollPhysics: scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              //
              final vendor = model.vendors[index];
              //
              if (viewType != null && viewType == HorizontalVendorListItem) {
                return FittedBox(
                    child: FoodVendorListItem(
                      vendor: vendor,
                      onPressed: model.vendorSelected,
                    ).w(itemWidth ?? (context.percentWidth * 50)));
              } else if (vendor.vendorType.isFood) {
                return FittedBox(
                    child: FoodVendorListItem(
                  vendor: vendor,
                  onPressed: model.vendorSelected,
                ).w(itemWidth ?? (context.percentWidth * 50)));
              } else {
                //
                return FittedBox(
                    child: FoodVendorListItem(
                      vendor: vendor,
                      onPressed: model.vendorSelected,
                    ).w(itemWidth ?? (context.percentWidth * 50)));
              }
            },
            emptyWidget: EmptyVendor(),
            separatorBuilder:
                separator != null ? (ctx, index) => separator : null,
          );

          //
          return VStack(
            [
              //
              if (!model.isBusy)
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
              if (model.vendors.isEmpty)
                listView.h(model.vendors.isEmpty ? 240 : 195)
              else if (scrollDirection == Axis.horizontal)
                listView.h(195)
              else
                listView
            ],
          );
        },
      ),
    );
  }
}
