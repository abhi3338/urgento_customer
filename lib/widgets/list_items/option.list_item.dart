import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/option.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class OptionListItem extends StatelessWidget {
  const OptionListItem({
    this.option,
    this.optionGroup,
    this.model,
    Key key,
  }) : super(key: key);

  final Option option;
  final OptionGroup optionGroup;
  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;
    return HStack(
      [
        //image/photo
        Stack(
          children: [

            //
            CustomImage(
              imageUrl: option.photo,
              width: Vx.dp64,
              height: Vx.dp64,
            ).card.clip(Clip.antiAlias).roundedSM.make(),

            //
            model.isOptionSelected(option) ? Positioned(
              top: 5, bottom: 5, left: 5, right: 5,
              child: Icon(
                FlutterIcons.check_ant,
              ).box.color(Colors.grey).roundedSM.make(),
            ): UiSpacer.emptySpace(),
          ],
        ).onInkTap(() => model.toggleOptionSelection(optionGroup, option)),

        //details
        VStack(
          [
            //
            option.name.text.medium.lg.make(),
            option.description != null && option.description.isEmptyOrNull
                ? "${option.description}".text.sm
                    .maxLines(3)
                    .overflow(TextOverflow.ellipsis)
                    .make()
                : UiSpacer.emptySpace(),
          ],
        ).px12().expand(),

        //price
        CurrencyHStack(
          [
            currencySymbol.text.sm.medium.make(),
            option.price.currencyValueFormat().text.sm.bold.make(),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).onInkTap(() => model.toggleOptionSelection(optionGroup, option));
  }
}
