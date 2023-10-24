// To parse this JSON data, do
//
//     final vendor = vendorFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/delivery_slot.dart';
import 'package:fuodz/models/fee.dart';
import 'package:fuodz/models/menu.dart';
import 'package:fuodz/models/package_type_pricing.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:random_string/random_string.dart';

class Vendor {
  Vendor({
    this.id,
    this.vendorTypeId,
    this.vendorType,
    this.name,
    this.description,
    this.baseDeliveryFee,
    this.deliveryFee,
    this.deliveryRange,
    this.distance,
    this.tax,
    this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.comission,
    this.pickup,
    this.delivery,
    this.rating,
    this.reviews_count,
    this.chargePerKm,
    this.isOpen,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.formattedDate,
    this.logo,
    this.featureImage,
    this.menus,
    this.categories,
    this.packageTypesPricing,
    this.fees,
    this.cities,
    this.states,
    this.countries,
    this.deliverySlots,
    this.canRate,
    this.allowScheduleOrder,
    this.hasSubcategories,
    //
    this.minOrder,
    this.maxOrder,
    this.prepareTime,
    this.deliveryTime,
  }) {
    this.heroTag = randomAlphaNumeric(15) + "$id";
  }

  int id;
  int vendorTypeId;
  VendorType vendorType;
  String heroTag;
  String name;
  String description;
  double baseDeliveryFee;
  double deliveryFee;
  double deliveryRange;
  double distance;
  String tax;
  String phone;
  String email;
  String address;
  String latitude;
  String longitude;
  double comission;
  double minOrder;
  double maxOrder;
  int pickup;
  int delivery;
  int rating;
  int reviews_count;
  int chargePerKm;
  bool isOpen;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  String logo;
  String featureImage;
  List<Menu> menus;
  List<Category> categories;
  List<PackageTypePricing> packageTypesPricing;
  List<DeliverySlot> deliverySlots;
  List<Fee> fees;
  List<String> cities;
  List<String> states;
  List<String> countries;
  bool canRate;
  bool allowScheduleOrder;
  bool hasSubcategories;
  String prepareTime;
  String deliveryTime;

  factory Vendor.fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json["id"] == null ? null : json["id"],
      vendorTypeId: json["vendor_type_id"],
      vendorType: json["vendor_type"] == null
          ? null
          : VendorType.fromJson(json["vendor_type"]),
      name: json["name"] == null ? null : json["name"],
      description: json["description"] == null ? null : json["description"],
      baseDeliveryFee: json["base_delivery_fee"] == null
          ? 0.00
          : double.parse(json["base_delivery_fee"].toString()),
      deliveryFee: json["delivery_fee"] == null
          ? 0.00
          : double.parse(json["delivery_fee"].toString()),
      deliveryRange: json["delivery_range"] == null
          ? null
          : double.parse(json["delivery_range"].toString()),
      distance: json["distance"] == null
          ? null
          : double.parse(json["distance"].toString()),
      tax: json["tax"] == null ? null : json["tax"],
      phone: json["phone"] == null ? null : json["phone"],
      email: json["email"] == null ? null : json["email"],
      address: json["address"] == null ? null : json["address"],
      latitude: json["latitude"] == null ? null : json["latitude"],
      longitude: json["longitude"] == null ? null : json["longitude"],
      comission: json["comission"] == null
          ? null
          : double.parse(json["comission"].toString()),
      pickup: json["pickup"] == null ? 0 : int.parse(json["pickup"].toString()),
      delivery:
          json["delivery"] == null ? 0 : int.parse(json["delivery"].toString()),
      rating:
          json["rating"] == null ? null : int.parse(json["rating"].toString()),
      reviews_count: json["reviews_count"],
      chargePerKm: json["charge_per_km"] == null
          ? null
          : int.parse(json["charge_per_km"].toString()),
      isOpen: json["is_open"] == null ? true : json["is_open"],
      isActive: json["is_active"] == null
          ? null
          : int.parse(json["is_active"].toString()),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      formattedDate:
          json["formatted_date"] == null ? null : json["formatted_date"],
      logo: json["logo"] == null ? null : json["logo"],
      featureImage:
          json["feature_image"] == null ? null : json["feature_image"],
      menus: json["menus"] == null
          ? []
          : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"].map((x) => Category.fromJson(x))),
      packageTypesPricing: json["package_types_pricing"] == null
          ? []
          : List<PackageTypePricing>.from(json["package_types_pricing"]
              .map((x) => PackageTypePricing.fromJson(x))),
      //cities
      cities: json["cities"] == null
          ? []
          : List<String>.from(json["cities"].map((e) => e["name"])),
      states: json["states"] == null
          ? []
          : List<String>.from(json["states"].map((e) => e["name"])),
      countries: json["cities"] == null
          ? []
          : List<String>.from(json["countries"].map((e) => e["name"])),
      //
      deliverySlots: json["slots"] == null
          ? []
          : List<DeliverySlot>.from(
              json["slots"].map((x) => DeliverySlot.fromJson(x))),
      fees: json["fees"] == null
          ? []
          : List<Fee>.from(json["fees"].map((x) => Fee.fromJson(x))),

