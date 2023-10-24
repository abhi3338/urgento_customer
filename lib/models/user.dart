class User {
  int id;

  String name;
  String code;
  String email;
  String phone;
  String rawPhone;
  String countryCode;
  String photo;
  String role;
  String walletAddress;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.countryCode,
    this.photo,
    this.role,
    this.walletAddress,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    rawPhone = json['raw_phone'];
    walletAddress = json['wallet_address'] ?? "";
    countryCode = json['country_code'];
    photo = json['photo'] ?? "";
    role = json['role_name'] ?? "client";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'email': email,
      'phone': phone,
      'raw_phone': rawPhone,
      'country_code': countryCode,
      'photo': photo,
      'role_name': role,
      'wallet_address': walletAddress,
    };
  }
}
