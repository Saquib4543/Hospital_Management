import 'package:flutter/material.dart';

enum UserRole { admin, employee }

class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final UserRole role;
  final String employeeId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.employeeId,
  });
}
