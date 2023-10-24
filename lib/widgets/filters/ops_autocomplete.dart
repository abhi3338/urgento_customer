import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/view_models/ops_map.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OPSAutocompleteTextField extends StatelessWidget {
  const OPSAutocompleteTextField({
    this.onselected,
    this.textEditingController,
    this.inputDecoration,
    this.debounceTime,
    Key key,
  }) : super(key: key);

  final Function(Address) onselected;
  final TextEditingController textEditingController;
  final InputDecoration inputDecoration;
  final int debounceTime;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OPSMapViewModel>.reactive(
      viewModelBuilder: () => OPSMapViewModel(context),
      builder: (ctx, vm, child) {
        return TypeAheadFormField<Address>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController ?? vm.searchTEC,
            decoration: inputDecoration ??
                InputDecoration(
                  hintText: 'Search address'.tr(),
                ),
          ),
          minCharsForSuggestions: 3,
          //0.9 seconds
          debounceDuration: Duration(milliseconds: debounceTime),
          suggestionsCallback: (keyword) async {
            return await vm.fetchPlaces(keyword);
          },
          keepSuggestionsOnLoading: false,
          noItemsFoundBuilder: (ctx) {
            return "No Address found".tr().text.make().p12();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: suggestion.addressLine.text.base.semiBold.make(),
              subtitle: suggestion.adminArea.text.sm.make(),
            );
          },

          onSuggestionSelected: (address) async {
            final mAddress = await vm.fetchPlaceDetails(address);
            this.onselected(mAddress);
          },
        );
      },
    );
  }
}
