// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/digital_file.dart';
import 'package:fuodz/models/option.dart';
import 'package:fuodz/models/tag.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:random_string/random_string.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.name,
    this.barcode,
    this.description,
    this.price,
    this.discountPrice,
    this.capacity,
    this.unit,
    this.packageCount,
    this.featured,
    this.plusOption,
    this.isFavourite,
    this.deliverable,
    this.digital,
    this.digitalFiles,
    this.isActive,
    this.vendorId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.formattedDate,
    this.photo,
    this.vendor,
    this.optionGroups,
    this.availableQty,
    this.selectedQty,
    this.photos,
    //
    this.rating,
    this.reviewsCount,
    this.tag
  }) {
    this.heroTag = randomAlphaNumeric(15) + "$id";
  }

  int id;
  String heroTag;
  String name;
  String barcode;
  String description;
  double price;
  double discountPrice;
  String capacity;
  String unit;
  String packageCount;
  int featured;
  int plusOption;
  bool isFavourite;
  int deliverable;
  int digital;
  int isActive;
  int vendorId;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  String photo;
  Vendor vendor;
  List<OptionGroup> optionGroups;
  List<String> photos;
  List<Option> selectedOptions = [];
  List<DigitalFile> digitalFiles = [];
  List<Tag> tag = [];

  //
  int availableQty;
  int selectedQty;
  //
  double rating;
  int reviewsCount;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        description: json["description"] == null ? "" : json["description"],
        price:
        json["price"] == null ? null : double.parse(json["price"].toString()),
        discountPrice: json["discount_price"] == null
            ? null
            : double.parse(json["discount_price"].toString()),
        capacity: json["capacity"] == null ? null : json["capacity"].toString(),
        unit: json["unit"] == null ? null : json["unit"],
        packageCount: json["package_count"] == null
            ? null
            : json["package_count"].toString(),
        featured: json["featured"] == null
            ? null
            : int.parse(json["featured"].toString()),
        plusOption: json["plus_option"] == null
            ? null
            : int.parse(json["plus_option"].toString()),
        isFavourite: json["is_favourite"],
        deliverable: json["deliverable"] == null
            ? null
            : int.parse(json["deliverable"].toString()),
        digital: json["digital"] == null
            ? null
            : int.parse(json["digital"].toString()),
        isActive: json["is_active"] == null
            ? null
            : int.parse(json["is_active"].toString()),
        vendorId: json["vendor_id"] == null
            ? null
            : int.parse(json["vendor_id"].toString()),
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        formattedDate: json["formatted_date"],
        photo: json["photo"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]) ?? null,
        optionGroups: json["option_groups"] == null
            ? null
            : List<OptionGroup>.from(
          json["option_groups"].map((x) => OptionGroup.fromJson(x)),
        ),
        digitalFiles: json["digital_files"] == null
            ? null
            : List<DigitalFile>.from(
          json["digital_files"].map((x) => DigitalFile.fromJson(x)),
        ),

        // photos
        photos: json["photos"] == null
            ? []
            : List<String>.from(
          json["photos"].map((x) => x),
        ),
        //
        availableQty: json["available_qty"] == null
            ? null
            : int.parse(json["available_qty"].toString()),
        selectedQty: json["selected_qty"] == null
            ? null
            : int.parse(json["selected_qty"].toString()),
        //
        rating: json["rating"] == null
            ? null
            : double.parse(json["rating"].toString()),
        reviewsCount: json["reviews_count"] == null
            ? null
            : int.parse(json["reviews_count"].toString()),
        tag: json['tags'] == null ? null : (json['tags'] as List).map((e) => Tag.fromJson(e)).toList()
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "barcode": barcode,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
    "capacity": capacity,
    "unit": unit,
    "package_count": packageCount,
    "featured": featured,
    "is_favourite": isFavourite,
    "deliverable": deliverable,
    "digital": digital,
    "is_active": isActive,
    "vendor_id": vendorId,
    "category_id": categoryId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "formatted_date": formattedDate,
    "photo": photo,
    "vendor": vendor == null ? null : vendor.toJson(),
    "option_groups": optionGroups == null
        ? null
        : List<dynamic>.from(optionGroups.map((x) => x.toJson())),
    "digital_files": digitalFiles == null
        ? null
        : List<dynamic>.from(optionGroups.map((x) => x.toJson())),

    //
    "available_qty": availableQty,
    "selected_qty": selectedQty,
    //
    "rating": rating,
    "reviews_count": reviewsCount,
  };

  //getters
  get showDiscount => (discountPrice > 0.00) && (discountPrice < price);
  get canBeDelivered => deliverable == 1;
  bool get hasStock => availableQty == null || availableQty > 0;
  double get sellPrice {
    return showDiscount ? discountPrice : price;
  }

  double get totalPrice {
    return sellPrice * (selectedQty ?? 1);
  }

  bool get isDigital {
    return digital == 1;
  }

  int get discountPercentage {
    if (discountPrice < price) {
      // return 100 - (100 * ((price - discountPrice) / price) ?? 0).floor();
      return 100 - (100 * (discountPrice / price) ?? 0).floor();
    } else {
      return 0;
    }
  }

  //
  bool optionGroupRequirementCheck() {
    //check if the option groups with required setting has an option selected
    OptionGroup optionGroupRequired = this.optionGroups.firstWhere(
          (e) => e.required == 1,
      orElse: () => null,
    );

    if (optionGroupRequired == null ||
        (optionGroupRequired != null && this.optionGroups.length <= 1)) {
      return false;
    } else {
      return true;
    }
  }
}