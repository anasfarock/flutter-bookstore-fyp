
class UserModel {
  final String id;
  final String email;
  final String role; // 'buyer' or 'seller'
  final String name;
  final String phoneNumber;
  final String description;
  final String profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.name = '',
    this.phoneNumber = '',
    this.description = '',
    this.profileImage = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'phoneNumber': phoneNumber,
      'description': description,
      'profileImage': profileImage,
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
      profileImage: map['profileImage'] ?? '',
    );
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? description,
    String? profileImage,
  }) {
    return UserModel(
      id: id,
      email: email,
      role: role,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
