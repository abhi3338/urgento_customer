import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/views/pages/parcel/widgets/form_step_controller.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/package_type.list_item.dart';
import 'package:fuodz/widgets/list_items/parcel_vendor.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PackageDeliverySummary extends StatelessWidget {
  const PackageDeliverySummary({this.vm, Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        VStack(
          [
            //
            "Summary".tr().text.xl2.semiBold.make().py20(),
            //package type
            "Package Type".tr().text.xl.medium.make().py8(),
            PackageTypeListItem(packageType: vm.selectedPackgeType),
            UiSpacer.formVerticalSpace(),
            //
            "Courier Vendor".tr().text.xl.medium.make().py8(),
            ParcelVendorListItem(vm.selectedVendor, vm: vm),
            UiSpacer.formVerticalSpace(),

            //
            "Delivery Details".tr().text.xl.medium.make().py8(),
            VStack(
              [
                "FROM".tr().text.semiBold.make(),
                vm.pickupLocation.address.text.make().pOnly(bottom: Vx.dp4),
                UiSpacer.verticalSpace(space: 10),
                //dropoff location
                Visibility(
                  visible: !AppStrings.enableParcelMultipleStops,
                  child: VStack(
                    [
                      "TO".tr().text.semiBold.make(),
                      vm.dropoffLocation.address.text.make(),
                      UiSpacer.verticalSpace(space: 10),
                    ],
                  ),
                ),

                //stops
                Visibility(
                  visible: AppStrings.enableParcelMultipleStops,
                  child: (vm.packageCheckout.stopsLocation != null)
                      ? VStack(
                          [
                            ...(vm.packageCheckout.stopsLocation
                                .mapIndexed((stop, index) {
                              return VStack(
                                [
                                  ("Stop".tr() + " ${index + 1}")
                                      .text
                                      .semiBold
                                      .make(),
                                  "${stop?.deliveryAddress?.address}"
                                      .text
                                      .make(),
                                  UiSpacer.verticalSpace(space: 10),
                                ],
                              );
                            }).toList()),
                          ],
                        )
                      : UiSpacer.emptySpace(),
                ),

                //
                UiSpacer.verticalSpace(space: 10),
                HStack(
                  [
                    //date
                    VStack(
                      [
                        "DATE".tr().text.semiBold.make(),
                        (vm.pickupDate != null ? vm.pickupDate : "ASAP".tr())
                            .text
                            .make(),
                      ],
                    ).expand(),
                    UiSpacer.horizontalSpace(),
                    //time
                    VStack(
                      [
                        "TIME".tr().text.semiBold.make(),
                        (vm.pickupTime != null ? vm.pickupTime : "ASAP".tr())
                            .text
                            .make(),
                      ],
                    ).expand(),
                  ],
                ),
              ],
            )
                .p12()
                .box
                .roundedSM
                .border(color: Colors.grey[300], width: 2)
                .make(),
            UiSpacer.formVerticalSpace(),

            //
            "Recipient Info".tr().text.xl.medium.make().py8(),
            //recipients
            CustomListView(
              noScrollPhysics: true,
              dataSet: vm.recipientNamesTEC,
              itemBuilder: (context, index) {
                //
                // OrderStop stop = vm.packageCheckout.stopsLocation[index];
                final recipientNameTEC = vm.recipientNamesTEC[index];
                final recipientPhoneTEC = vm.recipientPhonesTEC[index];
                final noteTEC = vm.recipientNotesTEC[index];
                //
                return VStack(
                  [
                    HStack(
                      [
                        VStack(
                          [
                            "Name".tr().text.semiBold.make(),
                            recipientNameTEC.text.text.make(),
                          ],
                        ).expand(),
                        UiSpacer.horizontalSpace(),
                        VStack(
                          [
                            "phone"
                                .tr()
                                .allWordsCapitilize()
                                .text
                                .semiBold
                                .make(),
                            recipientPhoneTEC.text.text.make(),
                          ],
                        ).expand(),
                      ],
                    ),

                    //
                    UiSpacer.verticalSpace(space: 5),
                    VStack(
                      [
                        "note".tr().allWordsCapitilize().text.semiBold.make(),
                        noteTEC.text.text.make(),
                      ],
                    )
                  ],
                )
                    .p12()
                    .box
                    .roundedSM
                    .border(color: Colors.grey[300], width: 2)
                    .make()
                    .wFull(context);
              },
              padding: EdgeInsets.only(top: Vx.dp16),
            ),

            UiSpacer.formVerticalSpace(),

            //
            CustomVisibilty(
              visible: vm.requireParcelInfo,
              child: VStack(
                [
                  "Package Parameters".tr().text.xl.medium.make().py8(),
                  VStack(
                    [
                      HStack(
                        [
                          //weight
                          VStack(
                            [
                              "Weight".tr().text.semiBold.make(),
                              "${vm.packageWeightTEC.text}kg".text.make(),
                            ],
                          ).expand(),
                          //length
                          VStack(
                            [
                              "Length".tr().text.semiBold.make(),
                              "${vm.packageLengthTEC.text}cm".text.make(),
                            ],
                          ).expand(),
                        ],
                      ),
                      UiSpacer.verticalSpace(space: 10),
                      HStack(
                        [
                          //width
                          VStack(
                            [
                              "Width".tr().text.semiBold.make(),
                              "${vm.packageWidthTEC.text}cm".text.make(),
                            ],
                          ).expand(),
                          //time
                          VStack(
                            [
                              "Height".tr().text.semiBold.make(),
                              "${vm.packageHeightTEC.text}cm".text.make(),
                            ],
                          ).expand(),
                        ],
                      ),
                    ],
                  )
                      .p12()
                      .box
                      .roundedSM
                      .border(color: Colors.grey[300], width: 2)
                      .make()
                      .wFull(context),
                ],
              ),
            ),
            UiSpacer.formVerticalSpace(),
          ],
        ).scrollVertical().expand(),

        //
        FormStepController(
          onPreviousPressed: () => vm.nextForm(vm.requireParcelInfo ? 4 : 3),
          onNextPressed: vm.prepareOrderSummary,
        ),
      ],
    );
  }
}
