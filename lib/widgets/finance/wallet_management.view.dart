import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletManagementView extends StatefulWidget {
  const WalletManagementView({this.viewmodel, Key key}) : super(key: key);

  final WalletViewModel viewmodel;

  @override
  State<WalletManagementView> createState() => _WalletManagementViewState();
}

class _WalletManagementViewState extends State<WalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      mViewmodel.initialise();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding?.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mViewmodel != null) {
      mViewmodel.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.grey.shade300;
    final textColor = Utils.textColorByColor(bgColor);
    //
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel,
      disposeViewModel: widget.viewmodel == null,
      builder: (context, vm, child) {
        return StreamBuilder(
          stream: AuthServices.listenToAuthState(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            //view
            return VStack(
              [
                //
                Visibility(
                  visible: vm.isBusy,
                  child: BusyIndicator(),
                ),

                VStack(
                  [
                    //
                    "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet.balance : 0.00}"
                        .currencyFormat()
                        .text
                        .color(textColor)
                        .xl3
                        .semiBold
                        .makeCentered(),
                    UiSpacer.verticalSpace(space: 5),
                    "Wallet Balance".tr().text.color(textColor).makeCentered(),
                  ],
                ),

                UiSpacer.vSpace(10),
                //buttons
                Visibility(
                  visible: !vm.isBusy,
                  child: HStack(
                    [
                      //topup button
                      CustomButton(
                        shapeRadius: 12,
                        onPressed: vm.showAmountEntry,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: HStack(
                            [
                              Icon(
                                // Icons.add,
                                FlutterIcons.plus_ant,
                              ).wh(24, 24),
                              UiSpacer.hSpace(5),
                              //
                              "Top-Up".tr().text.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                            alignment: MainAxisAlignment.center,
                          ).py8(),
                        ),
                      ).expand(),
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: UiSpacer.horizontalSpace(space: 5),
                      ),
                      //tranfer button
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: CustomButton(
                          shapeRadius: 12,
                          onPressed: vm.showWalletTransferEntry,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: HStack(
                              [
                                Icon(
                                  FlutterIcons.upload_fea,
                                ).wh(24, 24),
                                UiSpacer.hSpace(5),
                                //
                                "SEND".tr().text.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ).py8(),
                          ),
                        ).expand(),
                      ),
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: UiSpacer.horizontalSpace(space: 5),
                      ),
                      //tranfer button
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: CustomButton(
                          shapeRadius: 12,
                          onPressed: vm.showMyWalletAddress,
                          loading: vm.busy(vm.showMyWalletAddress),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: HStack(
                              [
                                Icon(
                                  FlutterIcons.download_fea,
                                ).wh(24, 24),
                                UiSpacer.hSpace(5),
                                //
                                "RECEIVE".tr().text.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ).py8(),
                          ),
                        ).expand(),
                      ),
                    ],
                  ),
                ),
              ],
            )
                .p12()
                .box
                .shadowSm
                .color(bgColor)
                .withRounded(value: 15)
                .make()
                .wFull(context);
          },
        );
      },
    );
  }
}
