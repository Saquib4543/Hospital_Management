import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Auth/Approutes.dart';
import 'Auth/AuthService.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  // Initialize AuthService before starting the app
  await Get.putAsync(() => AuthService().init());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inventory Management',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }

  // Light Theme
  ThemeData _lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Color(0xFF3B7AF5),
      colorScheme: ColorScheme.light(
        primary: Color(0xFF3B7AF5),
        secondary: Color(0xFF1E4EC7),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF3B7AF5),
        elevation: 0,
      ),
    );
  }

  // Dark Theme
  ThemeData _darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Color(0xFF3B7AF5),
      scaffoldBackgroundColor: Color(0xFF1E1E2C),
      cardColor: Color(0xFF21213A),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF3B7AF5),
        secondary: Color(0xFF1E4EC7),
        surface: Color(0xFF21213A),
        background: Color(0xFF1E1E2C),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF21213A),
        elevation: 0,
      ),
    );
  }
}

// Extension to initialize AuthService
extension AuthServiceExtension on AuthService {
  Future<AuthService> init() async {
    await checkAuthStatus();
    return this;
  }
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
