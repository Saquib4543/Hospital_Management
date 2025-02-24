import 'package:flutter/material.dart';
import 'DashboardPage.dart';
import 'Employee/EmployeeDashboard.dart';
import 'main.dart';

// Define dummy users
final List<User> dummyUsers = [
  User(
    id: "1",
    name: "Admin User",
    email: "admin@gmail.com",
    department: "Management",
    role: UserRole.admin,
    employeeId: "ADM001",
  ),
  User(
    id: "2",
    name: "Employee User",
    email: "employee@gmail.com",
    department: "IT",
    role: UserRole.employee,
    employeeId: "EMP001",
  ),
];

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Dummy authentication logic
    if (username == "admin" && password == "admin123") {
      _navigateToDashboard(dummyUsers[0]);
    } else if (username == "employee" && password == "emp123") {
      _navigateToDashboard(dummyUsers[1]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  void _navigateToDashboard(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user.role == UserRole.admin
            ? DashboardPage()
            : EmployeeDashboard(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              margin: EdgeInsets.all(32),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory, size: 64, color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        "Inventory Manager",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 32),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                        obscureText: _isObscure,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _handleLogin();
                            }
                          },
                          child: Text("Login", style: TextStyle(fontSize: 16)),
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
    );
  }
}
