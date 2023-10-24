import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/location_fetch.view_model.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationFetchPage extends StatelessWidget {
  const LocationFetchPage({
    this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationFetchViewModel>.reactive(
        viewModelBuilder: () => LocationFetchViewModel(context, child),
        onModelReady: (vm) => vm.initialise(),
        builder: (ctx, vm, child) {
          return Scaffold(
            body: VStack(
              [
                //skip
                HStack([
                  UiSpacer.expandedSpace(),
                  CustomTextButton(
                    title: "Skip".tr(),
                    onPressed: vm.loadNextPage,
                  ),
                ]).safeArea(),
                Center(
                  child: VStack(
                    [
                      FittedBox(
                        child: Image.asset(AppImages.newloc)
                            .wh(context.percentWidth * 50,
                                context.percentWidth * 50)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                      ),
                      UiSpacer.vSpace(),
                      //
                      Visibility(
                        visible: !vm.showManuallySelection,
                        child: VStack(
                          [
                            "Trying to find your current location."
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered(),
                            "Please wait while we get it"
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered(),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: vm.showManuallySelection,
                        child: VStack(
                          [
                            "We are unable to determine current location. Please try again or manually select location"
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered()
                                .px(40),
                            UiSpacer.vSpace(),
                            CustomButton(
                              title: "Choose Your Location On Map".tr(),
                              onPressed: vm.pickFromMap,
                            ).w40(context),
                            UiSpacer.vSpace(10),
                            CustomTextButton(
                              title: "Try again".tr(),
                              onPressed: vm.handleFetchCurrentLocation,
                            ).w24(context)
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ).p20(),
                      ),
                      UiSpacer.vSpace(),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                ).expand(),
              ],
            ).color(context.theme.colorScheme.background),
          );
        });
  }
}
