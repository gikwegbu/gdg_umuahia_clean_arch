/// UserModel holds public profile details for authenticated user sessions.
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  /// Constructs a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  /// Exports the [UserModel] instance as a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
    };
  }

  /// Helper to get the full name of the user.
  String get fullName => '$firstName $lastName';
}
