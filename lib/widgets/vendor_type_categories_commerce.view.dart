import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
// import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/vendor/categories.vm.dart';
import 'package:fuodz/views/pages/category/categories.page.dart';
// import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/category.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceTypeVendorTypeCategories extends StatefulWidget {
  const CommerceTypeVendorTypeCategories(
    this.vendorType, {
    this.title,
    this.description,
    this.showTitle = true,
    this.crossAxisCount,
    this.childAspectRatio,
    this.lessItemCount = 6,
    Key key,
  }) : super(key: key);

  //
  final VendorType vendorType;
  final String title;
  final String description;
  final bool showTitle;
  final int crossAxisCount;
  final double childAspectRatio;
  final int lessItemCount;
  @override
  _CommerceTypeVendorTypeCategoriesState createState() =>
      _CommerceTypeVendorTypeCategoriesState();
}

class _CommerceTypeVendorTypeCategoriesState
    extends State<CommerceTypeVendorTypeCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType),
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
                    .color(AppColor.primaryColor)
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
            CustomListView(
              scrollDirection: Axis.horizontal,
              dataSet: model.categories,
              isLoading: model.isBusy,
              itemBuilder: (context, index) {
                final category = model.categories[index];
                return CategoryListItem(
                  category: category,
                  onPressed: model.categorySelected,
                );
                /*
                return VStack(
                  [
                    //
                    CustomImage(
                      imageUrl: category.imageUrl,
                      width: 30,
                      height: 30,
                    ),

                    //
                    category.name.text.center
                        .color(Utils.isDark(Vx.hexToColor(category.color) ??
                                context.theme.colorScheme.background)
                            ? Colors.white
                            : Colors.black)
                        .medium
                        .sm
                        .maxLines(1)
                        .overflow(TextOverflow.ellipsis)
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  alignment: MainAxisAlignment.center,
                )
                    .p4()
                    .onInkTap(() {
                      model.categorySelected(category);
                    })
                    .box
                    .color(Vx.hexToColor(category.color) ??
                        context.theme.colorScheme.background)
                    .outerShadowSm
                    .clip(Clip.antiAlias)
                    .make()
                    .p2()
                    .w(62);
                    */
              },
            ).h(100),
          ],
        );
      },
    );
  }
}
