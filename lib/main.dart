import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your pages
import 'package:hospital_inventory_management/LoginPage.dart';
import 'package:hospital_inventory_management/Employee/EmployeeDashboard.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/user_provider.dart';
import 'DashboardPage.dart';
import 'Employee/EmployeeDashboard.dart';
import 'ItemDetailsPage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//
//   // Initialize SharedPreferences and UserProvider
//   final prefs = await SharedPreferences.getInstance();
//   final String? username = prefs.getString('username');
//   final String? role = prefs.getString('role');
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<UserProvider>(
//           create: (_) {
//             UserProvider userProvider = UserProvider();
//             userProvider.loadUsername();
//             return userProvider;
//           },
//         ),
//       ],
//       child: MyApp(initialRoute: _getInitialRoute(username, role)),
//     ),
//   );
// }
//
// /// Determines the initial screen based on user login status
// String _getInitialRoute(String? username, String? role) {
//   if (username != null && role != null) {
//     return role.toLowerCase() == 'admin' ? '/dashboard' : '/medical_dashboard';
//   } else {
//     return '/login';
//   }
// }
//
// class MyApp extends StatelessWidget {
//   final String initialRoute;
//
//   const MyApp({Key? key, required this.initialRoute}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//       ),
//       initialRoute: initialRoute,
//       routes: {
//         '/login': (context) => LoginPage(),
//         '/dashboard': (context) => DashboardPage(),
//         '/medical_dashboard': (context) {
//           final userProvider = Provider.of<UserProvider>(context, listen: false);
//           return MedicalDashboard(user: userProvider.username ?? 'User');
//         },
//       },
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Initialize SharedPreferences and UserProvider
  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
  final String? role = prefs.getString('role');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) {
            UserProvider userProvider = UserProvider();
            userProvider.loadUsername(); // Ensure username is loaded
            return userProvider;
          },
        ),
      ],
      child: MyApp(initialRoute: _getInitialRoute(username, role)),
    ),
  );
}

/// Determines the initial screen based on user login status
String _getInitialRoute(String? username, String? role) {
  if (username != null && role != null) {
    return role.toLowerCase() == 'admin' ? '/dashboard' : '/medical_dashboard';
  } else {
    //return '/login';
    return '/medical_dashboard';
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        //'/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/medical_dashboard': (context) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          return MedicalDashboard(username: userProvider.username ?? 'User');
        },
      },
    );
  }
}

/// Default user object (used if provider doesn't have a user loaded yet)
User defaultUser = User(
  id: '0',
  name: 'Unknown',
  email: 'unknown@example.com',
  department: 'Unknown',
  role: UserRole.employee,
  employeeId: 'EMP000',
);

// --------------------
//     DATA MODELS
// --------------------
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

enum RequestStatus {
  pending,
  approved,
  rejected,
  borrowed,
  returned,
  overdue,
}

enum UserRole {
  admin,
  employee,
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
