import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/utils.dart';

class ArrowIndicator extends StatelessWidget {
  const ArrowIndicator(this.size, {Key key}) : super(key: key);

  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Utils.isArabic
          ? FlutterIcons.chevron_left_fea
          : FlutterIcons.chevron_right_fea,
      size: size ?? 32,
    );
  }
}
