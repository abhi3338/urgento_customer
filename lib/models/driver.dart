import 'package:fuodz/models/user.dart';
import 'package:fuodz/models/vehicle.dart';
import 'package:supercharged/supercharged.dart';

class Driver extends User {
  Vehicle vehicle;
  double rating;
  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    photo = json['photo'] ?? "";
    role = json['role_name'] ?? "driver";
    rating = (json['rating'] ?? 3).toString().toDouble();
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }
}
