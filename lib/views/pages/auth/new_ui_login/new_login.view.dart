import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/views/pages/auth/login/scan_login.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/utils.dart';
import 'new_combined_type.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:fuodz/views/pages/welcome/widgets/welcome_header.section.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/list_items/modern_vendor_type.vertical_list_item.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/widgets/cards/welcome_intro.view.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';
import 'package:fuodz/resources/resources.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:fuodz/views/pages/welcome/widgets/welcome_header.section.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/list_items/modern_vendor_type.vertical_list_item.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/views/shared/widgets/section_coupons.view.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/widgets/cards/welcome_intro.view.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/views/pages/livechat/livechatpage.dart';
import 'package:fuodz/resources/resources.dart';
import 'package:fuodz/view_models/profile.vm.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image/image.dart' as img;


class NewUILogin extends StatefulWidget {

  final bool authRequired;
  const NewUILogin({Key key, this.authRequired = false});

  @override
  State<NewUILogin> createState() => _NewUILoginState();
}

class _NewUILoginState extends State<NewUILogin> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: !widget.authRequired,
          showAppBar: false,
          appBarColor: Colors.transparent,
          elevation: 0,
          isLoading: model.isBusy,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
              child: VStack(




                [Image.network(
              'https://superappadmin.aworkconnect.in/imghost/loginbg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
            return Container();
            },
            )
                    .box
                    .clip(Clip.antiAlias).make(),
                  VStack(
                    [
                      HStack(
                        [
                          VStack(
                            [ Text(
                              "India’s Tier 2 and Tier 3 \n #1st Super App for service and Delivery ",
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: Utils.textColorByBrightness(context),
                                  fontSize: 26.0,
                                  letterSpacing: 0.025),
                            ),//.tr().text.light.make(),

                              UiSpacer.verticalSpace(space: 20),

                              Text(
                                "Welcome to Urgento",
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.0,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    color: Utils.textColorByBrightness(context),
                                    fontSize: 24.0,
                                    letterSpacing: 0.025),
                              ),
                              //"Welcome Back".tr().text.xl2.semiBold.make(),
                               UiSpacer.verticalSpace(space: 10),

                              Text(
                                "Login with otp to continue",
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    color: Utils.textColorByBrightness(context),
                                    fontSize: 18.0,
                                    letterSpacing: 0.025),
                              ),


                            ]
                          ).expand(),

                          /*Image.asset(
                            AppImages.appLogo,
                          ).h(60).w(60)
                          .box.roundedFull
                          .clip(Clip.antiAlias).make(), */

                        ]
                      ),

                      NewCombinedLoginTypeView(model)

                    ]
                  )
                  .wFull(context)
                  .px20()
                  .pOnly(top: Vx.dp20),

                  HStack(
                    [
                      UiSpacer.divider().expand(),
                      "Contact us".tr().text.light.make().px8(),
                      UiSpacer.divider().expand(),
                    ],
                  ),

                  UiSpacer.verticalSpace(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // WhatsApp
                        InkWell(
                          onTap: () {
                            launchWhatsApp();
                          },
                          child: Container(
                            width: 180, // Adjust the width as needed
                            height: 40, // Adjust the height as needed
                            decoration: BoxDecoration(
                              color: Colors.grey[100], // Background color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FlutterIcons.whatsapp_mco,
                                  size: 24,
                                  color: Colors.grey, // Icon color
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "WhatsApp",
                                  style: TextStyle(
                                    color: Utils.textColorByBrightness(context),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Call
                        InkWell(
                          onTap: () {
                            model.callup();
                          },
                          child: Container(
                            width: 180, // Adjust the width as needed
                            height: 40, // Adjust the height as needed
                            decoration: BoxDecoration(
                              color: Colors.grey[100], // Background color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 24,
                                  color: Colors.grey, // Icon color
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                    color: Utils.textColorByBrightness(context),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UiSpacer.verticalSpace(),

                  ScanLoginView(model),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       // Share app & Earn
                  //       InkWell(
                  //         onTap: () {
                  //           model.profileViewModel.openRefer();
                  //         },
                  //         child: Container(
                  //           width: 180, // Adjust the width as needed
                  //           height: 40, // Adjust the height as needed
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey[100], // Background color
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(
                  //                 Icons.share,
                  //                 size: 24,
                  //                 color: Colors.grey, // Icon color
                  //               ),
                  //               SizedBox(width: 6.0),
                  //               Text(
                  //                 "Share app & Earn",
                  //                 style: TextStyle(
                  //                   color: Utils.textColorByBrightness(context),
                  //                   fontSize: 14.0,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       // Live Support
                  //       InkWell(
                  //         onTap: () {
                  //           Navigator.of(context).push(
                  //               MaterialPageRoute(builder: (context) => MyApp()));
                  //         },
                  //         child: Container(
                  //           width: 180, // Adjust the width as needed
                  //           height: 40, // Adjust the height as needed
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey[100], // Background color
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(
                  //                 Icons.headset_mic,
                  //                 size: 24,
                  //                 color: Colors.grey, // Icon color
                  //               ),
                  //               SizedBox(width: 6.0),
                  //               Text(
                  //                 "Live Support",
                  //                 style: TextStyle(
                  //                   color: Utils.textColorByBrightness(context),
                  //                   fontSize: 14.0,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       // WhatsApp
                  //     ],
                  //   ),
                  // ),



                  
                ]
              ).scrollVertical(),
            ),
          ),
        );
      }
    );
  }
}