import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/vendor_details.vm.dart';
import 'package:fuodz/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
import 'package:fuodz/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_leading.dart';
import 'package:fuodz/widgets/buttons/share.btn.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cart_page_action.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/horizontal_product.list_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/productgrid.dart';
import 'package:fuodz/widgets/Other_Busy_Loading.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../../../../widgets/list_items/sproductgrid.dart';




class VendorDetailsWithMenuPage extends StatefulWidget {
  VendorDetailsWithMenuPage({this.vendor, Key key}) : super(key: key);

  final Vendor vendor;

  @override
  _VendorDetailsWithMenuPageState createState() =>
      _VendorDetailsWithMenuPageState();
}

class _VendorDetailsWithMenuPageState extends State<VendorDetailsWithMenuPage>
    with TickerProviderStateMixin {

  int useGrid = 1;

  TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(context, widget.vendor),
      onModelReady: (model) async {
        await model.getVendorDetails();
        tabController = TabController(length: model.vendor.menus.length ?? 0, vsync: this);
      },
      builder: (context, model, child) {
        return BasePage(
          showCartView: true,
          elevation: 0,
          body: SafeArea(
              bottom: false,
              child: Scaffold(
                backgroundColor: context.theme.colorScheme.background,
                floatingActionButton: UploadPrescriptionFab(model),
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool scrolled) {
                    return <Widget>[

                      SliverAppBar(
                        floating: false,
                        pinned: true,
                        leading: CustomLeading(),
                        backgroundColor: context.theme.colorScheme.background,
                        actions: [

                          SizedBox(
                            width: 50,
                            height: 50,
                            child: FittedBox(
                              child: ShareButton(
                                model: model,
                              ),
                            ),
                          ),OutlinedButton.icon( // <-- OutlinedButton
                            onPressed: () =>{model.openVendorSearch()},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: context.theme.colorScheme.background, width: 1), //<-- SEE HERE
                            ),
                            icon: Icon(
                              FlutterIcons.search_fea,
                              size: 24.0,
                              color: Utils.textColorByBrightness(context),
                            ),
                            label: Text('search',style: TextStyle(color: Utils.textColorByBrightness(context))),
                          ),
                          UiSpacer.hSpace(10),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            child: PageCartAction(),
                          )
                        ],

                      ),

                      SliverToBoxAdapter(
                        child: VendorDetailsHeader(model, showFeatureImage: false),
                      ),

                      // SliverToBoxAdapter(
                      //   child: CustomSlidingSegmentedControl<int>(
                      //     isStretch: true,
                      //     initialValue: 1,
                      //     children: {
                      //       1: Text("Grid View"),
                      //       2: Text("List View"),
                      //     },
                      //     decoration: BoxDecoration(
                      //       color: context.isDarkMode ?Color(0xFF252733):context.theme.colorScheme.background,
                      //       borderRadius: BorderRadius.circular(25),
                      //       border: Border.fromBorderSide(
                      //         BorderSide(
                      //           color: AppColor.primaryColor,
                      //           width: 1.5,
                      //         ),
                      //       ),
                      //     ),
                      //     thumbDecoration: BoxDecoration(
                      //       color: context.isDarkMode ?Color(0xFF252733):context.theme.colorScheme.background,
                      //       borderRadius: BorderRadius.circular(20),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black.withOpacity(.4),
                      //           blurRadius: 5.0,
                      //           spreadRadius: 1.5,
                      //           offset: Offset(
                      //             0.0,
                      //             2.0,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     duration: Duration(milliseconds: 300),
                      //     highlightColor: Colors.red,
                      //     splashColor: Colors.green,
                      //     curve: Curves.easeInToLinear,
                      //     onValueChanged: (value) {
                      //       setState(() {
                      //         useGrid = value;
                      //       });
                      //     },
                      //   ).p16().centered(),
                      // ),




                      if (widget.vendor.vendorType.isFood)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Utils.textColorByBrightness(context), width: 1.6)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: model.tagsDataList.map((e) {
                                  return Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: model.selectedTag == e ? AppColor.primaryColor : null,
                                        shape: BoxShape.rectangle,
                                        borderRadius: model.selectedTag == e
                                            ? model.selectedTag == model.tagsDataList[0]
                                            ? BorderRadius.horizontal(left: Radius.circular(4.0))
                                            : model.selectedTag == model.tagsDataList[model.tagsDataList.length - 1]
                                            ? BorderRadius.horizontal(left: Radius.circular(4.0))
                                            : BorderRadius.zero
                                            : BorderRadius.zero
                                    ),
                                    child: e.name.text
                                        .semiBold
                                        .minFontSize(14.0)
                                        .maxFontSize(14.0)
                                        .color(model.selectedTag == e ? Colors.white : Utils.textColorByBrightness(context))
                                        .make(),
                                  ).centered()
                                      .onInkTap(() => model.onTagSelected(e, tabController.index));
                                }).toList(),
                              ),
                            ),
                          ),
                        ),




                      if (tabController != null)

                       SliverAppBar(
                          backgroundColor: context.theme.colorScheme.background,

                          title: "".text.make(),
                          floating: false,
                          pinned: true,
                          snap: false,
                          primary: false,
                          automaticallyImplyLeading: false,
                          flexibleSpace: TabBar(
                            isScrollable: true,
                            onTap: (int value) async {
                              try {
                                int temp_value = model.vendor.menus[value].id;
                                if (!model.menuProducts.containsKey(temp_value)) {
                                  model.setBusy(true);
                                  await model.loadMoreProducts(temp_value);
                                  model.setBusy(false);
                                }
                              } catch (e) {
                                print("exception: $e");
                              }
                            },
                            indicatorColor: Utils.textColorByBrightness(context),
                            indicatorWeight: 2,
                            controller: tabController,
                            labelColor: Utils.textColorByBrightness(context),
                            tabs: model.vendor.menus.map((menu) {
                              return Tab(text: menu.name.lowerCamelCase);
                            }).toList(),
                          ),
                        )
                    ];
                  },
                  scrollDirection: Axis.vertical,
                  body: tabController == null
                      ? const SizedBox.shrink()
                      : TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: model.vendor.menus.map((e) {
                      print("isBusy: ${model.isBusy}");
                      return CustomGridView(
                        refreshController: model.getRefreshController(e.id),
                        canPullUp: true,
                        canRefresh: true,
                        onRefresh: () => model.loadMoreProducts(e.id),
                        onLoading: () => model.loadMoreProducts(e.id, initialLoad: false),
                        dataSet: model.busy(e.id) ? [null, null, null, null, null, null] : model.menuProducts[e.id] ?? [],
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // isLoading: model.busy(e.id),
                        childAspectRatio: (context.screenWidth / 7.4) / 100,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          var product = null;
                          if (!model.busy(e.id)) {
                            product = model.menuProducts[e.id][index];
                          }
                          return SProductGridListItem(
                              product,
                              onPressed: model.productSelected,
                              qtyUpdated: ( product, int quantity, {bool isIncrement, bool isDecrement}) {
                                model.addToCartDirectly(product, quantity, isDecrement: isDecrement, isIncrement: isIncrement);
                              },
                              onNewQtyUpdated: (newTempProduct, value, increment, decrement) {
                                model.addToCartDirectly(newTempProduct, value, isDecrement: decrement, isIncrement: increment);
                              }
                          );
                        },
                        separatorBuilder: (p0, p1) => UiSpacer.verticalSpace(space: 20),
                      );
                    }).toList(),
                  ),


                )
          ),
        ));
      },
    );
  }
}