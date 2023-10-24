import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderAttachmentView extends StatelessWidget {
  const OrderAttachmentView(this.vm, {Key key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: vm.order.attachments != null && vm.order.attachments.isNotEmpty,
      child: VStack(
        [
          "Attachments".tr().text.xl.semiBold.make(),
          UiSpacer.vSpace(10),
          CustomGridView(
            dataSet: vm.order.attachments,
            noScrollPhysics: true,
            itemBuilder: (ctx, index) {
              final attachment = vm.order.attachments[index];
              return Column(
                children: [
                  CustomImage(
                    imageUrl: attachment.link,
                    canZoom: true,
                    width: double.infinity,
                    height: ctx.percentHeight * 14,
                  ),
                  //
                  "${attachment.collectionName}".text.make().py2(),
                ],
              );
            },
          ),
        ],
      ).p8().p12(),
    );
  }
}
