import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor/categories.vm.dart';
import 'package:fuodz/views/pages/category/categories.page.dart';
import 'package:fuodz/widgets/custom_dynamic_grid_view.dart';
import 'package:fuodz/widgets/list_items/category.list_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';

class VendorTypeCategories extends StatefulWidget {
  const VendorTypeCategories(
      this.vendorType, {
        this.title,
        this.description,
        this.showTitle = true,
        this.crossAxisCount,
        this.childAspectRatio,
        this.isService = false,
        Key key,
      }) : super(key: key);

  //
  final VendorType vendorType;
  final String title;
  final String description;
  final bool showTitle;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isService;
  @override
  _VendorTypeCategoriesState createState() => _VendorTypeCategoriesState();
}

class _VendorTypeCategoriesState extends State<VendorTypeCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType, isService: widget.isService),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            HStack(
              [
                VStack(
                  [
                    widget.showTitle
                        ? ((widget.title != null
                        ? widget.title
                        : "We are here for you")
                        .tr()
                        .text
                        .lg
                        .medium
                        .make())
                        : UiSpacer.emptySpace(),


                    Text(
                      (widget.description != null
                          ? widget.description
                          : "How can we help?"),
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
                    )
                  ],
                ).expand(),
                //
                (!isOpen ? "See all" : "Show less")
                    .tr()
                    .text
                    .color(Utils.textColorByBrightness(context))
                    .make()
                    .onInkTap(
                      () {
                    context.nextPage(
                      CategoriesPage(vendorType: widget.vendorType),
                    );
                  },
                ),
              ],
            ).p12(),

            //categories list
            CustomDynamicHeightGridView(
              crossAxisCount: AppStrings.categoryPerRow,
              itemCount: model.isBusy ? <int>[1,2,3,4,5,6, 7, 8, 9].length : model.categories.length,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              //isLoading: model.isBusy,
              isLoading: false,
              noScrollPhysics: true,
              //loadingWidget: const SizedBox.shrink(),
              itemBuilder: (ctx, index) {
                if (model.isBusy) {
                  return CategoryListItem();
                }
                return CategoryListItem(
                  category: model.isBusy ? null : model.categories[index],
                  onPressed: (Category category) {
                    model.categorySelected(category);
                  },
                  maxLine: false,
                );
              },
            ),
            // CustomGridView(
            //   // scrollDirection: Axis.horizontal,
            //   noScrollPhysics: true,
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   dataSet:
            //       (!isOpen && model.categories.length > widget.lessItemCount)
            //           ? model.categories.sublist(0, widget.lessItemCount)
            //           : model.categories,
            //   isLoading: model.isBusy,
            //   crossAxisCount: widget.crossAxisCount ?? 3,
            //   childAspectRatio: widget.childAspectRatio ?? 1.1,
            //   mainAxisSpacing: 10,
            //   crossAxisSpacing: 10,
            //   itemBuilder: (context, index) {
            //     //
            //     return CategoryListItem(
            //       category: model.categories[index],
            //       onPressed: model.categorySelected,
            //     );
            //   },
            // ),
          ],
        );
      },
    );
  }
}
