import 'package:flutter/material.dart';

import '../LoginPage.dart';
import '../main.dart';
import 'NewRequestPage.dart';
import 'ReturnEquipmentPage.dart';


class EmployeeDashboard extends StatelessWidget {
  final User user;

  EmployeeDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipment Portal"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _showProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            _buildActiveRequests(),
            _buildQuickActions(context),
            _buildRecentHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, ${user.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Employee ID: ${user.employeeId}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  context,
                  "Request Equipment",
                  Icons.add_shopping_cart,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRequestPage(user: user),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _actionCard(
                  context,
                  "Return Equipment",
                  Icons.assignment_return,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReturnEquipmentPage(user: user),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveRequests() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Active Requests",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _requestCard(
            "Laptop",
            "Due: Tomorrow",
            RequestStatus.borrowed,
          ),
          SizedBox(height: 8),
          _requestCard(
            "Projector",
            "Requested: Today",
            RequestStatus.pending,
          ),
        ],
      ),
    );
  }

  Widget _requestCard(String item, String date, RequestStatus status) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(status).withOpacity(0.2),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
          ),
        ),
        title: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(date),
        trailing: Chip(
          label: Text(
            _getStatusText(status),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.borrowed:
        return Colors.blue;
      case RequestStatus.returned:
        return Colors.grey;
      case RequestStatus.overdue:
        return Colors.deepPurple;
    }
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.hourglass_empty;
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.borrowed:
        return Icons.inventory;
      case RequestStatus.returned:
        return Icons.assignment_returned;
      case RequestStatus.overdue:
        return Icons.warning;
    }
  }

  String _getStatusText(RequestStatus status) {
    return status.toString().split('.').last.toUpperCase();
  }

  Widget _buildRecentHistory() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent History",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _historyCard(
            "Monitor",
            "Returned on 20th Feb",
            RequestStatus.returned,
          ),
          SizedBox(height: 8),
          _historyCard(
            "Headphones",
            "Request rejected on 15th Feb",
            RequestStatus.rejected,
          ),
        ],
      ),
    );
  }

  Widget _historyCard(String item, String date, RequestStatus status) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(date),
        trailing: Icon(
          _getStatusIcon(status),
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Text(
                user.name[0],
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Department: ${user.department}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
