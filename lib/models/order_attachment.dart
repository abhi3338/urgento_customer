// To parse this JSON data, do
//
//     final orderAttachment = orderAttachmentFromJson(jsonString);

import 'dart:convert';

OrderAttachment orderAttachmentFromJson(String str) => OrderAttachment.fromJson(json.decode(str));

String orderAttachmentToJson(OrderAttachment data) => json.encode(data.toJson());

class OrderAttachment {
    OrderAttachment({
        this.link,
        this.collectionName,
    });

    String link;
    String collectionName;

    factory OrderAttachment.fromJson(Map<String, dynamic> json) => OrderAttachment(
        link: json["link"],
        collectionName: json["collection_name"],
    );

    Map<String, dynamic> toJson() => {
        "link": link,
        "collection_name": collectionName,
    };
}
