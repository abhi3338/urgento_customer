import 'package:flutter/material.dart';

class AlternativeView extends StatelessWidget {
  const AlternativeView({
    this.ismain = true,
    @required this.main,
    this.alt,
    Key key,
  }) : super(key: key);

  final bool ismain;
  final Widget main;
  final Widget alt;

  @override
  Widget build(BuildContext context) {
    return ismain ? main : alt;
  }
}
