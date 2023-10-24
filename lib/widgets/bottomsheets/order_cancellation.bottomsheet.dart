import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderCancellationBottomSheet extends StatefulWidget {
  OrderCancellationBottomSheet({this.onSubmit, Key key}) : super(key: key);

  final Function(String) onSubmit;
  @override
  _OrderCancellationBottomSheetState createState() =>
      _OrderCancellationBottomSheetState();
}

class _OrderCancellationBottomSheetState
    extends State<OrderCancellationBottomSheet> {
  String _selectedReason = "custom";
  TextEditingController reasonTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Order Cancellation".tr().text.semiBold.xl.make(),
        "Please state why you want to cancel order".tr().text.make(),
        //default reasons
        RadioGroup<String>.builder(
          spacebetween: Vx.dp32,
          groupValue: _selectedReason,
          onChanged: (value) => setState(() {
            _selectedReason = value;
          }),
          items: AppStrings.orderCancellationReasons,
          itemBuilder: (item) => RadioButtonBuilder(
            item.tr().allWordsCapitilize(),
          ),
        ).py12(),
        //custom
        _selectedReason == "custom"
            ? CustomTextFormField(
                labelText: "Reason".tr(),
                textEditingController: reasonTEC,
              ).py12()
            : UiSpacer.emptySpace(),
        //
        CustomButton(
          title: "Submit".tr(),
          onPressed: () {
            if (_selectedReason == "custom") {
              _selectedReason = reasonTEC.text;
            }
            //
            widget.onSubmit(_selectedReason);
          },
        ),
      ],
    ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom);
  }
}
