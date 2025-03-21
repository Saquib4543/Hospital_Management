// lib/models/user_model.dart
class User {
  final String? id;
  final String? refId;
  final String? name;
  final String? role;
  final String? lastLoggedIn;
  final bool? isLoggedIn;

  User({
    this.id,
    this.refId,
    this.name,
    this.role,
    this.lastLoggedIn,
    this.isLoggedIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      refId: json['ref_id'],
      name: json['user_name'],
      role: json['user_role'],
      lastLoggedIn: json['last_logged_in'],
      isLoggedIn: json['is_logged_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref_id': refId,
      'user_name': name,
      'user_role': role,
      'last_logged_in': lastLoggedIn,
      'is_logged_in': isLoggedIn,
    };
  }

  bool get isAdmin => role?.toLowerCase() == 'hospital_admin';
  bool get isEmployee => role?.toLowerCase() == 'hospital_employee';
}