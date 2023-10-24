// To parse this JSON data, do
//
//     final tag = tagFromJson(jsonString);

import 'dart:convert';

Tag tagFromJson(String str) => Tag.fromJson(json.decode(str));

String tagToJson(Tag data) => json.encode(data.toJson());

class Tag {
  Tag({
    this.id,
    this.name,
    this.inOrder,
  });

  int id;
  String name;
  int inOrder;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        inOrder: json["in_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "in_order": inOrder,
      };
}
