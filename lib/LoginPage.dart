// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Auth/AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _authService = AuthService.to;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      final success = await _authService.login(username, password);

      if (success) {
        // Navigate based on user role
        final user = _authService.currentUser.value;

        if (user?.isAdmin == true) {
          Get.offAllNamed('/admin-dashboard');
        } else {
          Get.offAllNamed('/employee-dashboard');
        }
      } else {
        _showErrorAnimation();
      }
    }
  }

  void _showErrorAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(_authService.errorMessage.value.isEmpty
                ? "Invalid username or password"
                : _authService.errorMessage.value),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        elevation: 4,
        duration: Duration(seconds: 3),
      ),
    );

    // Shake animation for text fields
    HapticFeedback.mediumImpact();
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background with Pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Color(0xFF1E1E2C), Color(0xFF2D2D44)]
                    : [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: GridPatternPainter(),
                size: Size(size.width, size.height),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo & Header
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode
                                  ? Colors.indigo.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.inventory_2_rounded,
                              size: 70,
                              color: isDarkMode ? Colors.white : Colors.white,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Inventory Manager",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Log in to manage your inventory",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 48),

                          // Login Card
                          Container(
                            constraints: BoxConstraints(maxWidth: 450),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Color(0xFF21213A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 24),

                                  // Username Field
                                  _buildInputField(
                                    controller: _usernameController,
                                    label: "Username",
                                    hint: "Enter your username",
                                    icon: Icons.person_outline_rounded,
                                    isDarkMode: isDarkMode,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24),

                                  // Password Field
                                  _buildInputField(
                                    controller: _passwordController,
                                    label: "Password",
                                    hint: "Enter your password",
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    isDarkMode: isDarkMode,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),

                                  // Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32),

                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: Obx(() => ElevatedButton(
                                      onPressed: _authService.isLoading.value ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkMode
                                            ? Colors.blue[700]
                                            : Colors.blue[600],
                                        foregroundColor: Colors.white,
                                        elevation: 3,
                                        shadowColor: isDarkMode
                                            ? Colors.blue.withOpacity(0.4)
                                            : Colors.blue.withOpacity(0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: _authService.isLoading.value
                                          ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                          : Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required bool isDarkMode,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2A2A45) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _isObscure : false,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
              prefixIcon: Icon(
                icon,
                color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  size: 20,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Grid Pattern
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    final gridSize = 30.0;

    // Draw horizontal lines
    for (double i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw vertical lines
    for (double i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}