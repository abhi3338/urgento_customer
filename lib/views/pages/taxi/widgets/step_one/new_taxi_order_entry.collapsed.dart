import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/taxi_order_location_history.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../vendor/widgets/banners.view.dart';

class NewTaxiOrderEntryCollapsed extends StatelessWidget {
  const NewTaxiOrderEntryCollapsed(this.taxiNewOrderViewModel, {Key key})
      : super(key: key);

  final NewTaxiOrderLocationEntryViewModel taxiNewOrderViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = taxiNewOrderViewModel.taxiViewModel;
    //
    return MeasureSize(
      onChange: (size) {
        vm.updateGoogleMapPadding(
            height: taxiNewOrderViewModel.customViewHeight + 30);
      },
      child: VxBox(
        child: vm.isBusy
            ? BusyIndicator().centered().p20()
            : VStack(
                [


                  UiSpacer.swipeIndicator(),
                  UiSpacer.vSpace(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HStack(
                      [
                        Icon(
                          FlutterIcons.search1_ant,
                          size: 24,
                          color: Color(0xFF000000),
                        ),
                        "Choose Destination & Book Ride".tr().text.semiBold.lg.make().px12().expand(),
                        CustomVisibilty(
                          visible: AppStrings.canScheduleTaxiOrder ?? false,
                          child: Icon(
                            FlutterIcons.calendar_ant,
                            size: 18,
                            color: Color(0xFF000000),
                          )
                              .onInkTap(
                            taxiNewOrderViewModel.onScheduleOrderPressed,
                          )
                              .p2(),
                        ),
                      ],
                    )
                        .px12()
                        .py8()
                        .box

                        .color(context.theme.colorScheme.background,)

                        .shadowXs
                        .withRounded(value: 5)
                        .border(color: Color(0xFF000000))
                        .make()
                        .onTap(
                      taxiNewOrderViewModel.onDestinationPressed,
                    )
                        .safeArea(top: false),
                  ),



                  //previous history


                  Padding(
                    padding:
                        (taxiNewOrderViewModel.shortPreviousAddressesList ==
                                    null ||
                                taxiNewOrderViewModel
                                    .shortPreviousAddressesList.isEmpty)
                            ? EdgeInsets.all(8.0)
                            : EdgeInsets.symmetric(vertical: 10),
                    child: CustomListView(
                      /*isLoading: taxiNewOrderViewModel.busy(
                        taxiNewOrderViewModel.previousAddresses,
                      ),*/
                      dataSet: taxiNewOrderViewModel.shortPreviousAddressesList,
                      padding: EdgeInsets.zero,
                      itemBuilder: (ctx, index) {
                        final orderAddressHistory = taxiNewOrderViewModel
                            .shortPreviousAddressesList[index];
                        return TaxiOrderHistoryListItem(
                          orderAddressHistory,
                          onPressed:
                              taxiNewOrderViewModel.onDestinationSelected,
                        );
                      },
                      separatorBuilder: (ctx, index) => UiSpacer.divider(),
                    ),
                  ),


                ],
              ),
      )

          .color(context.theme.colorScheme.background,)

          .outerShadow2Xl
          .make(),
    );
  }
}
