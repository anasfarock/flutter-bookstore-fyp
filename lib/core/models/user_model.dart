
class UserModel {
  final String id;
  final String email;
  final String role; // 'buyer' or 'seller'
  final String name;
  final String phoneNumber;
  final String storeName;
  final String storeDescription;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.name = '',
    this.phoneNumber = '',
    this.storeName = '',
    this.storeDescription = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'phoneNumber': phoneNumber,
      'storeName': storeName,
      'storeDescription': storeDescription,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'buyer',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      storeName: map['storeName'] ?? '',
      storeDescription: map['storeDescription'] ?? '',
    );
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? storeName,
    String? storeDescription,
  }) {
    return UserModel(
      id: id,
      email: email,
      role: role,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
    );
  }
}
