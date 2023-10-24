import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherBusyLoad extends StatelessWidget {
  const OtherBusyLoad({this.color, Key key}) : super(key: key);

  final Color color;
  @override
  Widget build(BuildContext context) {
    final linerHeight = 200.00;
    //
    return VxBox(
      child: VStack(
        [
          Container(
            color: Colors.grey.withOpacity(0.7),
          ).h(linerHeight),

        ],
      ),
    )
        .rounded
        .clip(Clip.antiAlias)
        .make()
        .shimmer(
      primaryColor: Colors.grey.withOpacity(0.7),
      secondaryColor: Colors.white,
    );
  }
}
