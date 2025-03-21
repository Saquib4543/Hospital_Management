// lib/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AuthService.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // If the user is not logged in, redirect to login page
    if (!AuthService.to.isLoggedIn) {
      return RouteSettings(name: '/login');
    }
    return null;
  }
}

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in first
    if (!AuthService.to.isLoggedIn) {
      return RouteSettings(name: '/login');
    }

    // Then check if user is admin
    if (AuthService.to.currentUser.value?.isAdmin != true) {
      // If not admin, redirect to employee dashboard
      return RouteSettings(name: '/employee-dashboard');
    }

    return null;
  }
}

class EmployeeMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in first
    if (!AuthService.to.isLoggedIn) {
      return RouteSettings(name: '/login');
    }

    // Then check if user is employee
    if (AuthService.to.currentUser.value?.isEmployee != true) {
      // If not employee, redirect to admin dashboard
      return RouteSettings(name: '/admin-dashboard');
    }

    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // If the user is already logged in, redirect to appropriate dashboard
    if (AuthService.to.isLoggedIn) {
      final user = AuthService.to.currentUser.value;

      if (user?.isAdmin == true) {
        return RouteSettings(name: '/admin-dashboard');
      } else {
        return RouteSettings(name: '/employee-dashboard');
      }
    }
    return null;
  }
}