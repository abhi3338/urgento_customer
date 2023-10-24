import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
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




