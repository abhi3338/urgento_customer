import 'package:intl/intl.dart';

class NotificationModel {
  int index;
  String title;
  String body;
  String image;
  int timeStamp;
  bool read;

  NotificationModel({
    this.index,
    this.title,
    this.body,
    this.timeStamp,
    this.image,
    this.read = false,
  });

  String get formattedTimeStamp {
    final notificationDateTime =
        DateTime.fromMillisecondsSinceEpoch(this.timeStamp);
    final formmartedDate = DateFormat("EEE dd, MMM yyyy").format(
      notificationDateTime,
    );
    return "$formmartedDate";
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        "image": image,
        'timeStamp': timeStamp,
        'read': read,
      };
}
