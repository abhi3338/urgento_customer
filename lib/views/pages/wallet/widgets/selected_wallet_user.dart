import 'package:flutter/material.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectedWalletUser extends StatelessWidget {
  const SelectedWalletUser(this.selectedUser, {Key key}) : super(key: key);

  final User selectedUser;

  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      visible: selectedUser != null,
      child: HStack(
        [
          //profile photo
          CustomImage(
            imageUrl: selectedUser?.photo,
            boxFit: BoxFit.fill,
          ).box.clip(Clip.antiAlias).roundedFull.make().wh(60, 60),
          UiSpacer.horizontalSpace(),
          //name and email
          VStack(
            [
              //
              "${selectedUser?.name}".text.semiBold.lg.make(),
              "${selectedUser?.phone}"
                  .hidePartial(
                    begin: selectedUser != null
                        ? ((3 / 10) * selectedUser.phone.length).floor()
                        : 4,
                    end: selectedUser != null
                        ? ((8 / 10) * selectedUser.phone.length).floor()
                        : 9,
                  )
                  .text
                  .light
                  .sm
                  .make(),
            ],
          ).expand(),
          //
        ],
      )
          .p8()
          .box
          .roundedSM
          .color(context.theme.colorScheme.background)
          .outerShadow
          .make()
          .py12(),
    );
  }
}
