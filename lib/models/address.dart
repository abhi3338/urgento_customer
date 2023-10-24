import 'coordinates.dart';

class Address {
  /// The geographic coordinates.
  final Coordinates coordinates;

  /// The formatted address with all lines.
  final String addressLine;

  /// The localized country name of the address.
  final String countryName;

  /// The country code of the address.
  final String countryCode;

  /// The feature name of the address.
  final String featureName;

  /// The postal code.
  final String postalCode;

  /// The administrative area name of the address
  final String adminArea;

  /// The sub-administrative area name of the address
  final String subAdminArea;

  /// The locality of the address
  final String locality;

  /// The sub-locality of the address
  final String subLocality;

  String gMapPlaceId;

  Address({
    this.coordinates,
    this.addressLine,
    this.countryName,
    this.countryCode,
    this.featureName,
    this.postalCode,
    this.adminArea,
    this.subAdminArea,
    this.locality,
    this.subLocality,
  });

/*
  [
    geometry -> location -> [lat,lng],
    formatted_address,
    country,
    country_code,
    postal_code,
    locality, 
    sublocality
    administrative_area_level_1
    administrative_area_level_2
    thorough_fare
    sub_thorough_fare
  ]
  */
  /// Creates an address from a map containing its properties.
  Address fromMap(Map map) {
    return new Address(
      coordinates: map["geometry"] != null
          ? new Coordinates.fromMap(map["geometry"]["location"])
          : null,
      addressLine: map['description'],
      //map["addressLine"],
      countryName: getTypeFromAddressComponents("country", map),
      //map["countryName"],
      countryCode: getTypeFromAddressComponents(
        "country",
        map,
        nameTye: "short_name",
      ),
      //map["countryCode"],
      featureName: map["structured_formatting"]["main_text"],
      //map["featureName"],
      postalCode: getTypeFromAddressComponents("postal_code", map),
      //map["postalCode"],
      locality: getTypeFromAddressComponents("locality", map),
      //map["locality"],
      subLocality: getTypeFromAddressComponents("sublocality", map),
      //map["subLocality"],
      adminArea:
          getTypeFromAddressComponents("administrative_area_level_1", map),
      //map["adminArea"],
      subAdminArea:
          getTypeFromAddressComponents("administrative_area_level_2", map),
      //map["subAdminArea"],
    );
  }

  Address fromServerMap(Map map) {
    return new Address(
      coordinates: new Coordinates.fromMap(map["geometry"]["location"]),
      addressLine: map['formatted_address'],
      //map["addressLine"],
      countryName: map['country'],
      //map["countryName"],
      countryCode: map['country_code'],
      //map["countryCode"],
      featureName: map['feature_name'] ?? map['formatted_address'],
      //map["featureName"],
      postalCode: map["postal_code"],
      //map["postalCode"],
      locality: map["locality"],
      //map["locality"],
      subLocality: map["sublocality"],
      //map["subLocality"],
      adminArea: map["administrative_area_level_1"],
      //map["adminArea"],
      subAdminArea: map["administrative_area_level_2"],
      //map["subAdminArea"],
    );
  }

  Address fromPlaceDetailsMap(Map map) {
    return new Address(
      coordinates: map["geometry"] != null
          ? new Coordinates.fromMap(map["geometry"]["location"])
          : null,
      addressLine: map['formatted_address'],
      //map["addressLine"],
      countryName: getTypeFromAddressComponents("country", map),
      //map["countryName"],
      countryCode: getTypeFromAddressComponents(
        "country",
        map,
        nameTye: "short_name",
      ),
      //map["countryCode"],
      featureName: map["name"],
      //map["featureName"],
      postalCode: getTypeFromAddressComponents("postal_code", map),
      //map["postalCode"],
      locality: getTypeFromAddressComponents("locality", map),
      //map["locality"],
      subLocality: getTypeFromAddressComponents("sublocality", map),
      //map["subLocality"],
      adminArea:
          getTypeFromAddressComponents("administrative_area_level_1", map),
      //map["adminArea"],
      subAdminArea:
          getTypeFromAddressComponents("administrative_area_level_2", map),
      //map["subAdminArea"],
    );
  }

  /// Creates a map from the address properties.
  Map toMap() => {
        "coordinates": this.coordinates.toMap(),
        "addressLine": this.addressLine,
        "countryName": this.countryName,
        "countryCode": this.countryCode,
        "featureName": this.featureName,
        "postalCode": this.postalCode,
        "locality": this.locality,
        "subLocality": this.subLocality,
        "adminArea": this.adminArea,
        "subAdminArea": this.subAdminArea,
      };

  //
  String getTypeFromAddressComponents(
    String type,
    Map searchResult, {
    String nameTye = "long_name",
  }) {
    //
    String result = "";
    //
    if (searchResult["address_components"] != null) {
      for (var componenet in (searchResult["address_components"] as List)) {
        final found = (componenet["types"] as List).contains(type);
        if (found) {
          //
          result = componenet[nameTye];
          break;
        }
      }
    }
    return result;
  }
}
