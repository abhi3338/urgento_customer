import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class NewCustomStepperView extends StatelessWidget {

  final int defaultValue;
  final int max;
  final Function(int) onDecrementQty;
  final Function(int) onIncrementQty;

  const NewCustomStepperView({Key key, @required this.defaultValue, this.max, this.onDecrementQty, this.onIncrementQty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("new_custom_stepper.view.dart");
    return HStack([
      
        Icon(FlutterIcons.minus_ant, size: 25,)
        .p1().onInkTap(() => onDecrementQty(defaultValue)),

        "$defaultValue".text.make().p4().px8().box.roundedSM.gray300.make(),

      Icon(FlutterIcons.plus_ant, size: 25,).p1().onInkTap(() {
          if (max == null || max > defaultValue) {
            onIncrementQty(defaultValue);
          }
        }),

      ],
    ).box.border(color: Vx.gray300).rounded.make();
  }
}