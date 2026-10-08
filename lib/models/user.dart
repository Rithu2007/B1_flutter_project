class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  static const AppUser demoUser = AppUser(
    id: 'user_thanuj_01',
    name: 'Thanuj Allam',
    email: 'demo@localgrocery.app',
    phone: '+91 98765 43210',
    avatarUrl: null,
  );
}
