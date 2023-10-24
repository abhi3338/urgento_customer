import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';

class CustomVisibilty extends StatelessWidget {
  const CustomVisibilty({@required this.child, this.visible = true, Key key})
      : super(key: key);

  final Widget child;
  final bool visible;
  @override
  Widget build(BuildContext context) {
    return visible ? child : UiSpacer.emptySpace();
  }
}
