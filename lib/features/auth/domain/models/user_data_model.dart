class UserDataModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String jti;

  UserDataModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.jti,
  });

  factory UserDataModel.fromJwtPayload(Map<String, dynamic> payload) {
    return UserDataModel(
      userId: (payload['UserID'] ?? payload['uid'] ?? '').toString(),
      name: (payload['Name'] ?? payload['name'] ?? '').toString(),
      email: (payload['Email'] ?? payload['email'] ?? '').toString(),
      role: (payload['Role'] ?? payload['role'] ?? '').toString().toLowerCase(),
      jti: (payload['jti'] ?? '').toString(),
    );
  }
}
