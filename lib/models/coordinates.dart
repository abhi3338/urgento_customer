class Coordinates {
  /// The geographic coordinate that specifies the north–south position of a point on the Earth's surface.
  final double latitude;

  /// The geographic coordinate that specifies the east-west position of a point on the Earth's surface.
  final double longitude;

  Coordinates(this.latitude, this.longitude);

  /// Creates coordinates from a map containing its properties.
  Coordinates.fromMap(Map map)
      : this.latitude = double.parse(
            (map.containsKey("latitude") ? map["latitude"] : map["lat"])
                .toString()),
        this.longitude = double.parse(
            (map.containsKey("longitude") ? map["longitude"] : map["lng"])
                .toString());

  /// Creates a map from the coordinates properties.
  Map toMap() => {
        "latitude": this.latitude,
        "longitude": this.longitude,
      };

  String toString() => "$latitude,$longitude";
}
