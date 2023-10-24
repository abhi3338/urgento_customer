import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class tNewOneCustomStepper extends StatelessWidget {

  final int defaultValue;
  final int max;
  final Function(int, bool increment, bool decrement) onChange;

  const tNewOneCustomStepper({Key key, this.defaultValue, this.max, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                FlutterIcons.minus_ant,
                color: Colors.black,
                size: 25,
              )
                  .p1()
                  .onInkTap(() => onChange(defaultValue, false, true)),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: "$defaultValue".text.color(Colors.white).make().p4().px8().box.roundedSM.color(Colors.black,).make(),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FlutterIcons.plus_ant,
                color: Colors.black,
                size: 25,
              )
                  .p1()
                  .onInkTap(() {
                if (max == null || max > defaultValue) {
                  onChange(defaultValue, true, false);
                }
              }),
            ],
          ),
        ),
      ],
    )
        .box
        .border(color: Vx.black)
        .rounded
        .make();


  }
}

class tCustomStepper extends StatefulWidget {
  tCustomStepper({Key key, this.defaultValue, this.max, this.onChange})
      : super(key: key);

  final int defaultValue;
  final int max;
  final Function(int) onChange;
  @override
  _tCustomStepperState createState() => _tCustomStepperState();
}

class _tCustomStepperState extends State<tCustomStepper> {
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
