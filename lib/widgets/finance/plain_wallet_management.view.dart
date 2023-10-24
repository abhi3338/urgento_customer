import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/views/pages/wallet/wallet.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainWalletManagementView extends StatefulWidget {
  const PlainWalletManagementView({this.viewmodel, Key key}) : super(key: key);

  final WalletViewModel viewmodel;

  @override
  State<PlainWalletManagementView> createState() =>
      _PlainWalletManagementViewState();
}

class _PlainWalletManagementViewState extends State<PlainWalletManagementView>
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

                //
                HStack(
                  [
                    VStack(
                      [
                        "Wallet Balance"
                            .tr()
                            .text
                            .sm
                            .medium
                            .color(textColor)
                            .make(),
                        UiSpacer.vSpace(3),
                        "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet.balance : 0.00}"
                            .currencyFormat()
                            .text
                            .color(textColor)
                            .xl2
                            .extraBold
                            .make(),
                      ],
                    ).expand(),
                    UiSpacer.hSpace(10),
                    //buttons
                    Visibility(
                      visible: !vm.isBusy,
                      child: VStack(
                        [
                          //topup button
                          CustomButton(
                            shapeRadius: 12,
                            onPressed: vm.showAmountEntry,
                            child: HStack(
                              [
                                Icon(
                                  // Icons.add,
                                  FlutterIcons.plus_ant,
                                  size: 16,
                                ),
                                UiSpacer.hSpace(5),
                                //
                                "Top-Up".tr().text.sm.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                "Tap for more info/action".tr().text.sm.makeCentered(),
              ],
            )
                .p(10)
                .box
                .shadowXl
                .color(context.theme.colorScheme.background)
                .withRounded(value: 5)
                .make()
                .wFull(context)
                .onInkTap(
              () {
                context.nextPage(WalletPage());
              },
            );
          },
        );
      },
    );
  }
}
