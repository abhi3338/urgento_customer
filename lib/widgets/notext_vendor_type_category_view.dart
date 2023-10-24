import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor/categories.vm.dart';
import 'package:fuodz/views/pages/category/categories.page.dart';
import 'package:fuodz/widgets/custom_dynamic_grid_view.dart';
import 'package:fuodz/widgets/list_items/notextcategoryitem.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';

class NoVendorTypeCategories extends StatefulWidget {
  const NoVendorTypeCategories(
      this.vendorType, {
        this.title,
        this.description,
        this.showTitle = true,
        this.crossAxisCount,
        this.childAspectRatio,
        Key key,
        this.loadingWidget,

        this.isGroceryPage = false
      }) : super(key: key);

  //

  final Widget loadingWidget;
  final VendorType vendorType;
  final String title;
  final String description;
  final bool showTitle;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isGroceryPage;
  @override
  _VendorTypeCategoriesState createState() => _VendorTypeCategoriesState();
}

class _VendorTypeCategoriesState extends State<NoVendorTypeCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType, isGrocery: widget.isGroceryPage),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            if (!model.isBusy) ...[
              HStack(
                [
                  VStack(
                    [
                      widget.showTitle
                          ?Text(
                         widget.title,
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

                          : UiSpacer.emptySpace(),
                      (widget.description != null
                          ? widget.description
                          : "How can we help?")
                          .tr()
                          .text
                          .xl
                          .semiBold
                          .make(),
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
            ],

            //categories list
            CustomDynamicHeightGridView(
              crossAxisCount: AppStrings.categoryPerRow,
              itemCount: model.isBusy ? 6 : model.categories.length,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              isLoading: false,
              //isLoading: model.isBusy,
              //loadingWidget: widget.loadingWidget,
              noScrollPhysics: true,
              itemBuilder: (ctx, index) {
                return NoCategoryListItem(
                  category: model.isBusy ? null : model.categories[index],
                  onPressed: (Category category) => model.categorySelected(category),
                  maxLine: false,
                  // hasText: model.vendorType.isPharmacy?true:false,
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
