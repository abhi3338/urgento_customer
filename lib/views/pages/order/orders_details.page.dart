import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/views/pages/order/widgets/order.bottomsheet.dart';
import 'package:fuodz/views/pages/order/widgets/order_address.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_attachment.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_details_driver_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_details_items.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_details_vendor_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_status.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/cards/order_details_summary.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';
import 'package:fuodz/resources/resources.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/services/location.service.dart';

import 'package:fuodz/utils/map.utils.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({
    this.order,
    Key key,
    this.isOrderTracking = false,
  }) : super(key: key);

  //
  final Order order;
  final bool isOrderTracking;


  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}


class _OrderDetailsPageState extends State<OrderDetailsPage>
    with WidgetsBindingObserver {
  //
  OrderDetailsViewModel vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      vm.fetchOrderDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    vm = OrderDetailsViewModel(context, widget.order);

    //
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => vm,
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        final dt1 = DateTime.parse('${Jiffy(vm.order.createdAt).format('yyyy-MM-dd HH:mm:ss')}');
        final dt2 = DateTime.parse('${Jiffy(vm.order.updatedAt).format('yyyy-MM-dd HH:mm:ss')}');

        Duration diff2 = dt2.difference(dt1);
        final HH = (diff2.inHours).toString().padLeft(2, '0');
        final mm = (diff2.inMinutes % 60).toString().padLeft(2, '0');
        final ss = (diff2.inSeconds % 60).toString().padLeft(2, '0');
        final cdate = '$HH hr:$mm min :$ss sec ';

        return BasePage(
          title: "Order Details of #${vm.order.code}".tr(),
          showAppBar: true,
          showLeadingAction: true,
          isLoading: vm.isBusy,
          onBackPressed: () {
            context.pop(vm.order);
          },
          //share button for parcel delivery order
          actions: vm.order.isPackageDelivery
              ? [
            Icon(
              FlutterIcons.share_2_fea,
              color: Colors.white,
            ).p8().onInkTap(vm.shareOrderDetails).p8(),
          ]
              : null,
          body: vm.isBusy
              ? BusyIndicator().centered()
              : SmartRefresher(
            controller: vm.refreshController,
            onRefresh: vm.fetchOrderDetails,
            child: Stack(
              children: [
                //vendor details

                //
                VStack(
                  [

                    CustomVisibilty(
                        visible: (vm.order.dropoffLocation != null ||
                            vm.order.deliveryAddress != null)&&(AppStrings.enableOrderTracking)&&(vm.order.driverId != null)&& !(vm.order.status == "delivered"),
                        child:Container(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              //
                              GoogleMap(
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: true,
                                buildingsEnabled: true,
                                tiltGesturesEnabled: false,
                                gestureRecognizers: Set()
                                  ..add( Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),


                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    LocationService?.currenctAddress?.coordinates?.latitude ??
                                        0.00,
                                    LocationService?.currenctAddress?.coordinates?.longitude ??
                                        0.00,
                                  ),
                                  zoom: 14,
                                ),
                                padding: EdgeInsets.only(bottom: Vx.dp64 * 2),
                                markers: vm.orderTrackingViewModel.mapMarkers,
                                polylines: Set<Polyline>.of(vm.orderTrackingViewModel.polylines.values),
                                onMapCreated: vm.orderTrackingViewModel.setMapController,
                              ),
                            ],
                          ),
                        )),

                    UiSpacer.verticalSpace(space: 5),
                    Visibility(
                      visible:
                      !vm.order.isTaxi && !vm.order.isSerice && !(vm.order.status == "delivered")&& !(vm.order.status == "cancelled")&& !(vm.order.status == "failed"),
                      child:
                      "Your Order Delivers in ${vm.order.vendor.deliveryTime} Min🔥🥳".text.bold.xl.makeCentered().px20(),
                    ),
                    UiSpacer.verticalSpace(space: 5),
                    VStack(
                      [

                        Visibility(
                            visible:
                            vm.order.status == "delivered" ,
                            child:VStack([
                              "Your Order Delivered in".text.bold.xl.makeCentered().px20(),
                              " ${cdate}   ".text.bold.xl.makeCentered().px20()

                            ])

                        ),



                        Visibility(
                            visible: (vm.order.status == "pending"),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.pending,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                          visible: (vm.order.status == "pending"),
                          child:
                          "We are confirming your order. If its taking time to confirm contact us from below".text.bold.lg.makeCentered().px20(),
                        ),


                        Visibility(
                            visible: (vm.order.status == "preparing" && vm.order.vendor.vendorType.isFood),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.preparing,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "preparing" && vm.order.vendor.vendorType.isGrocery),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.grocpre,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "preparing" && vm.order.vendor.vendorType.isParcel && vm.order.vendor.vendorType.isCommerce && vm.order.vendor.vendorType.isService),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.parpre,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "preparing" && vm.order.vendor.vendorType.isService),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.parpre,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),





                        Visibility(
                          visible: (vm.order.status == "preparing"),
                          child:
                          "We are preparing your order. If its taking time to confirm contact us from below".text.bold.lg.makeCentered().px20(),
                        ),


                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isFood),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.ready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isPharmacy),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.pready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isTaxi),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.tready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isGrocery),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.gready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isParcel),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.sready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                            visible: (vm.order.status == "ready" && vm.order.vendor.vendorType.isService),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.hsready,
                                  height: 200.0,
                                  width: 250.0,



                                )


                            )),

                        Visibility(
                          visible: (vm.order.status == "ready"),
                          child:
                          "Your order is ready for delivery. If u have any issue contact us from below".text.bold.lg.makeCentered().px20(),
                        ),


                        Visibility(
                            visible: (vm.order.status == "enroute"),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.enroute,
                                  height: 200.0,
                                  width: 500.0,



                                )


                            )),

                        Visibility(
                          visible: (vm.order.status == "enroute"),
                          child:"Delivery boy on the way to deliver your order. If u have any issue contact us from below".text.bold.lg.makeCentered().px20(),
                        ),


                        Visibility(
                            visible: (vm.order.status == "delivered"),
                            child:Align(
                                alignment: Alignment.center,
                                child: Image.asset( AppImages.delivered,
                                  height: 200.0,
                                  width: 500.0,



                                )


                            )),

                        UiSpacer.verticalSpace(space: 10),


                        OrderPaymentInfoView(vm),
                        UiSpacer.verticalSpace(space: 10),

                        Card(
                          color: context.theme.colorScheme.background,
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: HStack(<String>["Share app & Earn", "Live Support", "What's app","Call"].map((e) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                              alignment: Alignment.center,
                              child: HStack([

                                Image.asset(
                                  e == "Live Support" ?
                                  AppIcons.livesupport
                                      :e == "What's app" ? AppIcons.hom
                                      :e == "Call" ? AppIcons.call
                                      : AppIcons.refer,
                                  width: 18,
                                  height: 18,
                                ),



                                UiSpacer.horizontalSpace(space: 6.0),

                                e.tr().trim().text.color(Utils.textColorByBrightness(context)).minFontSize(10.0).maxFontSize(10.0).make().flexible()
                              ]),
                            ).onInkTap(() {

                              if (e == "Live Support") {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
                              } else if (e == "What's app") {
                                launchWhatsApp();
                              }else if (e == "Call") {
                                vm.callsup();
                              } else {
                                vm.profileViewModel.openRefer();
                              }
                            })
                                .expand();
                          }).toList()),
                        ),

                        UiSpacer.verticalSpace(space: 5),

                        OrderDetailsDriverInfoView(vm),
                        UiSpacer.verticalSpace(space: 5),
                        Visibility(
                          visible: (vm.order.status == "deliered"),
                          child:
                          "We have successfully delivered your order. If any issue with order contact us from below".text.bold.lg.makeCentered().px20(),
                        ),




                        //free space
                        //header view
                        HStack(
                          [
                            //vendor logo
                            CustomImage(
                              imageUrl: vm.order.vendor.logo,
                              width: 50,
                              height: 50,
                            ).box.roundedSM.clip(Clip.antiAlias).make(),
                            UiSpacer.horizontalSpace(),
                            //
                            VStack(
                              [
                                //
                                "${vm.order.vendor.name.tr().allWordsCapitilize() ?? vm.order.status.tr()}"
                                    .text
                                    .semiBold
                                    .lg
                                    .color(AppColor.primaryColor)
                                    .make(),


                                "${Jiffy(vm.order.updatedAt).format('MMM dd, yyyy \| HH:mm:ss')}"
                                    .text
                                    .light
                                    .lg
                                    .make(),
                                "#${vm.order.code}"
                                    .text
                                    .xs
                                    .gray400
                                    .light
                                    .make(),
                              ],
                            ).expand(),
                            //qr code icon

                            VStack(

                                [

                                  Visibility(
                                    visible:
                                    !vm.order.isTaxi && !vm.order.isSerice,
                                    child: Icon(
                                      FlutterIcons.qrcode_ant,
                                      size: 28,
                                    ).onInkTap(vm.showVerificationQRCode),
                                  ),

                                  "${vm.order.status.tr().allWordsCapitilize() ?? vm.order.status.tr()}"
                                      .text
                                      .semiBold
                                      .xl
                                      .color(AppColor.getStausColor(
                                      vm.order.status))
                                      .make(),

                                ]
                            )

                          ],
                        ).p20().wFull(context),
                        //
                        UiSpacer.cutDivider(),
                        //Payment status






                        /* CustomVisibilty(
                                visible: (vm.order.dropoffLocation != null ||
                                    vm.order.deliveryAddress != null)&&(AppStrings.enableOrderTracking)&&(vm.order.driverId != null),
                                child:vm.order.showStatusTracking
                                    ?CustomButton(
                                  title: "Live Track Order On Map".tr(),
                                  icon: FlutterIcons.map_ent,
                                  onPressed: vm.trackOrder,
                                  loading: vm.busy(vm.order),
                                ).p20()
                                    : UiSpacer.emptySpace(),

                              ),*/
                        //driver

                        //status
                        Visibility(
                          // visible: vm.order.showStatusTracking,
                          child: VStack(
                            [
                              OrderStatusView(vm).p20(),
                              UiSpacer.divider(),
                            ],
                          ),
                        ),
                        // either products/package details
                        OrderDetailsItemsView(vm).p20(),
                        //show package delivery addresses
                        Visibility(
                          visible: vm.order.deliveryAddress != null,
                          child: OrderAddressesView(vm).p20(),
                        ),
                        //
                        OrderAttachmentView(vm),
                        //
                        CustomVisibilty(
                          visible: (!vm.order.isPackageDelivery &&
                              vm.order.deliveryAddress == null),
                          child: "Customer Order Pickup"
                              .tr()
                              .text
                              .italic
                              .light
                              .xl
                              .medium
                              .make()
                              .px20()
                              .py20(),
                        ),

                        //note
                        "Note".tr().text.semiBold.xl.make().px20(),
                        "${vm.order.note}".text.light.sm.make().px20(),
                        UiSpacer.verticalSpace(),

                        UiSpacer.cutDivider(),
                        //vendor
                        OrderDetailsVendorInfoView(vm),



                        UiSpacer.cutDivider(color: Vx.gray200),
                        //order summary
                        OrderDetailsSummary(vm.order)
                            .wFull(context)
                            .p20()
                            .pOnly(bottom: context.percentHeight * 10)
                            .box
                            .make()
                      ],
                    )
                        .box
                        .topRounded(value: 15)
                        .clip(Clip.antiAlias)
                        .color(context.isDarkMode ?Color(0xFF14151F):context.theme.colorScheme.background,)
                        .make(),
                    //
                    UiSpacer.vSpace(50),
                  ],
                ).scrollVertical(),
              ],
            ),
          ),
          bottomSheet: widget.isOrderTracking ? null : OrderBottomSheet(vm),
        );
      },
    );
  }
}