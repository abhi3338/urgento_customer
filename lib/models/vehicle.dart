class Vehicle {
  int id;
  String reg_no;
  String color;
  String carMake;
  String carModel;

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reg_no = json['reg_no'];
    color = json['color'];
    carMake = json['car_model']["car_make"]["name"];
    carModel = json['car_model']["name"];
  }

  //
  String get vehicleInfo {
    return "$color $carMake $carModel";
  }
}
