// lib/routes/app_routes.dart
import 'package:get/get.dart';

import '../DashboardPage.dart';
import '../Employee/EmployeeDashboard.dart';
import '../LoginPage.dart';
import 'AuthMiddleware.dart';
import 'AuthService.dart';
import 'SplashScreen.dart';


class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => SplashScreen(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginPage(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: '/admin-dashboard',
      page: () => DashboardPage(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: '/employee-dashboard',
      page: () => MedicalDashboard(user: Get.find<AuthService>().currentUser.value!),
      middlewares: [EmployeeMiddleware()],
    ),
  ];
}