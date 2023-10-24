import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DropdownInput extends StatefulWidget {
  DropdownInput({
    this.title,
    @required this.options,
    this.onChanged,
    Key key,
  }) : super(key: key);

  final String title;
  final List<dynamic> options;
  final Function(dynamic) onChanged;

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  dynamic selectedValue;

  @override
  void initState() {
    super.initState();
    //
    setState(() {
      selectedValue = widget.options.first;
    });
    //
    widget.onChanged(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      elevation: 0,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        border: OutlineInputBorder(
          gapPadding: 2.0,
          borderSide: BorderSide(
            width: 10,
            color: Colors.red,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 12,
        color: context.textTheme.bodyLarge.color,
      ),
      value: selectedValue ?? widget.options.first,
      items: widget.options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: "${option.name}".text.make(),
        );
      }).toList(),
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged(value);
        }
        //
        setState(() {
          selectedValue = value;
        });
      },
    ).h(32);
  }
}
