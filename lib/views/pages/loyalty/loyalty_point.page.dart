import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_finance_settings.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/loyalty_point.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/loyalty_point_report.list_item.dart';
import 'package:fuodz/widgets/states/loading_indicator.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LoyaltyPointPage extends StatelessWidget {
  const LoyaltyPointPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return BasePage(
      title: "Loyalty Points".tr(),
      showLeadingAction: true,
      showAppBar: true,
      body: ViewModelBuilder<LoyaltyPointViewModel>.reactive(
        viewModelBuilder: () => LoyaltyPointViewModel(context),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              UiSpacer.vSpace(),
              //points section
              LoadingIndicator(
                loading: vm.isBusy,
                child: GlassContainer(
                  height: 130,
                  margin: EdgeInsets.zero,
                  width: context.screenWidth,
                  borderColor: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryColor.withOpacity(0.35),
                      AppColor.primaryColor.withOpacity(0.50),
                      AppColor.primaryColor.withOpacity(0.80),
                      AppColor.primaryColor.withOpacity(0.99),
                      // AppColor.primaryColorDark,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.30, 0.60, 1.0],
                  ),
                  blur: 5.0,
                  isFrostedGlass: true,
                  frostedOpacity: 0.50,
                  shadowColor: AppColor.primaryColor.withOpacity(0.50),
                  child: HStack(
                    [
                      HStack(
                        [
                          "${vm?.loyaltyPoint?.points}"
                              .text
                              .xl6
                              .semiBold
                              .shadow(0.0, 0.0, 2.0, AppColor.primaryColor)
                              .color(Utils.textColorByTheme())
                              .make(),
                          "Points"
                              .tr()
                              .text
                              .xl
                              .shadow(0.0, 0.0, 2.0, AppColor.primaryColor)
                              .color(Utils.textColorByTheme())
                              .make()
                              .px4()
                              .pOnly(bottom: 15)
                              .expand(),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                        alignment: MainAxisAlignment.end,
                      ).p12().expand(),
                      //
                      VStack(
                        [
                          ("~ " +
                                  "${AppStrings.currencySymbol}${vm.estimatedAmount}"
                                      .currencyFormat())
                              .text
                              .semiBold
                              .xl
                              .color(Utils.textColorByTheme())
                              .make(),
                          //~ exchange rate
                          "Exchange Rate"
                              .text
                              .sm
                              .color(Utils.textColorByTheme())
                              .make(),
                          ("1 point".tr() +
                                  " = " +
                                  "${AppStrings.currencySymbol} ${AppFinanceSettings.loyaltyPointsToAmount ?? 0}"
                                      .currencyFormat())
                              .text
                              .medium
                              .color(Utils.textColorByTheme())
                              .make(),
                        ],
                      ),

                      //
                    ],
                  ).p12(),
                ),
              ).px20(),

              UiSpacer.vSpace(5),
              CustomButton(
                title: "Withdraw To Wallet".tr(),
                loading: vm.busy(vm.loyaltyPoint),
                onPressed: vm.showAmountEntry,
              ).px24().wFull(context),

              UiSpacer.divider().px20().py20(),
              //recent report
              "Recent report".tr().text.semiBold.lg.make().px20(),
              UiSpacer.vSpace(10),
              CustomListView(
                isLoading: vm.busy(vm.loyaltyPointReports),
                dataSet: vm.loyaltyPointReports,
                noScrollPhysics: true,
                itemBuilder: (ctx, index) {
                  final loyaltyPointReport = vm.loyaltyPointReports[index];
                  return LoyaltyPointReportListItem(loyaltyPointReport);
                },
                separatorBuilder: (ctx,index) => UiSpacer.vSpace(10),
              ).px20(),
              UiSpacer.vSpace(),
            ],
          ).scrollVertical();
        },
      ),
    );
  }
}
