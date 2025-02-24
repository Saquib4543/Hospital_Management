import 'package:flutter/material.dart';
import 'package:hospital_inventory_management/LoginPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import 'DashboardPage.dart';
import 'Employee/EmployeeDashboard.dart';
import 'ItemDetailsPage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    ),
  home: LoginPage(
  ),
  ));
}

// Data Models
class Item {
  final String id;
  final String name;
  final String description;
  final String manufacturerId;
  final int quantity;
  final String location;
  final DateTime lastUpdated;

  Item({
    required this.id,
    required this.name,
     this.description = '',
    required this.manufacturerId,
    required this.quantity,
    required this.location,
    required this.lastUpdated,
  });
}







// Additional Data Models
enum RequestStatus {
  pending,
  approved,
  rejected,
  borrowed,
  returned,
  overdue
}

enum UserRole {
  admin,
  employee
}

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

class EquipmentRequest {
  final String id;
  final String userId;
  final String itemId;
  final DateTime requestDate;
  final DateTime expectedReturnDate;
  final DateTime? actualReturnDate;
  final String purpose;
  final RequestStatus status;
  final String? approverNote;

  EquipmentRequest({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.requestDate,
    required this.expectedReturnDate,
    required this.purpose,
    required this.status,
    this.actualReturnDate,
    this.approverNote,
  });
}


// Add this to the login page to handle role-based navigation
void _handleLogin(BuildContext context, UserRole role) {
  if (role == UserRole.admin) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
    );
  } else {
    final user = User(
      id: "1",
      name: "John Doe",
      email: "john@example.com",
      department: "IT",
      role: UserRole.employee,
      employeeId: "EMP001",
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MedicalDashboard(user: user)),
    );
  }
}