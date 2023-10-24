import 'package:flutter/material.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor_category_products.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/sproductgrid.dart';
import 'package:fuodz/widgets/list_items/service.gridview_item.dart';
import 'package:fuodz/widgets/states/product.empty.dart';
import 'package:fuodz/widgets/states/service_search.empty.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/utils/utils.dart';
class VendorCategoryProductsPage extends StatefulWidget {
  VendorCategoryProductsPage({this.category, this.vendor, Key key, this.isService = false})
      : super(key: key);

  final Category category;
  final Vendor vendor;
  final bool isService;

  @override
  _VendorCategoryProductsPageState createState() =>
      _VendorCategoryProductsPageState();
}

class _VendorCategoryProductsPageState extends State<VendorCategoryProductsPage>
    with TickerProviderStateMixin {
  //
  TabController tabBarController;

  @override
  void initState() {
    super.initState();
    if (widget.category.hasSubcategories) {
      tabBarController = TabController(
        length: widget.category.subcategories.length,
        vsync: this,
      );
    }
  }



  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorCategoryProductsViewModel>.reactive(
      viewModelBuilder: () => VendorCategoryProductsViewModel(
          context,
          widget.category,
          widget.vendor,
          isService: widget.isService
      ),
      onModelReady: (vm) => vm.initialise(),
      //BasePage(
      //
      //             body: SafeArea(
      //             bottom: false,
      //             child:
      builder: (context, model, child) {
        return BasePage(
          title: model.category.name,
          showAppBar: true,
          elevation: 0,
          appBarColor: Color(0xFF14151F),
          appBarItemColor: Utils.textColorByBrightness(context),
          showLeadingAction: true,
          showCartView: true,
          showCart: true,
          body: !model.category.hasSubcategories
              ? model.isService
              ? EmptyServiceSearch()
              : EmptyProduct()
              : Row(

            children:[
              RotatedBox(
                  quarterTurns: 1,
                  child: SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ColoredBox(

                      color:Colors.white,



                      child: TabBar(
                        indicator: BoxDecoration(
                          color:  Colors.grey
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),

                        ),
                          indicatorPadding: EdgeInsets.only( bottom: 4.0),
                        labelColor: Utils.textColorByBrightness(context),
                        unselectedLabelColor: Utils.textColorByBrightness(context),
                        isScrollable: true,
                        indicatorColor: Colors.black,
                        indicatorWeight: 1,
                        controller: tabBarController,
                        tabs: model.category.subcategories.map(
                              (subcategory) {
                            return Tab(
                              child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Column(
                                    children: [
                                      CustomImage(imageUrl: subcategory.imageUrl,

                                      ).wh(Vx.dp48, Vx.dp48)
                                          .box
                                          .rounded
                                          .clip(Clip.antiAlias)
                                          .make(),
                                      Text(subcategory.name,
                                        style: TextStyle(fontFamily: GoogleFonts.rubik().fontFamily, fontSize: 8 ),

                                      ),



                                    ],
                                  )




                              ),

                            );
                          },
                        ).toList(),
                      ),


                    ),



                  )
              ),





              Flexible(
                child: Container(
                  child: TabBarView(
                    controller: tabBarController,
                    children: model.category.subcategories.map(
                          (subcategory) {
                        //
                        if (model.categoriesProducts[subcategory.id] != null && model.categoriesProducts[subcategory.id].isEmpty) {
                          return model.isService
                              ? EmptyServiceSearch()
                              : EmptyProduct();
                        }
                        return CustomGridView(
                          refreshController: model.getRefreshController(subcategory.id),
                          canPullUp: true,
                          canRefresh: true,
                          onRefresh: () => model.loadMoreProducts(subcategory.id),
                          onLoading: () => model.loadMoreProducts(
                            subcategory.id,
                            initialLoad: false,
                          ),
                          padding: EdgeInsets.all(8),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          dataSet: model.categoriesProducts[subcategory.id] ?? [],
                          childAspectRatio: (context.screenWidth / 9) / 100,
                          isLoading: model.busy(subcategory.id),
                          itemBuilder: (context, index) {

                            final customData =
                            (model.categoriesProducts[subcategory.id] ??
                                [])[index];

                            if (customData is Product) {
                              return SProductGridListItem(

                                customData,
                                onPressed: model.productSelected,
                                //qtyUpdated: model.addToCartDirectly,
                                qtyUpdated: ( product, int quantity, {bool isIncrement, bool isDecrement}) {
                                  model.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                                },
                                //qtyUpdated: (product, value) {},
                                onNewQtyUpdated: (newTempProduct, value,
                                    increment, decrement) {
                                  model.addToCartDirectly(newTempProduct, value,
                                      isDecrement: decrement,
                                      isIncrement: increment);
                                },

                              );
                            }

                            if (customData is Service) {
                              return ServiceGridViewItem(
                                service: customData,
                                onPressed: model.serviceSelected,
                              );
                            }
                          },
                          separatorBuilder: (p0, p1) => UiSpacer.verticalSpace(space: 500),

                        );

                      },
                    ).toList(),
                  ),
                ),
              ),

            ],
          ));


      },
    );
  }
}

