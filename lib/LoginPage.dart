// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'DashboardPage.dart';
// import 'Employee/EmployeeDashboard.dart';
// import 'Employee/MedicalDashboard Functions/user_provider.dart';
// import 'main.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as html;
//
// // Define dummy users
// // final List<User> dummyUsers = [
// //   User(
// //     id: "1",
// //     name: "Admin User",
// //     email: "admin@gmail.com",
// //     department: "Management",
// //     role: UserRole.admin,
// //     employeeId: "ADM001",
// //   ),
// //   User(
// //     id: "2",
// //     name: "Employee User",
// //     email: "employee@gmail.com",
// //     department: "IT",
// //     role: UserRole.employee,
// //     employeeId: "EMP001",
// //   ),
// // ];
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isObscure = true;
//   bool _isLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Interval(0.0, 0.8, curve: Curves.easeOut),
//       ),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleLogin() async {
//     String username = _usernameController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final response = await http.post(
//           Uri.parse("https://uat.goclaims.in/inventory_hub/mobile_auth_login"),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode({"username": username, "password": password}),
//         );
//
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//
//           if (data['status'] == 'success') {
//             String referenceId = data['reference_id'];
//
//             if (kIsWeb) {
//               // Store in localStorage for Web
//               html.window.localStorage['username'] = username;
//             } else {
//               // Store in SharedPreferences for Mobile
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               await prefs.setString('username', username);
//             }
//
//             // Store reference ID in Provider (works for both)
//             Provider.of<UserProvider>(context, listen: false).saveReferenceId(referenceId);
//
//             // Navigate to Dashboard
//             Navigator.pushReplacementNamed(context, '/dashboard');
//           } else {
//             _showErrorAnimation();
//           }
//         } else {
//           _showErrorAnimation();
//         }
//       } catch (e) {
//         print(e);
//         _showErrorAnimation();
//       }
//
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showErrorAnimation() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Text("Invalid username or password"),
//           ],
//         ),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: EdgeInsets.all(16),
//         elevation: 4,
//         duration: Duration(seconds: 3),
//       ),
//     );
//
//     HapticFeedback.mediumImpact();
//   }
//
//   void _navigateToDashboard(String username) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DashboardPage(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient Background with Pattern
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: isDarkMode
//                     ? [Color(0xFF1E1E2C), Color(0xFF2D2D44)]
//                     : [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
//               ),
//             ),
//             child: Opacity(
//               opacity: 0.05,
//               child: CustomPaint(
//                 painter: GridPatternPainter(),
//                 size: Size(size.width, size.height),
//               ),
//             ),
//           ),
//
//           // Content
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Logo & Header
//                           Container(
//                             padding: EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isDarkMode
//                                   ? Colors.indigo.withOpacity(0.2)
//                                   : Colors.white.withOpacity(0.15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.inventory_2_rounded,
//                               size: 70,
//                               color: isDarkMode ? Colors.white : Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Text(
//                             "Inventory Manager",
//                             style: TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "Log in to manage your inventory",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white.withOpacity(0.8),
//                             ),
//                           ),
//                           SizedBox(height: 48),
//
//                           // Login Card
//                           Container(
//                             constraints: BoxConstraints(maxWidth: 450),
//                             decoration: BoxDecoration(
//                               color: isDarkMode
//                                   ? Color(0xFF21213A)
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 20,
//                                   spreadRadius: 2,
//                                   offset: Offset(0, 10),
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(32),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Sign In",
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: isDarkMode ? Colors.white : Colors.black87,
//                                     ),
//                                   ),
//                                   SizedBox(height: 24),
//
//                                   // Username Field
//                                   _buildInputField(
//                                     controller: _usernameController,
//                                     label: "Username",
//                                     hint: "Enter your username",
//                                     icon: Icons.person_outline_rounded,
//                                     //isDarkMode: isDarkMode,
//                                     validator: (value) {
//                                       if (value?.isEmpty ?? true) {
//                                         return 'Please enter your username';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: 24),
//
//                                   // Password Field
//                                   _buildInputField(
//                                     controller: _passwordController,
//                                     label: "Password",
//                                     hint: "Enter your password",
//                                     icon: Icons.lock_outline_rounded,
//                                     isPassword: true,
//                                     //isDarkMode: isDarkMode,
//                                     validator: (value) {
//                                       if (value?.isEmpty ?? true) {
//                                         return 'Please enter your password';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: 16),
//
//                                   // Forgot Password
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: () {},
//                                       child: Text(
//                                         "Forgot Password?",
//                                         style: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.blue[300]
//                                               : Colors.blue[700],
//                                         ),
//                                       ),
//                                       style: TextButton.styleFrom(
//                                         visualDensity: VisualDensity.compact,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 32),
//
//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: _isLoading ? null : _handleLogin,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: isDarkMode
//                                             ? Colors.blue[700]
//                                             : Colors.blue[600],
//                                         foregroundColor: Colors.white,
//                                         elevation: 3,
//                                         shadowColor: isDarkMode
//                                             ? Colors.blue.withOpacity(0.4)
//                                             : Colors.blue.withOpacity(0.3),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(16),
//                                         ),
//                                       ),
//                                       child: _isLoading
//                                           ? SizedBox(
//                                         width: 24,
//                                         height: 24,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       )
//                                           : Text(
//                                         "Sign In",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           letterSpacing: 0.5,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   SizedBox(height: 24),
//
//                                   // Footer
//                                   Center(
//                                     child: RichText(
//                                       text: TextSpan(
//                                         style: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.grey[400]
//                                               : Colors.grey[700],
//                                           fontSize: 14,
//                                         ),
//                                         children: [
//                                           TextSpan(text: "Admin login: "),
//                                           TextSpan(
//                                             text: "admin/admin123",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: isDarkMode
//                                                   ? Colors.blue[300]
//                                                   : Colors.blue[700],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Center(
//                                     child: RichText(
//                                       text: TextSpan(
//                                         style: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.grey[400]
//                                               : Colors.grey[700],
//                                           fontSize: 14,
//                                         ),
//                                         children: [
//                                           TextSpan(text: "Employee login: "),
//                                           TextSpan(
//                                             text: "employee/emp123",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: isDarkMode
//                                                   ? Colors.blue[300]
//                                                   : Colors.blue[700],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildInputField({
//   //   required TextEditingController controller,
//   //   required String label,
//   //   required String hint,
//   //   required IconData icon,
//   //   bool isPassword = false,
//   //   required bool isDarkMode,
//   //   String? Function(String?)? validator,
//   // }) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text(
//   //         label,
//   //         style: TextStyle(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w600,
//   //           color: isDarkMode ? Colors.white70 : Colors.black87,
//   //         ),
//   //       ),
//   //       SizedBox(height: 8),
//   //       Container(
//   //         decoration: BoxDecoration(
//   //           color: isDarkMode ? Color(0xFF2A2A45) : Colors.grey[100],
//   //           borderRadius: BorderRadius.circular(16),
//   //           border: Border.all(
//   //             color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
//   //             width: 1,
//   //           ),
//   //         ),
//   //         child: TextFormField(
//   //           controller: controller,
//   //           obscureText: isPassword ? _isObscure : false,
//   //           style: TextStyle(
//   //             color: isDarkMode ? Colors.white : Colors.black87,
//   //           ),
//   //           decoration: InputDecoration(
//   //             hintText: hint,
//   //             hintStyle: TextStyle(
//   //               color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
//   //             ),
//   //             prefixIcon: Icon(
//   //               icon,
//   //               color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
//   //             ),
//   //             suffixIcon: isPassword
//   //                 ? IconButton(
//   //               icon: Icon(
//   //                 _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//   //                 color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
//   //                 size: 20,
//   //               ),
//   //               onPressed: () => setState(() => _isObscure = !_isObscure),
//   //             )
//   //                 : null,
//   //             border: InputBorder.none,
//   //             contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//   //           ),
//   //           validator: validator,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     bool isPassword = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword ? _isObscure : false,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
//           onPressed: () => setState(() => _isObscure = !_isObscure),
//         )
//             : null,
//         border: OutlineInputBorder(),
//       ),
//       validator: validator,
//     );
//   }
// }
//
// // Custom Painter for Grid Pattern
// class GridPatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.15)
//       ..strokeWidth = 1;
//
//     final gridSize = 30.0;
//
//     // Draw horizontal lines
//     for (double i = 0; i <= size.height; i += gridSize) {
//       canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
//     }
//
//     // Draw vertical lines
//     for (double i = 0; i <= size.width; i += gridSize) {
//       canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
