import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';

class ServiceDetailsPriceSectionView extends StatelessWidget {
  const ServiceDetailsPriceSectionView(this.service,
      {this.onlyPrice = false, Key key})
      : super(key: key);

  final Service service;
  final bool onlyPrice;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppStrings.currencySymbol;
    return HStack(
      [
        CurrencyHStack(
          [

            Wrap(
              children: [
                //price
                CurrencyHStack(
                  [
                    currencySymbol.text.sm.make(),
                    (service.showDiscount
                        ? service.discountPrice.currencyValueFormat()
                        : service.price.currencyValueFormat())
                        .text
                        .lg
                        .semiBold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                UiSpacer.horizontalSpace(),
                //discount price
                CustomVisibilty(
                  visible: service.showDiscount,
                  child: CurrencyHStack(
                    [
                      currencySymbol.text.lineThrough.xs.make(),
                      service.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .lg
                          .medium
                          .make(),
                    ],
                  ),
                ),
              ],
            ),




          ],

        ),

        " ${service.durationText}".text.medium.xl.make(),
        UiSpacer.horizontalSpace(space: 5),
        //discount
        Visibility(
          visible: !onlyPrice,
          child: service.showDiscount
              ? "%s Off"
                  .tr()
                  .fill(["${service.discountPercentage}%"])
                  .text
                  .white
                  .semiBold
                  .make()
                  .p2()
                  .px4()
                  .box
                  .red500
                  .roundedLg
                  .make()
              : UiSpacer.emptySpace(),
        ),
        //
        UiSpacer.emptySpace().expand(),
        //rating
        Visibility(
          visible: !onlyPrice,
          child: VxRating(
            value: double.parse((service?.vendor?.rating ?? 5.0).toString()),
            count: 5,
            isSelectable: false,
            onRatingUpdate: null,
            selectionColor: AppColor.ratingColor,
            normalColor: Colors.grey,
            size: 18,
          ),
        ),
      ],
    );
  }
}
