import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/utils.dart';

class DirectionalChevron extends StatelessWidget {
  const DirectionalChevron({this.size, this.color, Key key}) : super(key: key);

  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Utils.isArabic
          ? FlutterIcons.chevron_left_ent
          : FlutterIcons.chevron_right_ent,
      color: color ?? Colors.grey.shade500,
      size: size,
    );
  }
}
