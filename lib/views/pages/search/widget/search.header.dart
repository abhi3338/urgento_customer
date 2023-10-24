import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/search.vm.dart';
import 'package:fuodz/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader(
    this.model, {
    Key key,
    this.subtitle,
    this.showCancel = true,
  }) : super(key: key);

  final SearchViewModel model;
  final bool showCancel;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //Appbar
        HStack(
          [
            VStack(
              [
                "Search".tr().text.semiBold.xl2.make(),
                Visibility(
                  visible: subtitle != null && subtitle.isNotEmpty,
                  child: "$subtitle".text.make(),
                ),
                Visibility(
                  visible: subtitle == null,
                  child: "Ordered by Nearby first".tr().text.make(),
                ),
              ],
            ).expand(),

            //
            showCancel
                ? Icon(
                    FlutterIcons.close_ant,
                  ).p4().onInkTap(context.pop)
                : UiSpacer.emptySpace(),
          ],
        ).pOnly(bottom: 10),
        //
        SearchBarInput(
          readOnly: false,
          showFilter: true,
          onSubmitted: (keyword) {
            model.keyword = keyword;
            model.startSearch();
          },
          onFilterPressed: () => model.showFilterOptions(),
        ),
      ],
    );
  }
}
