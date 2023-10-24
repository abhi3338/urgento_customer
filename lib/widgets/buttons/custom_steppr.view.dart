import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class NewOneCustomStepper extends StatelessWidget {

  final int defaultValue;
  final int max;
  final Function(int, bool increment, bool decrement) onChange;

  const NewOneCustomStepper({Key key, this.defaultValue, this.max, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  HStack([

      Icon(
        FlutterIcons.minus_ant,
        size: 20,
      )
          .p1()
          .onInkTap(() => onChange(defaultValue, false, true)),

      "$defaultValue".text.make().p4().px8().box.roundedSM.gray300.make(),

      Icon(
        FlutterIcons.plus_ant,
        size: 20,
      )
          .p1()
          .onInkTap(() {
        if (max == null || max > defaultValue) {
          onChange(defaultValue, true, false);
        }
      }),
    ])
        .box
        .border(color: Vx.gray300)
        .rounded
        .make();


  }
}

class CustomStepper extends StatefulWidget {
  CustomStepper({Key key, this.defaultValue, this.max, this.onChange})
      : super(key: key);

  final int defaultValue;
  final int max;
  final Function(int) onChange;
  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int qty = 0;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      qty = widget.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        Icon(
          FlutterIcons.minus_ant,
          size: 25,
        ).p1().onInkTap(() {
          if (qty > 0) {
            setState(() {
              qty -= 1;
            });
            //
            widget.onChange(qty);
          }
        }),
        //
        "$qty".text.make().p4().px8().box.roundedSM.gray300.make(),
        //
        Icon(FlutterIcons.plus_ant, size: 25,).p1().onInkTap(() {
          if (widget.max == null || widget.max > qty) {
            setState(() {
              qty += 1;
            });
            //
            widget.onChange(qty);
          }
        }),
      ],
    ).box.border(color: Vx.gray300).rounded.make();
  }
}
