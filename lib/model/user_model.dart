class Address {
  int? id;
  String? name;
  String? phoneNumber;
  String? street;
  String? city;
  String? state;
  String? pinCode;
  String? type;
  bool? isDefault;
  String? landmark;

  Address({
    this.id,
    this.name,
    this.phoneNumber,
    this.street,
    this.city,
    this.state,
    this.pinCode,
    this.type,
    this.isDefault,
    this.landmark,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      pinCode: json['pinCode'],
      type: json['type'],
      isDefault: json['isDefault'],
      landmark: json['landmark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'street': street,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'type': type,
      'isDefault': isDefault,
      'landmark': landmark,
    };
  }

  @override
  String toString() {
    return 'Address(id: $id, name: $name, type: $type, isDefault: $isDefault, city: $city)';
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  String? profileImage;
  bool? isPhoneVerified;
  List<Address>? addresses;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.profileImage,
    this.isPhoneVerified,
    this.addresses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role']?.toString(),
      profileImage: json['profileImage'],
      isPhoneVerified: json['isPhoneVerified'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'profileImage': profileImage,
      'isPhoneVerified': isPhoneVerified,
      'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, addresses: $addresses)';
  }
}
