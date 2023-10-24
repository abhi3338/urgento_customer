// To parse this JSON data, do
//
//     final digitalFile = digitalFileFromJson(jsonString);

import 'dart:convert';

DigitalFile digitalFileFromJson(String str) => DigitalFile.fromJson(json.decode(str));

String digitalFileToJson(DigitalFile data) => json.encode(data.toJson());

class DigitalFile {
    DigitalFile({
        this.name,
        this.size,
        this.link,
    });

    String name;
    int size;
    String link;

    factory DigitalFile.fromJson(Map<String, dynamic> json) => DigitalFile(
        name: json["name"],
        size: json["size"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "link": link,
    };
}
