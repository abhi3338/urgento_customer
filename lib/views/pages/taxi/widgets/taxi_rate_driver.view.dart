import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:fuodz/widgets/states/loading_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiRateDriverView extends StatelessWidget {
  const TaxiRateDriverView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropColor: Colors.transparent,
      minHeight: 400,
      maxHeight: context.percentHeight * 80,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      panel: MeasureSize(
        onChange: (size) {
          vm.updateGoogleMapPadding(height: 320);
        },
        child: FutureBuilder<Order>(
            future: vm.futureGoingTrip,
            builder: (context, snapshot) {
              //assign the order model from the one fetched from the server on order completed
              if (snapshot.hasData) {
                vm.onGoingOrderTrip = snapshot.data;
              }

              return LoadingIndicator(
                loading: snapshot.connectionState == ConnectionState.waiting,
                child: VStack(
                  [
                    //driver details
                    CustomImage(
                      imageUrl: vm.onGoingOrderTrip.driver.photo,
                      width: 80,
                      height: 80,
                    ).box.roundedSM.clip(Clip.antiAlias).makeCentered(),
                    //
                    "${vm.onGoingOrderTrip.driver.name}".text.xl.medium.make(),
                    "${vm.onGoingOrderTrip.driver.vehicle.vehicleInfo}"
                        .text
                        .light
                        .make(),
                    //
                    UiSpacer.verticalSpace(),
                    UiSpacer.divider(),
                    "${vm.onGoingOrderTrip.taxiOrder.currency != null ? vm.onGoingOrderTrip.taxiOrder.currency.symbol : AppStrings.currencySymbol} ${vm.onGoingOrderTrip.total}"
                        .text
                        .medium
                        .xl3
                        .make()
                        .py12(),
                    UiSpacer.divider(),
                    UiSpacer.verticalSpace(),
                    "Rate your trip".tr().text.make(),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        FlutterIcons.star_ant,
                        color: Colors.yellow[700],
                      ),
                      onRatingUpdate: (rating) {
                        //
                        vm.newTripRating = rating;
                      },
                    ).py8(),
                    UiSpacer.verticalSpace(),
                    CustomTextFormField(
                      hintText: "Review".tr(),
                      textEditingController: vm.tripReviewTEC,
                      minLines: 3,
                      maxLines: 5,
                    ),
                    //submit button
                    UiSpacer.verticalSpace(),
                    CustomButton(
                      title: "Submit Rating".tr(),
                      loading: vm.busy(vm.newTripRating),
                      onPressed: vm.submitTripRating,
                    ),
                    UiSpacer.verticalSpace(space: 10),
                    SafeArea(
                      child: CustomTextButton(
                        title: "Cancel".tr(),
                        titleColor: Colors.red,
                        onPressed: vm.dismissTripRating,
                      ),
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                )
                    .p20()
                    .scrollVertical()
                    .box
                    .color(context.theme.colorScheme.background,)
                    .topRounded(value: 30)
                    .shadow5xl
                    .make()
                    .pOnly(bottom: context.mq.viewInsets.bottom),
              );
            }),
      ),
    );
  }
}
