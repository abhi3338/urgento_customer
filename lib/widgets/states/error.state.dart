import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingError extends StatelessWidget {
  const LoadingError({this.onrefresh, Key key}) : super(key: key);

  final Function onrefresh;
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.error,
      showAction: true,
      actionPressed: onrefresh,
      actionText: "Retry".tr(),
      title: "An error occured".tr(),
      description:
          "There was an error while processing your request. Please try again"
              .tr(),
    ).p20();
  }
}
