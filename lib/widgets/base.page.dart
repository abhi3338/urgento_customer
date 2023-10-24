import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/views/shared/go_to_cart.view.dart';
import 'package:fuodz/widgets/cart_page_action.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/views/pages/livechat/Chatpage.dart';
import 'package:fuodz/constants/app_images.dart';

class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final bool extendBodyBehindAppBar;
  final Function onBackPressed;
  final bool showCart;
  final bool showLogo;
  final String title;
  final List<Widget> actions;
  final Widget leading;
  final Widget body;
  final Widget bottomSheet;
  final Widget bottomNavigationBar;
  final Widget fab;
  final bool isLoading;
  final Color appBarColor;
  final double elevation;
  final Color appBarItemColor;
  final Color backgroundColor;
  final bool showCartView;

  BasePage({
    this.showAppBar = false,
    this.leading,
    this.showLeadingAction = false,
    this.onBackPressed,
    this.showCart = false,
    this.title = "",
    this.actions,
    this.showLogo = false,
    this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.isLoading = false,
    this.appBarColor,
    this.appBarItemColor,
    this.backgroundColor,
    this.elevation,
    this.extendBodyBehindAppBar,
    this.showCartView = false,
    Key key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //
  double bottomPaddingSize = 0;

  //
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.activeLocale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: KeyboardDismisser(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
          appBar: widget.showAppBar
              ? AppBar(
            backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: widget.showLeadingAction,
                  leading: widget.showLeadingAction
                      ? widget.leading == null
                          ? HStack([IconButton(
                    icon: Icon(
                      FlutterIcons.arrow_left_fea,
                      color: Utils.textColorByBrightness(context)
                    ),
                    onPressed: widget.onBackPressed != null
                        ? widget.onBackPressed
                        : () => Navigator.pop(context),
                  ),



                  ])

                          : widget.leading
                      : null,


                  title: widget.showLogo?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppImages.llogo,
                        fit: BoxFit.contain,
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        child: widget.title.text
                            .maxLines(1)
                            .extraBold
                            .xs
                            .overflow(TextOverflow.ellipsis)
                            .color(widget.appBarItemColor ?? Utils.textColorByBrightness(context))
                            .make(),
                      ),
                    ],
                  ):widget.title.text
                      .maxLines(1)
                      .extraBold
                      .lg
                      .overflow(TextOverflow.ellipsis)
                      .color(widget.appBarItemColor ?? Utils.textColorByBrightness(context))
                      .make(),
                  actions: widget.actions ??
                      [







                        widget.showCart
                            ? PageCartAction()
                            : UiSpacer.emptySpace(),

                        IconButton(
                          icon: Icon(
                            FlutterIcons.whatsapp_faw,
                            color: Utils.textColorByBrightness(context)
                          ),
                          onPressed
                              : () => launchWhatsApp(),
                        )



                      ],
                )
              : null,
          body: Stack(
            children: [
              //body
              VStack(
                [
                  //
                  widget.isLoading
                      ? LinearProgressIndicator()
                      : UiSpacer.emptySpace(),

                  //
                  widget.body.pOnly(bottom: bottomPaddingSize).expand(),
                ],
              ),

              //cart view
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: widget.showCartView,
                  child: MeasureSize(
                    onChange: (size) {
                      setState(() {
                        bottomPaddingSize = size.height;
                      });
                    },
                    child: GoToCartView(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: widget.bottomNavigationBar,
          bottomSheet: widget.bottomSheet,
          floatingActionButton: widget.fab,
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
