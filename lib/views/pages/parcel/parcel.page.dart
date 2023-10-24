import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/parcel.vm.dart';
import 'package:fuodz/views/pages/parcel/new_parcel.page.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:fuodz/widgets/list_items/vendor_type.list_item.dart';
import 'package:fuodz/widgets/recent_orders.view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_images.dart';


class ParcelPage extends StatefulWidget {
  ParcelPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  _ParcelPageState createState() => _ParcelPageState();
}

class _ParcelPageState extends State<ParcelPage> {
  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParcelViewModel>.reactive(
      viewModelBuilder: () =>
          ParcelViewModel(context, vendorType: widget.vendorType),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          showLogo:true,
          showCart: true,
          title: "${vm.vendorType.name}",
          appBarItemColor: Utils.textColorByBrightness(context),
          key: vm.pageKey,
          backgroundColor:Color(0xFFE2DBFD),
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: vm.refreshController,
            onRefresh: vm.reloadPage,
            child: VStack(
              [

                // Container(
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(35.0),
                //       bottomRight: Radius.circular(35.0),
                //     ),
                //     child: CachedNetworkImage(
                //
                //
                //       imageUrl: 'https://superappadmin.aworkconnect.in/imghost/picklogo.png',
                //       placeholder: (context, url) => Shimmer.fromColors(
                //         baseColor: Colors.grey[300],
                //         highlightColor: Colors.grey[100],
                //         child: Container(
                //           color: Colors.white, // Optional background color for shimmer
                //         ),
                //       ),
                //       errorWidget: (context, url, error) => Icon(Icons.error), // Handle error case
                //     ),
                //   ),
                // ),

                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: context.screenWidth,
                      child:  Image.network(
                          'https://superappadmin.aworkconnect.in/imghost/parcelbg.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),

                    ),
                    Column(
                      children: [
                        UiSpacer.verticalSpace(space: 300),







                        // Top widgets
                      ],
                    ),
                  ],
                ),






                //header
                VStack(
                  [


 Container(
                        width: 500, // Set the width of the container
                        height: 170, // Set the height of the container
                        decoration: BoxDecoration(
                          color: Colors.white, // Set the background color
                          borderRadius: BorderRadius.circular(20), // Set the border radius
                          border: Border.all(color: Colors.grey, width: 2.0), // Set the border color and width
                        ),
                        child:Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(

          children: [


            //

            Text(
              "Pick up or send anything",
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

            Text(
              "Sit back and relax let urgento do rest",
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  height: 1.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: GoogleFonts.rubik().fontFamily,
                  color: Utils.textColorByBrightness(context),
                  fontSize: 18.0,
                  letterSpacing: 0.025),
            ),


            UiSpacer.vSpace(25),
            ElevatedButton(
              onPressed: () {
                context.nextPage(NewParcelPage(widget.vendorType));// Add your button's onPressed functionality here
              },

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.black, // Button background color
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: HStack([
                  Text(
                    'Choose Parcel Type and \n Location To Book',
                    style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                    ),
                  ),
                  UiSpacer.hSpace(10),
                  Icon(
                    Icons.arrow_forward_ios_outlined, // Choose the desired arrow icon
                    color: Colors.white,
                    size: 32, // Set the size of the icon
                  )


                ])









              ),
            ),


          ],
        ),
                        ),


                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     context.nextPage(NewParcelPage(widget.vendorType));
                    //   },
                    //   child: Image.asset(
                    //     context.isDarkMode ? AppImages.bpick : AppImages.wpick,
                    //   )
                    //       .box
                    //       .clip(Clip.antiAlias)
                    //       .make(),
                    // ),

                    UiSpacer.vSpace(20),
                    //
                    "Track your package".tr().text.color(Utils.textColorByBrightness(context)).semiBold.xl.make(),
                    //
                    CustomTextFormField(
                      // labelText: "Order Code",
                      isReadOnly: vm.isBusy,
                      hintText: "Search by order code".tr(),
                      onFieldSubmitted: vm.trackOrder,
                      fillColor: context.brightness != Brightness.dark
                          ? Colors.white
                          : Colors.grey[600],
                    ).py12(),
                  ],
                ).p20().box.color(context.theme.colorScheme.background,).make(),

                //
                UiSpacer.verticalSpace(),


                // VendorTypeListItem(
                //   vm.vendorType,
                //   onPressed: () {
                //     //open the new parcel page
                //     context.nextPage(NewParcelPage(widget.vendorType));
                //   },
                // ).px20(),

                //recent orders
                UiSpacer.verticalSpace(),
                RecentOrdersView(vendorType: widget.vendorType),
                UiSpacer.verticalSpace(),
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }
}
