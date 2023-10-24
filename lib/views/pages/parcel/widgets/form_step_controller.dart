import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class FormStepController extends StatelessWidget {
  const FormStepController({
    this.onPreviousPressed,
    this.onNextPressed,
    this.showPrevious = true,
    this.showNext = true,
    this.showLoadingNext = false,
    this.nextTitle,
    this.nextBtnWidth,
    Key key,
  }) : super(key: key);

  final Function onPreviousPressed;
  final bool showPrevious;
  final Function onNextPressed;
  final bool showNext;
  final bool showLoadingNext;
  final String nextTitle;
  final double nextBtnWidth;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //prev
        showPrevious
            ? OutlinedButton(
                // height: Vx.dp40,
                child: Text(
                  "PREVIOUS".tr(), // Replace with your desired text
                  style: TextStyle(
                    color: Colors.white, // Change text color if needed
                  ),
                ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black
            ), // Change to your desired color
          ),
                onPressed: onPreviousPressed,
              ).py20().w(context.percentWidth * 35)
            : UiSpacer.emptySpace(),
        Spacer(),
        //next
        showLoadingNext
            ? BusyIndicator().py20().px4()
            : showNext
                ? CustomButton(
                    height: Vx.dp40,
                    title: nextTitle ?? "NEXT".tr(),
                    onPressed: onNextPressed,
                  ).py20().w(nextBtnWidth ?? (context.percentWidth * 35))
                : UiSpacer.emptySpace(),
      ],
    );
  }
}
