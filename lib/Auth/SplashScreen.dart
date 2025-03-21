// lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AuthService.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _authService = AuthService.to;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to complete
    await Future.delayed(Duration(milliseconds: 2000));

    // Check if user is already logged in
    if (_authService.isLoggedIn) {
      final user = _authService.currentUser.value;

      if (user?.isAdmin == true) {
        Get.offAllNamed('/admin-dashboard');
      } else {
        Get.offAllNamed('/employee-dashboard');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Color(0xFF1E1E2C), Color(0xFF2D2D44)]
                : [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.inventory_2_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "Inventory Manager",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}