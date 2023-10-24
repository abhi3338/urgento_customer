import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/vendor/popular_services.vm.dart';
import 'package:fuodz/view_models/vendor/services_by_id.vm.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';
import 'package:fuodz/widgets/custom_masonry_grid_view.dart';
import 'package:fuodz/widgets/list_items/service.gridview_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ServicesByIdView extends StatefulWidget {
  const ServicesByIdView(this.vendorType, this.CatId, {Key key}) : super(key: key);

  final VendorType vendorType;
  final int CatId;

  @override
  _ServicesByIdViewState createState() => _ServicesByIdViewState();
}

class _ServicesByIdViewState extends State<ServicesByIdView> {

  bool showGrid = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServicesByIdViewModel>.reactive(
      viewModelBuilder: () => ServicesByIdViewModel(context, widget.vendorType),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        if (vm.isBusy) {
          return const SizedBox.shrink();
        }
        return VStack([

          if (!vm.isBusy && vm.servicesDataList.isNotEmpty)

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _getCategoryText(widget.CatId),
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    height: 1.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                    color: Utils.textColorByBrightness(context),
                    fontSize: 18.0,
                    letterSpacing: 0.025),
              ),
            ),


          CustomMasonryGridView(
            isLoading: vm.isBusy,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            items: vm.servicesDataList.map((service) {
              return ServiceGridViewItem(
                service: service,
                onPressed: vm.serviceSelected,
              );
            }).toList(),
          ).p12(),

          CustomOutlineButton(
            height: 24,
            child: "View More"
                .tr()
                .text
                .medium
                .sm
                .color(Utils.textColorByTheme())
                .makeCentered(),
            onPressed: vm.openSearch,
          ).px20(),

        ]).py12();
      },
    );
  }
}

String _getCategoryText(int catId) {
  switch (catId) {
    case 37:
      return "Electrician Services⚡";
    case 38:
      return "Plumbing Services🚿";
  // Add more cases for other CatIds as needed
    default:
      return "Popular service";
  }
}

