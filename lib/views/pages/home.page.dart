import 'dart:io';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_upgrade_settings.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/views/pages/profile/profile.page.dart';
import 'package:fuodz/view_models/home.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../utils/ui_spacer.dart';
import '../../view_models/orders.vm.dart';
import '../../widgets/custom_image.view.dart';
import '../../widgets/custom_list_view.dart';
import '../../widgets/states/error.state.dart';
import 'order/orders.page.dart';
import 'search/main_search.page.dart';
import 'welcome/widgets/cart.fab.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:fuodz/test/test.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, WidgetsBindingObserver {
  HomeViewModel vm;
  OrdersViewModel vmorder;

  PageController orderCotroller;
  int currentOrder = 0;

  @override
  void initState() {
    super.initState();
    configonesignal();
    orderCotroller  = PageController(initialPage: currentOrder,viewportFraction: 1.0);
    WidgetsBinding.instance?.addPostFrameCallback(
          (_) {
        LocationService.prepareLocationListener();
        vm?.initialise();
        vmorder.initialise();
      },
    );
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      print("Resumed");
      vmorder.fetchMyOrders();
    }
  }


  @override
  Widget build(BuildContext context) {
    vm = HomeViewModel(context);
    vmorder = OrdersViewModel(context);

    super.build(context);
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {

          return BasePage(
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: Stack(
                children: [

                  PageView(
                    controller: model.pageViewController,
                    onPageChanged: model.onPageChanged,
                    children: [
                      model.homeView,
                      OrdersPage(),
                      MainSearchPage(),
                      ProfilePage(),
                    ],
                  ),

                  if (model.currentIndex == 0)
                    Positioned(
                      bottom: 0.0,
                      child: ViewModelBuilder<OrdersViewModel>.reactive(
                          viewModelBuilder: () => vmorder,
                          onModelReady: (vm) => vm.initialise(),
                          disposeViewModel: false,
                          builder: (context, vmc, child) {
                            if (vmc.isAuthenticated() && vmc.orders.isNotEmpty) {
                              final orderDataList = vmc.orders.where((element) {
                                return ((element.status == "pending") || (element.status =="preparing") || (element.status =="ready")|| (element.status =="enroute")
                                    && (element.vendor.vendorType.slug == "food" && element.paymentMethod.slug =="cash"));
                              }).toList();
                              if (orderDataList.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                height: 100.0,
                                color: context.theme.colorScheme.background,
                                width: context.screenWidth,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [

                                    Flexible(
                                      child: PageView.builder(
                                          itemCount: orderDataList.length > 5 ? 5 : orderDataList.length,
                                          scrollDirection: Axis.horizontal,
                                          controller: orderCotroller,
                                          pageSnapping: true,
                                          padEnds: false,
                                          onPageChanged: (int value) {
                                            setState(() {
                                              currentOrder = value;
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            final order = orderDataList[index];
                                            return Container(
                                              height: 60.0,
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [

                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Text(
                                                            order.vendor.name..text.lg.medium.make().py4(),
                                                            style: TextStyle(
                                                                fontSize: 16.0
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1
                                                        ),

                                                        SizedBox(height: 5.0),
                                                        (order.status == "enroute")?
                                                        Text(
                                                            "Your order is on the way".tr(),
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                              color: Utils.textColorByBrightness(context),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1
                                                        ): Text(
                                                            "Your order is ${order.status}".tr(),
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Utils.textColorByBrightness(context),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1
                                                        )

                                                      ],
                                                    ),
                                                  ),

                                                  GestureDetector(
                                                    onTap: () => vmc.openOrderDetails(order),
                                                    child: Center(
                                                      child: Text(
                                                          "VIEW",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    ),

                                    Container(
                                      height: 30.0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [

                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: List.generate(orderDataList.length > 5 ? 5 : orderDataList.length, (index) {
                                              return SizedBox(
                                                height: 30.0,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                    height: 4.0,
                                                    width: 14.0,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        color:currentOrder == index ? Utils.textColorByBrightness(context) : Colors.grey.withOpacity(0.4)
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),

                                          const SizedBox(width: 12.0),

                                          if (currentOrder == 4)
                                            GestureDetector(
                                              onTap: () => AppService().changeHomePageIndex(index: 1),
                                              child: Container(
                                                height: 30.0,
                                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Text(
                                                  "show all",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14.0
                                                  ),
                                                ),
                                              ),
                                            )


                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }
                      ),
                    ),

                  ViewModelBuilder<OrdersViewModel>.reactive(
                    viewModelBuilder: () => vmorder,
                    onModelReady: (vm) => vm.initialise(),
                    disposeViewModel: false,
                    builder: (context, vmc, child) {
                      double bottomPosition = 20.0;
                      if (vmc.isAuthenticated() && vmc.orders.isNotEmpty) {
                        final orderDataList = vmc.orders.where((element) {
                          return ((element.status == "pending") || (element.status =="preparing") || (element.status =="ready")|| (element.status =="enroute")
                              && (element.vendor.vendorType.slug == "food" && element.paymentMethod.slug =="cash"));
                        }).toList();
                        if (orderDataList.isNotEmpty && model.currentIndex == 0) {
                          bottomPosition = 120.0;
                        }
                      }
                      return Positioned(
                          bottom: bottomPosition,
                          right: 12.0,
                          child: CartHomeFab(model)
                      );
                    },
                  ),

                ],
              ),
            ),
            // fab: CartHomeFab(model),
            // fab: Column(
            //
            //  mainAxisAlignment: MainAxisAlignment.end,
            //  crossAxisAlignment: CrossAxisAlignment.end,
            //  mainAxisSize: MainAxisSize.min,
            //  children:[
            //     CartHomeFab(model),
            //
            //    if (model.currentIndex == 0)...[
            //
            //     ViewModelBuilder<OrdersViewModel>.reactive(
            //       viewModelBuilder: () => vmorder,
            //       onModelReady: (vm) => vm.initialise(),
            //       disposeViewModel:false,
            //       builder: (context, vmc, child) {
            //         if (vmc.isAuthenticated() && vmc.orders.isNotEmpty && vmc.orders.any((element) => (element.status == "pending") || ( element.status == "preparing") || (element.status =="ready")|| (element.status =="enroute") && (element.vendor.vendorType.slug == "food" && element.paymentMethod.slug=="cash"))) {
            //           final orderDataList = vmc.orders.where((element) {
            //             return ((element.status == "pending") || (element.status =="preparing") || (element.status =="ready")|| (element.status =="enroute")
            //                 && (element.vendor.vendorType.slug == "food" && element.paymentMethod.slug =="cash"));
            //           }).toList();
            //           return Container(
            //             height: 80.0,
            //             color: Colors.grey,
            //             // margin: const EdgeInsets.only(top: 8.0),
            //             // padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            //             width: context.screenWidth,
            //             child: PageView.builder(
            //               itemCount: orderDataList.length,
            //               scrollDirection: Axis.horizontal,
            //               controller: orderCotroller,
            //               pageSnapping: true,
            //               padEnds: false,
            //               onPageChanged: (int value) {
            //
            //               },
            //               itemBuilder: (context, index) {
            //                 final order = orderDataList[index];
            //                 return Column(
            //                   mainAxisSize: MainAxisSize.max,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //
            //                     SizedBox(
            //                       height: 55,
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //
            //                           Expanded(
            //                             child: Column(
            //                               mainAxisAlignment: MainAxisAlignment.center,
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //
            //                                 Text(
            //                                   order.vendor.name..text.lg.medium.make().py4(),
            //                                   style: TextStyle(
            //                                     fontSize: 16.0
            //                                   ),
            //                                   overflow: TextOverflow.ellipsis,
            //                                   maxLines: 1
            //                                 ),
            //
            //                                 SizedBox(height: 5.0),
            //
            //                                 Text(
            //                                   "Your order is ${order.status}".tr(),
            //                                   style: TextStyle(
            //                                     fontSize: 14.0
            //                                   ),
            //                                   overflow: TextOverflow.ellipsis,
            //                                   maxLines: 1
            //                                 )
            //
            //                               ],
            //                             ),
            //                           ),
            //
            //                           GestureDetector(
            //                             onTap: () => vmc.openOrderDetails(order),
            //                             child: Text(
            //                               "VIEW",
            //                               textAlign: TextAlign.center,
            //                               style: TextStyle(
            //                                 fontWeight: FontWeight.bold
            //                               )
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //
            //                   ],
            //                 );
            //               },
            //             ),
            //           );
            //         //   return Column(
            //         //     mainAxisAlignment: MainAxisAlignment.center,
            //         //     crossAxisAlignment: CrossAxisAlignment.center,
            //         //     mainAxisSize: MainAxisSize.min,
            //         //     children: [
            //         //
            //         //       Container(
            //         //         width: context.screenWidth,
            //         //         child: PageView.builder(
            //         //           padEnds: true,
            //         //           pageSnapping: true,
            //         //           clipBehavior: Clip.antiAlias,
            //         //           controller: orderCotroller,
            //         //           scrollDirection: Axis.horizontal,
            //         //           itemCount: vmc.orders.length,
            //         //           onPageChanged: (value) {
            //         //             if (mounted) {
            //         //               setState(() {
            //         //                 currentOrder = value;
            //         //               });
            //         //             }
            //         //           },
            //         //           itemBuilder:(context, index) {
            //         //             final order = vmc.orders[index];
            //         //             if ( (order.status == "pending") || (order.status =="preparing") || (order.status =="ready")|| (order.status =="enroute")
            //         //             && (order.vendor.vendorType.slug == "food" && order.paymentMethod.slug =="cash")) {
            //         //               return Container(
            //         //               height: 100,
            //         //               width: context.screenWidth,
            //         //               decoration: BoxDecoration(
            //         //                 color: Theme.of(context).cardColor,
            //         //                 borderRadius:BorderRadius.circular(20)
            //         //               ),
            //         //              // margin: EdgeInsets.all(8.0),
            //         //               child: Stack(
            //         //                 alignment: Alignment.bottomCenter,
            //         //                 // mainAxisAlignment: MainAxisAlignment.center,
            //         //                 // crossAxisAlignment: CrossAxisAlignment.start,
            //         //                 // mainAxisSize: MainAxisSize.min,
            //         //                 children: [
            //         //                   ClipRRect(
            //         //                     borderRadius:BorderRadius.circular(20),
            //         //                     child: CustomImage(
            //         //                       imageUrl: order.vendor.logo,
            //         //                       height: context.screenHeight,
            //         //                       width: context.screenWidth,
            //         //                       boxFit: BoxFit.cover,
            //         //                     ),
            //         //                   ),
            //         //
            //         //
            //         //                   Container(
            //         //                     height: 55,
            //         //                     width: context.screenWidth,
            //         //                     padding: const EdgeInsets.all(5.0),
            //         //                     decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.6)),
            //         //                     child:
            //         //                      Row(
            //         //                       mainAxisAlignment: MainAxisAlignment.center,
            //         //                       crossAxisAlignment: CrossAxisAlignment.start,
            //         //                      mainAxisSize: MainAxisSize.min,
            //         //                       children: [
            //         //                         Padding(
            //         //                           padding: const EdgeInsets.all(8.0),
            //         //                           child: Icon(FlutterIcons.CodeSandbox_ant),
            //         //                         ),
            //         //                         SizedBox(width: 5.0),
            //         //                         Expanded(
            //         //                           child: Column(
            //         //                             mainAxisAlignment: MainAxisAlignment.center,
            //         //                             crossAxisAlignment: CrossAxisAlignment.start,
            //         //                            // mainAxisSize: MainAxisSize.min,
            //         //                             children: [
            //         //                               Text(order.vendor.name..text.lg.medium.make().py4(),style: TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis,maxLines: 1),
            //         //                               SizedBox(height: 5.0),
            //         //                               Text("Your order is ${order.status}".tr(),style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1)
            //         //                             ],
            //         //                           ),
            //         //                         ),
            //         //
            //         //                         GestureDetector(
            //         //                           onTap: () => vmc.openOrderDetails(order),
            //         //                           child: Padding(
            //         //                             padding: const EdgeInsets.all(8.0),
            //         //                             child: Text("VIEW",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            //         //                           ),
            //         //                         )
            //         //                       ],
            //         //                     ),
            //         //                   ),
            //         //                 ],
            //         //               ),
            //         //             );
            //         //           } else {
            //         //            return SizedBox.shrink();
            //         //           }
            //         //         },
            //         //       ),
            //         // ),
            //         //
            //         //       Center(
            //         //         child: Container(
            //         //           height: 8.0,
            //         //           alignment: Alignment.center,
            //         //           child: Row(
            //         //             mainAxisAlignment: MainAxisAlignment.center,
            //         //             crossAxisAlignment: CrossAxisAlignment.center,
            //         //             children: List.generate(
            //         //               vmc.orders.length, (index) {
            //         //                 final order = vmc.orders[index];
            //         //                 if ((order.status == "pending") || (order.status =="preparing") || (order.status =="ready")|| (order.status =="enroute")
            //         //                 && (order.vendor.vendorType.slug == "food" && order.paymentMethod.slug=="cash")) {
            //         //                   return Container(
            //         //                     margin: EdgeInsets.symmetric(horizontal: 3.0,vertical: 3.0),
            //         //                     height: 8.0,width: 8.0,color:currentOrder == index ? Theme.of(context).primaryColor : Colors.white,
            //         //                   );
            //         //                 }  else {
            //         //                   return Container();
            //         //                 }
            //         //               }
            //         //             )
            //         //           ),
            //         //         ),
            //         //       )
            //         //     ],
            //         //   );
            //         } else {
            //            return SizedBox.shrink();
            //         }
            //
            //       }),
            //     // Center(
            //     //   child: Container(
            //     //     height: 8.0,
            //     //     alignment: Alignment.center,
            //     //     child: ViewModelBuilder<OrdersViewModel>.reactive(
            //     //       viewModelBuilder: () => vmorder,
            //     //       onModelReady: (vm) => vm.initialise(),
            //     //       builder: (context, vm, child) {
            //     //         if (vm.orders.isNotEmpty && vm.orders.any((element) => (element.status == "pending")
            //     //     || (element.status =="preparing") || (element.status =="ready")|| (element.status =="enroute")
            //     //      && (element.vendor.vendorType.slug == "food" && element.paymentMethod.slug=="cash"))) {
            //     //         return Row(
            //     //           mainAxisAlignment: MainAxisAlignment.center,
            //     //           crossAxisAlignment: CrossAxisAlignment.center,
            //     //           children: List.generate(
            //     //             vm.orders.length, (index) {
            //     //               final order = vm.orders[index];
            //     //               if ((order.status == "pending") || (order.status =="preparing") || (order.status =="ready")|| (order.status =="enroute")
            //     //               && (order.vendor.vendorType.slug == "food" && order.paymentMethod.slug=="cash")) {
            //     //                 return Container(
            //     //                   margin: EdgeInsets.symmetric(horizontal: 3.0,vertical: 3.0),
            //     //                   height: 8.0,width: 8.0,color:currentOrder == index ? Theme.of(context).primaryColor : Colors.white,
            //     //                 );
            //     //               }
            //     //               return Container();
            //     //             }   ));
            //     //      } else {
            //     //       return SizedBox.shrink();
            //     //      }
            //     //       }),
            //     //   ),
            //     // ),
            //     ]
            //   ],
            // ),
            bottomNavigationBar: VxBox(
              child: SafeArea(
                top: false,
                child: GNav(
                  gap: 8,
                  activeColor: Colors.white,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  duration: Duration(milliseconds: 250),
                  tabBackgroundColor: Theme.of(context).colorScheme.secondary,
                  tabs: [
                    GButton(
                      icon: FlutterIcons.home_ant,
                      text: 'Home'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.inbox_ant,
                      text: 'Orders'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.search_fea,
                      text: 'Search'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.menu_fea,
                      text: 'More'.tr(),
                    ),
                    // GButton(
                    //   icon: FlutterIcons.menu_fea,
                    //   text: 'test'.tr(),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => MyHomePage(title: 'Genie')),
                    //     );
                    //   },
                    // )
                  ],
                  selectedIndex: model.currentIndex,
                  onTabChange: model.onTabChange,
                ),
              ),
            )
                .p16

                .color(context.theme.colorScheme.background)
                .make(),
          );
        },
      ),
    );
  }

  void configonesignal() async{
    await OneSignal.shared.setAppId('6ecd993d-7e19-461a-945b-63d5e604bf08');
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      OSNotificationDisplayType.notification;

    });
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });


    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      setState(() {});
    });

    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      debugPrint('FOREGROUND HANDLER CALLED WITH: ${event}');
      /// Display Notification, send null to not display
      event.complete(null);

      setState(() {

      });
    });


  }


  @override
  bool get wantKeepAlive => true;
}