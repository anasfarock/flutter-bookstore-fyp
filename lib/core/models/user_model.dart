
class UserModel {
  final String id;
  final String email;
  final String role; // 'buyer' or 'seller'
  final String name;
  final String phoneNumber;
  final String description;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.name = '',
    this.phoneNumber = '',
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'phoneNumber': phoneNumber,
      'description': description,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'buyer',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      description: map['description'] ?? '',
    );
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? description,
  }) {
    return UserModel(
      id: id,
      email: email,
      role: role,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
    );
  }
}
