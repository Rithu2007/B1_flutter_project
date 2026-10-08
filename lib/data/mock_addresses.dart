import '../models/address.dart';

final List<Address> mockAddresses = [
  const Address(
    id: 'addr_01',
    fullName: 'Thanuj Allam',
    phone: '+91 98765 43210',
    houseNumber: 'Flat 402, Green Towers',
    street: 'Road No. 36, Jubilee Hills',
    area: 'Jubilee Hills',
    city: 'Hyderabad',
    state: 'Telangana',
    pincode: '500033',
    type: 'Home',
    isDefault: true,
  ),
  const Address(
    id: 'addr_02',
    fullName: 'Thanuj Allam',
    phone: '+91 98765 43210',
    houseNumber: 'Level 5, Cyber Gateway',
    street: 'Hitech City Main Road',
    area: 'Madhapur',
    city: 'Hyderabad',
    state: 'Telangana',
    pincode: '500081',
    type: 'Office',
    isDefault: false,
  ),
];
