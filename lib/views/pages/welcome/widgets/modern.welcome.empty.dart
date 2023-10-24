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

class ModernEmptyWelcome extends StatelessWidget {
  const ModernEmptyWelcome({this.vm, Key key}) : super(key: key);

  final WelcomeViewModel vm;

  // final htmlContent = """ <div class="strawpoll-embed" id="strawpoll_BDyNEJQmzZR" style="height: 608px; max-width: 640px; width: 100%; margin: 0 auto; display: flex; flex-direction: column;"><iframe title="StrawPoll Embed" id="strawpoll_iframe_BDyNEJQmzZR" src="https://strawpoll.com/embed/BDyNEJQmzZR" style="position: static; visibility: visible; display: block; width: 100%; flex-grow: 1;" frameborder="0" allowfullscreen allowtransparency>Loading...</iframe><script async src="https://cdn.strawpoll.com/dist/widgets.js" charset="utf-8"></script></div>""";
  // @override
  Widget build(BuildContext context) {
    return VStack(
 [
        // Other widgets that you want to place on top of the background
        VStack(
          [
            VStack(
              [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: context.screenWidth,
                      child: Image.network(
                          'https://superappadmin.aworkconnect.in/imghost/homeback.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),

                    ),
                    Column(
                      children: [
                        WelcomeHeaderSection(vm),
                        // Top widgets
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 400,
                            child: SearchBarInput(
                              onTap: () {
                                AppService().homePageIndex.add(2);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


                VStack(
                  [
                    // "Description".tr().text.sm.bold.uppercase.textStyle(GoogleFonts.roboto()).make(),

                    // SizedBox(
                    //
                    //     child: HtmlWidget(htmlContent)),
                  ],
                ),

                // Positioned.fill(
                //     child: Image.network(
                //   'https://superappadmin.aworkconnect.in/imghost/homeback.png',
                //   // Replace with your image URL
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) {
                //     // You can return an empty container or any other widget you prefer
                //     return Container();
                //   },
                // )),

                //top banner
                CustomVisibilty(
                  visible: (HomeScreenConfig.showBannerOnHomeScreen &&
                      HomeScreenConfig.isBannerPositionTop),
                  child: Banners(
                    null,
                    itemRadius: 25,
                    featured: true,
                  ),
                ),
                //

                VStack(
                  [
                    WelcomeIntroView(),
                    UiSpacer.verticalSpace(space: 20),
                    Container(
                      height: 18,
                      child: Text(
                        'What Do You Want To Order?🙄'
                        '',
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
                    ),
                    UiSpacer.verticalSpace(space: 15),
                    //gridview

                    CustomVisibilty(
                      visible: HomeScreenConfig.isVendorTypeListingGridView &&
                          vm.showGrid &&
                          !vm.isBusy,
                      child: AnimationLimiter(
                        child: MasonryGrid(
                          column: HomeScreenConfig.vendorTypePerRow ?? 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          children: List.generate(
                            vm.vendorTypes.length ?? 0,
                            (index) {
                              final vendorType = vm.vendorTypes[index];
                              return ModernVendorTypeVerticalListItem(
                                vendorType,
                                onPressed: () {
                                  NavigationService.pageSelected(
                                    vendorType,
                                    context: context,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ).p20(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Share app & Earn
                      InkWell(
                        onTap: () {
                          vm.profileViewModel.openRefer();
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
                                Icons.share,
                                size: 24,
                                color: Colors.grey, // Icon color
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "Share app & Earn",
                                style: TextStyle(
                                  color: Utils.textColorByBrightness(context),
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Live Support
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => MyApp()));
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
                                Icons.headset_mic,
                                size: 24,
                                color: Colors.grey, // Icon color
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "Live Support",
                                style: TextStyle(
                                  color: Utils.textColorByBrightness(context),
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // WhatsApp
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          vm.callup();
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

                UiSpacer.vSpace(10),

                Image.network(
                  'https://superappadmin.aworkconnect.in/imghost/fwu.png',
                  // Replace with your image URL
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // You can return an empty container or any other widget you prefer
                    return Container();
                  },
                ),
                // Image.asset(
                //   AppImages.fwu,
                // ).box.clip(Clip.antiAlias).make(),
                UiSpacer.vSpace(5),

                SectionCouponsView(
                  null,
                  title: "Coupons for you".tr(),
                  scrollDirection: Axis.horizontal,
                  itemWidth: context.percentWidth * 40,
                  height: 90,
                  itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  bPadding: 10,
                  isDetailPage: false,
                  isCartPage: false,
                  loadingWidget: const SizedBox.shrink(),
                ),

                UiSpacer.vSpace(5),

                //botton banner
                CustomVisibilty(
                  visible: HomeScreenConfig.showBannerOnHomeScreen &&
                      !HomeScreenConfig.isBannerPositionTop,
                  child: Banners(
                    null,
                    featured: true,
                  ).py12().pOnly(bottom: context.percentHeight * 10),
                ),

                UiSpacer.vSpace(5),

             Image.network(
                  'https://superappadmin.aworkconnect.in/imghost/Hom.png',
                  // Replace with your image URL
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // You can return an empty container or any other widget you prefer
                    return Container();
                  },
                ),

                // Image.asset(
                //   AppImages.hom,
                // ).box.clip(Clip.antiAlias).make(),
                UiSpacer.vSpace(5),

                //featured vendors
                SectionVendorsView(
                  null,
                  title: "Featured Vendors".tr(),
                  scrollDirection: Axis.vertical,
                  type: SearchFilterType.featured,
                  itemWidth: context.percentWidth * 48,
                  byLocation: AppStrings.enableFatchByLocation,
                  loadingWidget: const SizedBox.shrink(),
                ),

                 Image.network(
                  'https://superappadmin.aworkconnect.in/imghost/fwd.png',
                  // Replace with your image URL
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // You can return an empty container or any other widget you prefer
                    return Container();
                  },

                ),
                //spacing
                //
                // UiSpacer.vSpace(5),
                // // Image.asset(
                // //   AppImages.fwd,
                // // ).box.clip(Clip.antiAlias).make(),
                // UiSpacer.vSpace(50),
                ],
              //).box.color(context.backgroundColor).make().scrollVertical().expand(),
            ),
          ],
        )
            .box
            .color(
              Color(0xFFFFFFF),
            )

            .make()
            .scrollVertical()
            .expand()
        // Replace with your actual content widget
      ],
    );
  }
}
