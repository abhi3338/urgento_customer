import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmptyServiceSearch extends StatelessWidget {
  const EmptyServiceSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptySearch,
      title: "No Service/Provider Found".tr(),
      description: "There seems to be no Service/Provider".tr(),
    );
  }
}