class Address {
  final String id;
  final String fullName;
  final String phone;
  final String houseNumber;
  final String street;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final String type; // Home, Office, Other
  final bool isDefault;

  const Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.houseNumber,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    this.type = 'Home',
    this.isDefault = false,
  });

  String get formattedAddress => '$houseNumber, $street, $area, $city, $state - $pincode';
  String get shortAddress => '$houseNumber, $street, $area, $city';

  Address copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? houseNumber,
    String? street,
    String? area,
    String? city,
    String? state,
    String? pincode,
    String? type,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      houseNumber: houseNumber ?? this.houseNumber,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'houseNumber': houseNumber,
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'type': type,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      houseNumber: map['houseNumber'] as String,
      street: map['street'] as String,
      area: map['area'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      pincode: map['pincode'] as String,
      type: map['type'] as String? ?? 'Home',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }
}