      //
      canRate: json["can_rate"] == null ? null : json["can_rate"],
      hasSubcategories: json["has_sub_categories"] == null
          ? false
          : json["has_sub_categories"],
      allowScheduleOrder: json["allow_schedule_order"] == null
          ? false
          : json["allow_schedule_order"],

      //
      minOrder:
          (json["min_order"] == null || json["min_order"].toString().isEmpty)
              ? null
              : (double.parse(json["min_order"].toString()) ?? null),
      maxOrder:
          (json["max_order"] == null || json["max_order"].toString().isEmpty)
              ? null
              : (double.parse(json["max_order"].toString()) ?? null),
      //
      prepareTime: json["prepare_time"],
      deliveryTime: json["delivery_time"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "vendor_type_id": vendorTypeId,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "base_delivery_fee": baseDeliveryFee,
        "delivery_fee": deliveryFee == null ? null : deliveryFee,
        "delivery_range": deliveryRange == null ? null : deliveryRange,
        "distance": distance,
        "tax": tax == null ? null : tax,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "address": address == null ? null : address,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "comission": comission == null ? null : comission,
        "min_order": minOrder == null ? null : minOrder,
        "max_order": maxOrder == null ? null : maxOrder,
        "pickup": pickup,
        "delivery": delivery,
        "rating": rating,
        "reviews_count": reviews_count,
        "charge_per_km": chargePerKm == null ? null : chargePerKm,
        "is_open": isOpen == null ? null : isOpen,
        "is_active": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "formatted_date": formattedDate == null ? null : formattedDate,
        "logo": logo == null ? null : logo,
        "feature_image": featureImage == null ? null : featureImage,
        "can_rate": canRate == null ? null : canRate,
        "allow_schedule_order": allowScheduleOrder,
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "package_types_pricing": packageTypesPricing == null
            ? null
            : List<dynamic>.from(packageTypesPricing.map((x) => x.toJson())),
        "slots": deliverySlots == null
            ? null
            : List<dynamic>.from(deliverySlots.map((x) => x.toJson())),
        "fees": fees == null
            ? null
            : List<dynamic>.from(fees.map((x) => x.toJson())),
        //
        "prepare_time": prepareTime,
        "delivery_time": deliveryTime,
      };

  //
  bool get allowOnlyDelivery => delivery == 1 && pickup == 0;
  bool get allowOnlyPickup => delivery == 0 && pickup == 1;
  bool get isServiceType => vendorType != null && vendorType?.slug == "service";
  bool get isPharmacyType =>
      vendorType != null && vendorType?.slug == "pharmacy";

  //
  bool canServiceLocation(DeliveryAddress deliveryaddress) {
    //cities,states & countries
    if (this.countries != null) {
      final foundCountry = this.countries.firstWhere(
            (element) =>
                element.toLowerCase() ==
                "${deliveryaddress.country}".toLowerCase(),
            orElse: () => null,
          );

      //
      if (foundCountry != null) {
        print("Country found");
        return true;
      }
    }

    //states
    if (this.states != null) {
      final foundState = this.states.firstWhere(
            (element) =>
                element.toLowerCase() ==
                "${deliveryaddress.state}".toLowerCase(),
            orElse: () => null,
          );

      //
      if (foundState != null) {
        print("state found");
        return true;
      }
    }

    //cities
    if (this.cities != null) {
      final foundCity = this.cities.firstWhere(
        (element) {
          return element.toLowerCase() == deliveryaddress.city.toLowerCase();
        },
        orElse: () => null,
      );

      //
      if (foundCity != null) {
        print("city found");
        return true;
      }
    }
    return false;
  }
}
