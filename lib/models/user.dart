
class AppUser {
  final String userId;
  final String userName;
  final String email;
  final DateTime createdAt;

  AppUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['user_id'],
      userName: json['user_name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
