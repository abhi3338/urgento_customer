import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/vendor.dart';

class Banner {
  int id;
  String name;
  String link;
  String imageUrl;
  Category category;
  Vendor vendor;

  Banner();

  factory Banner.fromJSON(dynamic json) {
    final banner = Banner();
    banner.id = json["id"];
    banner.name = json["name"];
    banner.link = json["link"];
    banner.imageUrl = json["photo"];

    //load category if included
    if (json["category"] != null) {
      banner.category = Category.fromJson(json["category"]);
    }
    if (json["vendor"] != null) {
      banner.vendor = Vendor.fromJson(json["vendor"]);
    }
    return banner;
  }
}
