import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductImagesGalleryView extends StatefulWidget {
  ProductImagesGalleryView(this.product, {Key key}) : super(key: key);

  final Product product;
  @override
  State<ProductImagesGalleryView> createState() =>
      _ProductImagesGalleryViewState();
}

class _ProductImagesGalleryViewState extends State<ProductImagesGalleryView> {
  //
  String selectedPhoto;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //currently selected image
        CustomImage(
          imageUrl: selectedPhoto ?? widget.product.photo,
          boxFit: BoxFit.contain,
          height: context.percentHeight * 30,
          width: double.infinity,
          canZoom: true,
        ).box.color(AppColor.faintBgColor).make(),
        //preview of other items
        CustomVisibilty(
          visible: widget.product.photos.length > 1,
          child: CustomListView(
            padding: EdgeInsets.symmetric(horizontal: Vx.dp12),
            scrollDirection: Axis.horizontal,
            dataSet: widget.product.photos,
            itemBuilder: (context, index) {
              final photo = widget.product.photos[index];
              //
              return CustomImage(
                imageUrl: photo,
                boxFit: BoxFit.contain,
                height: 70,
                width: 60,
                canZoom: true,
              ).box.color(AppColor.faintBgColor).make().onInkTap(() {
                setState(() {
                  selectedPhoto = photo;
                });
              });
            },
          ).h(80).box.color(context.theme.colorScheme.background).make(),
        ),
      ],
    );
  }
}
