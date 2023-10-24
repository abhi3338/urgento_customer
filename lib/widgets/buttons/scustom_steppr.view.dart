import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class sNewOneCustomStepper extends StatelessWidget {

  final int defaultValue;
  final int max;
  final Function(int, bool increment, bool decrement) onChange;

  const sNewOneCustomStepper({Key key, this.defaultValue, this.max, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                width: 50,
                height: 50,

                child: Icon(FlutterIcons.minus_ant, color: Colors.black),
              )
              // Icon(
              //   FlutterIcons.minus_ant,
              //   color: Color(0xFF181725),
              //   size: 20,
              // )

                  .onInkTap(() => onChange(defaultValue, false, true)),
            ],
          ),
        ),
        // Expanded(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: "$defaultValue".text.color(Colors.white).make().p4().px8().box.roundedSM.color(Colors.black,).make(),
        //   ),
        // ),

        Text(
          '$defaultValue',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                width: 50,
                height: 50,

                child: Icon(FlutterIcons.plus_ant, color: Colors.black),
              )


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
        .border(color: Color(0xFF181725))
        .rounded
        .make();


  }
}

class sCustomStepper extends StatefulWidget {
  sCustomStepper({Key key, this.defaultValue, this.max, this.onChange})
      : super(key: key);

  final int defaultValue;
  final int max;
  final Function(int) onChange;
  @override
  _sCustomStepperState createState() => _sCustomStepperState();
}

class _sCustomStepperState extends State<sCustomStepper> {
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
