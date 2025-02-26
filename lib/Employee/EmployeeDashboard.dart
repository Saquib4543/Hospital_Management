import 'package:flutter/material.dart';

import '../LoginPage.dart';
import '../main.dart';
import 'dart:math';
import 'package:hospital_inventory_management/Employee/Pages/DropDown_Option.dart';

import 'Pages/Camera_In_Controller.dart';
import 'Pages/Camera_Out_Controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicalDashboard extends StatelessWidget {
  final User user;

  MedicalDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MediTrack Pro"),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () => _showProfile(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStaffHeader(),
              _buildEquipmentSummary(),
              _buildQuickActions(context),
              _buildActiveRequests(),
              _buildRecentActivities(),
              _buildCriticalInventory(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewMedicalRequestPage(user: user),
          ),
        ),
        backgroundColor: Color(0xFF2E7D32),
        child: Icon(Icons.add_circle_outline),
        tooltip: 'Request New Equipment',
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.name[0],
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.department,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard_outlined, "Dashboard"),
          _drawerItem(Icons.medical_services_outlined, "Equipment Catalog"),
          _drawerItem(Icons.history_outlined, "Request History"),
          _drawerItem(Icons.analytics_outlined, "Usage Analytics"),
          _drawerItem(Icons.support_outlined, "Support"),
          Divider(),
          _drawerItem(Icons.settings_outlined, "Settings"),
          _drawerItem(Icons.help_outline, "Help & FAQ"),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }

  Widget _buildStaffHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Dr. ${user.name.split(' ')[0]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${user.department} • Staff ID: ${user.employeeId}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Monday, February 24, 2025",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Equipment Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem(
                "Active",
                "7",
                Icons.medical_information,
                Color(0xFF2E7D32),
              ),
              _summaryItem(
                "Reserved",
                "2",
                Icons.hourglass_empty,
                Colors.orange,
              ),
              _summaryItem(
                "Overdue",
                "1",
                Icons.warning_amber,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  context,
                  "Request Equipment",
                  Icons.add_circle_outline,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewMedicalRequestPage(user: user),
                    ),
                  ),
                  Color(0xFF2E7D32),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _actionCard(
                  context,
                  "Return Equipment",
                  Icons.assignment_return_outlined,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReturnMedicalEquipmentPage(user: user),
                    ),
                  ),
                  Color(0xFF1565C0),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _actionCard(
                  context,
                  "Equipment Status",
                  Icons.report_problem_outlined,
                      () => Navigator.push(
                    context,
                    // The new EquipmentStatusPage:
                    MaterialPageRoute(
                      builder: (context) => EquipmentStatusPage(user: user),
                    ),
                  ),
                  Color(0xFFE53935),
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
      Color color,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Active Medical Equipment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _medicalEquipmentCard(
            "Portable Ultrasound",
            "Due: Tomorrow, 9:00 AM",
            RequestStatus.borrowed,
            "Operating Room 3",
          ),
          SizedBox(height: 10),
          _medicalEquipmentCard(
            "Infusion Pump",
            "Due: February 26, 2:00 PM",
            RequestStatus.borrowed,
            "ICU Room 202",
          ),
          SizedBox(height: 10),
          _medicalEquipmentCard(
            "Ventilator",
            "Requested: Today, 10:30 AM",
            RequestStatus.pending,
            "Emergency Department",
          ),
        ],
      ),
    );
  }

  Widget _medicalEquipmentCard(
      String item,
      String date,
      RequestStatus status,
      String location,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
          ),
        ),
        title: Row(
          children: [
            Text(
              item,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _getStatusColor(status).withOpacity(0.3),
                ),
              ),
              child: Text(
                _getStatusText(status),
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(date),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
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
        return Color(0xFF1565C0);
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
        return Icons.check_circle_outline;
      case RequestStatus.rejected:
        return Icons.cancel_outlined;
      case RequestStatus.borrowed:
        return Icons.medical_services_outlined;
      case RequestStatus.returned:
        return Icons.assignment_returned;
      case RequestStatus.overdue:
        return Icons.warning_amber_outlined;
    }
  }

  String _getStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return "RESERVED";
      case RequestStatus.approved:
        return "APPROVED";
      case RequestStatus.rejected:
        return "REJECTED";
      case RequestStatus.borrowed:
        return "IN USE";
      case RequestStatus.returned:
        return "RETURNED";
      case RequestStatus.overdue:
        return "OVERDUE";
      default:
        return status.toString().split('.').last.toUpperCase();
    }
  }

  Widget _buildRecentActivities() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _activityTimeline(),
        ],
      ),
    );
  }

  Widget _activityTimeline() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _timelineItem(
            "Patient Monitor returned",
            "Today, 11:32 AM",
            Icons.assignment_returned,
            Colors.green,
            isFirst: true,
          ),
          _timelineItem(
            "ECG Machine request approved",
            "Today, 9:15 AM",
            Icons.check_circle_outline,
            Colors.blue,
          ),
          _timelineItem(
            "Ventilator request submitted",
            "Today, 8:30 AM",
            Icons.add_circle_outline,
            Colors.orange,
          ),
          _timelineItem(
            "Defibrillator returned",
            "Yesterday, 4:45 PM",
            Icons.assignment_returned,
            Colors.green,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(String title, String time, IconData icon, Color color,
      {bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: Colors.grey.withOpacity(0.3),
              ),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: isLast ? 0 : 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalInventory() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Critical Inventory Alert",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Low Stock Alert",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "These items need attention",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _criticalItem("Infusion Pumps", "2 remaining", 20, 2),
                SizedBox(height: 10),
                _criticalItem("Pulse Oximeters", "3 remaining", 15, 3),
                SizedBox(height: 10),
                _criticalItem("Stethoscopes", "4 remaining", 25, 4),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Order Supplies"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _criticalItem(String name, String count, int total, int remaining) {
    double percentage = remaining / total;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            count,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: 100 * percentage,
                    decoration: BoxDecoration(
                      color: percentage < 0.3 ? Colors.red : Colors.orange,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Mark all as read",
                        style: TextStyle(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _notificationItem(
                        "Equipment Request Approved",
                        "Your request for Infusion Pump has been approved",
                        DateTime.now().subtract(Duration(hours: 1)),
                        isUnread: true,
                      ),
                      _notificationItem(
                        "Return Reminder",
                        "Portable Ultrasound is due tomorrow by 9:00 AM",
                        DateTime.now().subtract(Duration(hours: 3)),
                        isUnread: true,
                      ),
                      _notificationItem(
                        "New Equipment Available",
                        "10 new Pulse Oximeters have been added to inventory",
                        DateTime.now().subtract(Duration(days: 1)),
                      ),
                      _notificationItem(
                        "Equipment Maintenance",
                        "Scheduled maintenance for Ventilators on Feb 28",
                        DateTime.now().subtract(Duration(days: 2)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _notificationItem(String title, String message, DateTime time,
      {bool isUnread = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Color(0xFF2E7D32).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? Color(0xFF2E7D32).withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread ? Color(0xFF2E7D32) : Colors.transparent,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _formatTimeAgo(time),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                ),
              ),
              child: Center(
                child: Text(
                  user.name[0],
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF2E7D32).withOpacity(0.3),
                ),
              ),
              child: Text(
                user.department,
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _profileStatItem("Requests", "24"),
                  _profileStatItem("Active", "7"),
                  _profileStatItem("Returned", "17"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

enum RequestStatus {
  pending,
  approved,
  rejected,
  borrowed,
  returned,
  overdue,
}

// class NewMedicalRequestPage extends StatefulWidget {
//   final User user;
//
//   const NewMedicalRequestPage({Key? key, required this.user}) : super(key: key);
//
//   @override
//   _NewMedicalRequestPageState createState() => _NewMedicalRequestPageState();
// }
//
// class _NewMedicalRequestPageState extends State<NewMedicalRequestPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Date fields
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 2));
//
//   // Other form fields
//   String _purpose = '';
//   String _location = '';
//   bool _isUrgent = false;
//
//   // For scanning feedback (if you want to display the scanned barcode)
//   String? _scannedBarcode;
//
//   /// Equipment data handling (similar to TakeEquipmentPage):
//   final TextEditingController searchController = TextEditingController();
//
//   List<Map<String, dynamic>> equipmentList = [];
//   List<Map<String, dynamic>> displayedList = [];
//   List<Map<String, dynamic>> filteredList = [];
//   final Set<Map<String, dynamic>> selectedEquipments = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEquipment();
//   }
//
//   void _loadEquipment() {
//     final List<Map<String, dynamic>> allEquipment = [];
//
//     for (var item in DropDownOption.equipmentData) {
//       allEquipment.add(item);
//     }
//
//     setState(() {
//       equipmentList = allEquipment;
//       displayedList = _getRandomItems(equipmentList, 10);
//       filteredList = List.from(displayedList);
//     });
//   }
//
//   List<Map<String, dynamic>> _getRandomItems(
//       List<Map<String, dynamic>> list, int count) {
//     if (list.length <= count) return List.from(list);
//     list.shuffle(Random());
//     return list.sublist(0, count);
//   }
//
//   void _filterEquipment(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredList = List.from(displayedList);
//       } else {
//         filteredList = equipmentList
//             .where((item) {
//           final itemName = (item['name'] as String).toLowerCase();
//           return itemName.contains(query.toLowerCase());
//         })
//             .toList();
//       }
//     });
//   }
//
//   void _showEquipmentDialog(Map<String, dynamic> equipment) {
//     final status = (equipment['status'] ?? '').toString().toLowerCase();
//
//     final category = equipment['category'] ?? 'Unknown';
//     final name = equipment['name'] ?? 'Unknown';
//     final condition = equipment['condition'] ?? 'Unknown';
//     final description = equipment['description'] ?? 'No description';
//     final totalEquipments = equipment['total_equipments']?.toString() ?? '0';
//     final equipmentsAvailable = equipment['equipments_available']?.toString() ?? '0';
//
//     final bool isAvailable = status == 'available';
//
//     // Example placeholders for unavailable date range
//     final unavailableFrom = '2023-09-01';
//     final unavailableTo = '2023-09-10';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isAvailable ? 'Item is Available!' : 'Item is Unavailable!',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: isAvailable ? Colors.green[700] : Colors.red[700],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text('Category: $category'),
//                   Text('Name: $name'),
//                   Text('Status: ${equipment['status'] ?? 'Unknown'}'),
//                   Text('Condition: $condition'),
//                   Text('Description: $description'),
//                   Text('Total Equipments: $totalEquipments'),
//                   Text('Equipments Available: $equipmentsAvailable'),
//                   const SizedBox(height: 10),
//                   if (!isAvailable)
//                     Text(
//                       'Unavailable From: $unavailableFrom\n'
//                           'Unavailable To:   $unavailableTo',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   const SizedBox(height: 20),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('OK'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _toggleItemSelection(Map<String, dynamic> item, bool isSelected) {
//     final isUnavailable =
//         (item['status'] as String?)?.toLowerCase() == 'unavailable';
//     if (isUnavailable) return;
//
//     setState(() {
//       if (isSelected) {
//         selectedEquipments.add(item);
//       } else {
//         selectedEquipments.remove(item);
//       }
//     });
//   }
//
//   void _submitRequest() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Request submitted!")),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   Future<void> _pickDate(bool isStart) async {
//     final initialDate = isStart ? _startDate : _endDate;
//     final firstDate = isStart ? DateTime.now() : _startDate;
//     final lastDate = DateTime.now().add(const Duration(days: 30));
//
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//           if (_endDate.isBefore(_startDate)) {
//             _endDate = _startDate.add(const Duration(days: 2));
//           }
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedCount = selectedEquipments.length;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Request Medical Equipment"),
//         backgroundColor: const Color(0xFF2E7D32),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
//             stops: [0.0, 0.1],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 //----------------------------------------------------------------
//                 // 1) SCAN EQUIPMENT BUTTON (Add it ABOVE the "Select Equipment" card)
//                 //----------------------------------------------------------------
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text("Scan Equipment"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                     ),
//                     onPressed: () async {
//                       // Navigate to the CameraOutController
//                       final scannedResult = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CameraOutController(),
//                         ),
//                       );
//                       // If user scanned something and pressed Continue:
//                       if (scannedResult != null) {
//                         setState(() {
//                           _scannedBarcode = scannedResult.toString();
//                         });
//                         // Do whatever you wish with the scanned data.
//                         // For example, show a toast or fill into a field
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Scanned: $_scannedBarcode"),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 //----------------------------------------------------------------
//                 // 2) SELECT EQUIPMENT SECTION
//                 //----------------------------------------------------------------
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Select Equipment",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Search field
//                         TextField(
//                           controller: searchController,
//                           decoration: InputDecoration(
//                             hintText: "Search equipment...",
//                             prefixIcon: const Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onChanged: _filterEquipment,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Equipment list with checkboxes
//                         Container(
//                           height: 300, // scrollable
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: filteredList.isEmpty
//                               ? const Center(
//                             child: Text("No equipment available"),
//                           )
//                               : ListView.builder(
//                             itemCount: filteredList.length,
//                             itemBuilder: (context, index) {
//                               final item = filteredList[index];
//                               final name = item['name'] ?? '';
//                               final category = item['category'] ?? '';
//                               final status = item['status'] ?? '';
//                               final availableCount =
//                                   item['equipments_available'] ?? 0;
//
//                               final bool isUnavailable =
//                                   status.toLowerCase() == 'unavailable';
//                               final bool isChecked =
//                               selectedEquipments.contains(item);
//
//                               return ListTile(
//                                 onTap: () => _showEquipmentDialog(item),
//                                 title: Text(name),
//                                 subtitle: Text(
//                                   "Category: $category\n"
//                                       "Status: $status\n"
//                                       "Available: $availableCount",
//                                 ),
//                                 leading: const Icon(
//                                   Icons.precision_manufacturing,
//                                 ),
//                                 trailing: Checkbox(
//                                   value: isChecked,
//                                   onChanged: isUnavailable
//                                       ? null // disable if unavailable
//                                       : (bool? newValue) {
//                                     if (newValue == null) return;
//                                     _toggleItemSelection(
//                                         item, newValue);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//
//                         Text(
//                           selectedCount > 0
//                               ? "$selectedCount item(s) selected"
//                               : "No items selected",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 //----------------------------------------------------------------
//                 // 3) DATE & USAGE INFO SECTION
//                 //----------------------------------------------------------------
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Equipment Usage Details",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                   labelText: 'Start Date',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   prefixIcon:
//                                   const Icon(Icons.calendar_today),
//                                 ),
//                                 readOnly: true,
//                                 controller: TextEditingController(
//                                   text:
//                                   "${_startDate.day}/${_startDate.month}/${_startDate.year}",
//                                 ),
//                                 onTap: () => _pickDate(true),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                   labelText: 'End Date',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   prefixIcon:
//                                   const Icon(Icons.calendar_today),
//                                 ),
//                                 readOnly: true,
//                                 controller: TextEditingController(
//                                   text:
//                                   "${_endDate.day}/${_endDate.month}/${_endDate.year}",
//                                 ),
//                                 onTap: () => _pickDate(false),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Location',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             prefixIcon:
//                             const Icon(Icons.location_on_outlined),
//                           ),
//                           onChanged: (value) => _location = value,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter location';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Purpose',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             prefixIcon:
//                             const Icon(Icons.description_outlined),
//                           ),
//                           maxLines: 3,
//                           onChanged: (value) => _purpose = value,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a purpose';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         SwitchListTile(
//                           title: const Text(
//                             "Urgent Request",
//                             style: TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                           subtitle: const Text(
//                             "Mark if needed within 24 hours",
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           value: _isUrgent,
//                           activeColor: const Color(0xFF2E7D32),
//                           contentPadding: EdgeInsets.zero,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           onChanged: (bool value) {
//                             setState(() {
//                               _isUrgent = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 //----------------------------------------------------------------
//                 // 4) SUBMIT REQUEST BUTTON
//                 //----------------------------------------------------------------
//                 ElevatedButton(
//                   onPressed: _submitRequest,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2E7D32),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     minimumSize: const Size(double.infinity, 0),
//                   ),
//                   child: const Text(
//                     "Submit Request",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _NewMedicalRequestPageState extends State<NewMedicalRequestPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Date fields
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 2));
//
//   // Other form fields
//   String _purpose = '';
//   String _location = '';
//   bool _isUrgent = false;
//
//   // For scanning feedback
//   String? _scannedBarcode;
//
//   /// Equipment data
//   final TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> equipmentList = [];
//   List<Map<String, dynamic>> displayedList = [];
//   List<Map<String, dynamic>> filteredList = [];
//   final Set<Map<String, dynamic>> selectedEquipments = {};
//
//   /// NEW: to store the API data
//   List<Map<String, dynamic>> apiDevicesList = [];
//   bool isLoadingApi = false;
//   String? apiErrorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEquipment();
//     _fetchDevices(); // fetch from the given API
//   }
//
//   //---------------------------------------------------------------------------------
//   // 1) FETCH DEVICES FROM API
//   //---------------------------------------------------------------------------------
//   Future<void> _fetchDevices() async {
//     setState(() {
//       isLoadingApi = true;
//       apiErrorMessage = null;
//     });
//
//     try {
//       final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body);
//         // Convert each dynamic map to a Map<String, dynamic>
//         final List<Map<String, dynamic>> devices = jsonData
//             .map((item) => item as Map<String, dynamic>)
//             .toList();
//
//         setState(() {
//           apiDevicesList = devices;
//           isLoadingApi = false;
//         });
//       } else {
//         setState(() {
//           apiErrorMessage =
//           'Error: ${response.statusCode} while fetching devices.';
//           isLoadingApi = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         apiErrorMessage = 'Exception: $e';
//         isLoadingApi = false;
//       });
//     }
//   }
//
//   //---------------------------------------------------------------------------------
//   // 2) EXISTING LOGIC FOR LOADING EQUIPMENT (unchanged)
//   //---------------------------------------------------------------------------------
//   void _loadEquipment() {
//     final List<Map<String, dynamic>> allEquipment = [];
//
//     for (var item in DropDownOption.equipmentData) {
//       allEquipment.add(item);
//     }
//
//     setState(() {
//       equipmentList = allEquipment;
//       displayedList = _getRandomItems(equipmentList, 10);
//       filteredList = List.from(displayedList);
//     });
//   }
//
//   List<Map<String, dynamic>> _getRandomItems(
//       List<Map<String, dynamic>> list, int count) {
//     if (list.length <= count) return List.from(list);
//     list.shuffle(Random());
//     return list.sublist(0, count);
//   }
//
//   void _filterEquipment(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredList = List.from(displayedList);
//       } else {
//         filteredList = equipmentList
//             .where((item) {
//           final itemName = (item['name'] ?? '').toLowerCase();
//           return itemName.contains(query.toLowerCase());
//         })
//             .toList();
//       }
//     });
//   }
//
//   void _showEquipmentDialog(Map<String, dynamic> equipment) {
//     // ...
//   }
//
//   void _toggleItemSelection(Map<String, dynamic> item, bool isSelected) {
//     // ...
//   }
//
//   void _submitRequest() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Request submitted!")),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   Future<void> _pickDate(bool isStart) async {
//     // ...
//   }
//
//   //---------------------------------------------------------------------------------
//   // 3) BUILD UI
//   //---------------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     final selectedCount = selectedEquipments.length;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Request Medical Equipment"),
//         backgroundColor: const Color(0xFF2E7D32),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
//             stops: [0.0, 0.1],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//
//                 //----------------------------------------------------------------
//                 // (A) SCAN EQUIPMENT BUTTON (unchanged)
//                 //----------------------------------------------------------------
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text("Scan Equipment"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                     ),
//                     onPressed: () async {
//                       final scannedResult = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CameraOutController(),
//                         ),
//                       );
//                       if (scannedResult != null) {
//                         setState(() {
//                           _scannedBarcode = scannedResult.toString();
//                         });
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Scanned: $_scannedBarcode"),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 //----------------------------------------------------------------
//                 // (B) DEVICES AVAILABLE CARD (newly added)
//                 //----------------------------------------------------------------
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Devices available",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // 1) If loading, show a progress indicator
//                         if (isLoadingApi) ...[
//                           Center(child: CircularProgressIndicator()),
//                         ]
//
//                         // 2) If error, show message
//                         else if (apiErrorMessage != null) ...[
//                           Text(
//                             apiErrorMessage!,
//                             style: TextStyle(color: Colors.red),
//                           )
//                         ]
//
//                         // 3) Otherwise, show list of items from the API
//                         else ...[
//                             // If the list is empty and not loading, show 'No items'
//                             if (apiDevicesList.isEmpty)
//                               const Center(
//                                 child: Text("No devices found."),
//                               )
//                             else
//                             // Show a small scrollable widget if needed
//                               ListView.builder(
//                                 shrinkWrap: true, // so it fits within the card
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemCount: apiDevicesList.length,
//                                 itemBuilder: (context, index) {
//                                   final device = apiDevicesList[index];
//                                   // The keys from your JSON:
//                                   //   "active_flag", "batch_number", "category",
//                                   //   "item_id", "item_name", "manufacturer",
//                                   //   "price", "remaining_life", "uom_id", "usage"
//
//                                   final itemName =
//                                       device['item_name']?.toString() ?? 'Unknown';
//                                   final category =
//                                       device['category']?.toString() ?? 'N/A';
//                                   final manufacturer =
//                                       device['manufacturer']?.toString() ?? 'N/A';
//                                   final price =
//                                       device['price']?.toString() ?? 'N/A';
//                                   final usage =
//                                       device['usage']?.toString() ?? 'N/A';
//
//                                   return ListTile(
//                                     contentPadding:
//                                     const EdgeInsets.symmetric(vertical: 4),
//                                     leading: const Icon(
//                                       Icons.devices_other,
//                                       color: Color(0xFF2E7D32),
//                                     ),
//                                     title: Text(itemName,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         )),
//                                     subtitle: Text(
//                                       "Category: $category\n"
//                                           "Manufacturer: $manufacturer\n"
//                                           "Price: $price\n"
//                                           "Usage: $usage",
//                                     ),
//                                     // You can use trailing or other UI as needed
//                                   );
//                                 },
//                               ),
//                           ],
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 //----------------------------------------------------------------
//                 // (C) SELECT EQUIPMENT SECTION (existing code)
//                 //----------------------------------------------------------------
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Select Equipment",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Search field
//                         TextField(
//                           controller: searchController,
//                           decoration: InputDecoration(
//                             hintText: "Search equipment...",
//                             prefixIcon: const Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onChanged: _filterEquipment,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Equipment list with checkboxes
//                         Container(
//                           height: 300, // scrollable
//                           decoration: BoxDecoration(
//                             border:
//                             Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: filteredList.isEmpty
//                               ? const Center(
//                             child: Text("No equipment available"),
//                           )
//                               : ListView.builder(
//                             itemCount: filteredList.length,
//                             itemBuilder: (context, index) {
//                               final item = filteredList[index];
//                               final name = item['name'] ?? '';
//                               final category =
//                                   item['category'] ?? '';
//                               final status =
//                                   item['status'] ?? '';
//                               final availableCount =
//                                   item['equipments_available'] ?? 0;
//
//                               final bool isUnavailable =
//                                   status.toLowerCase() ==
//                                       'unavailable';
//                               final bool isChecked =
//                               selectedEquipments.contains(item);
//
//                               return ListTile(
//                                 onTap: () =>
//                                     _showEquipmentDialog(item),
//                                 title: Text(name),
//                                 subtitle: Text(
//                                   "Category: $category\n"
//                                       "Status: $status\n"
//                                       "Available: $availableCount",
//                                 ),
//                                 leading: const Icon(
//                                   Icons.precision_manufacturing,
//                                 ),
//                                 trailing: Checkbox(
//                                   value: isChecked,
//                                   onChanged: isUnavailable
//                                       ? null // disable if unavailable
//                                       : (bool? newValue) {
//                                     if (newValue == null)
//                                       return;
//                                     _toggleItemSelection(
//                                         item, newValue);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//
//                         Text(
//                           selectedCount > 0
//                               ? "$selectedCount item(s) selected"
//                               : "No items selected",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 //----------------------------------------------------------------
//                 // (D) DATE & USAGE INFO SECTION (existing code)
//                 //----------------------------------------------------------------
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Equipment Usage Details",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                   labelText: 'Start Date',
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(12),
//                                   ),
//                                   prefixIcon:
//                                   const Icon(Icons.calendar_today),
//                                 ),
//                                 readOnly: true,
//                                 controller: TextEditingController(
//                                   text:
//                                   "${_startDate.day}/${_startDate.month}/${_startDate.year}",
//                                 ),
//                                 onTap: () => _pickDate(true),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                   labelText: 'End Date',
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(12),
//                                   ),
//                                   prefixIcon:
//                                   const Icon(Icons.calendar_today),
//                                 ),
//                                 readOnly: true,
//                                 controller: TextEditingController(
//                                   text:
//                                   "${_endDate.day}/${_endDate.month}/${_endDate.year}",
//                                 ),
//                                 onTap: () => _pickDate(false),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Location',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             prefixIcon:
//                             const Icon(Icons.location_on_outlined),
//                           ),
//                           onChanged: (value) => _location = value,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter location';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Purpose',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             prefixIcon:
//                             const Icon(Icons.description_outlined),
//                           ),
//                           maxLines: 3,
//                           onChanged: (value) => _purpose = value,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a purpose';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         SwitchListTile(
//                           title: const Text(
//                             "Urgent Request",
//                             style:
//                             TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                           subtitle: const Text(
//                             "Mark if needed within 24 hours",
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           value: _isUrgent,
//                           activeColor: const Color(0xFF2E7D32),
//                           contentPadding: EdgeInsets.zero,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           onChanged: (bool value) {
//                             setState(() {
//                               _isUrgent = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 //----------------------------------------------------------------
//                 // (E) SUBMIT REQUEST BUTTON
//                 //----------------------------------------------------------------
//                 ElevatedButton(
//                   onPressed: _submitRequest,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2E7D32),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     minimumSize: const Size(double.infinity, 0),
//                   ),
//                   child: const Text(
//                     "Submit Request",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class NewMedicalRequestPage extends StatefulWidget {
  final User user;

  const NewMedicalRequestPage({Key? key, required this.user}) : super(key: key);

  @override
  _NewMedicalRequestPageState createState() => _NewMedicalRequestPageState();
}

class _NewMedicalRequestPageState extends State<NewMedicalRequestPage> {
  final _formKey = GlobalKey<FormState>();

  // Date fields
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));

  // Other form fields
  String _purpose = '';
  String _location = '';
  bool _isUrgent = false;

  // For scanning feedback
  String? _scannedBarcode;

  /// Equipment data
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> equipmentList = [];
  List<Map<String, dynamic>> displayedList = [];
  List<Map<String, dynamic>> filteredList = [];
  final Set<Map<String, dynamic>> selectedEquipments = {};

  /// NEW: to store the API data from itemdetails
  List<Map<String, dynamic>> apiDevicesList = [];
  bool isLoadingApi = false;
  String? apiErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
    _fetchDevices(); // fetch from the new API endpoint
  }

  //----------------------------------------------------------------------------
  // 1) FETCH DEVICES FROM THE NEW API (itemdetails)
  //----------------------------------------------------------------------------
  Future<void> _fetchDevices() async {
    setState(() {
      isLoadingApi = true;
      apiErrorMessage = null;
    });

    try {
      final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Convert each dynamic map to a Map<String, dynamic>
        final List<Map<String, dynamic>> devices = jsonData
            .map((item) => item as Map<String, dynamic>)
            .toList();

        setState(() {
          apiDevicesList = devices;
          isLoadingApi = false;
        });
      } else {
        setState(() {
          apiErrorMessage =
          'Error: ${response.statusCode} while fetching devices.';
          isLoadingApi = false;
        });
      }
    } catch (e) {
      setState(() {
        apiErrorMessage = 'Exception: $e';
        isLoadingApi = false;
      });
    }
  }

  //----------------------------------------------------------------------------
  // 2) EXISTING LOGIC FOR LOADING EQUIPMENT
  //----------------------------------------------------------------------------
  void _loadEquipment() {
    final List<Map<String, dynamic>> allEquipment = [];

    for (var item in DropDownOption.equipmentData) {
      allEquipment.add(item);
    }

    setState(() {
      equipmentList = allEquipment;
      displayedList = _getRandomItems(equipmentList, 10);
      filteredList = List.from(displayedList);
    });
  }

  List<Map<String, dynamic>> _getRandomItems(
      List<Map<String, dynamic>> list, int count) {
    if (list.length <= count) return List.from(list);
    list.shuffle(Random());
    return list.sublist(0, count);
  }

  void _filterEquipment(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(displayedList);
      } else {
        filteredList = equipmentList
            .where((item) {
          final itemName = (item['name'] ?? '').toLowerCase();
          return itemName.contains(query.toLowerCase());
        })
            .toList();
      }
    });
  }

  void _showEquipmentDialog(Map<String, dynamic> equipment) {
    // ...
  }

  void _toggleItemSelection(Map<String, dynamic> item, bool isSelected) {
    // ...
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request submitted!")),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate(bool isStart) async {
    // ...
  }

  //----------------------------------------------------------------------------
  // 3) BUILD UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final selectedCount = selectedEquipments.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Medical Equipment"),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.1],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //----------------------------------------------------------------
                // (A) SCAN EQUIPMENT BUTTON
                //----------------------------------------------------------------
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan Equipment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () async {
                      final scannedResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraOutController(),
                        ),
                      );
                      if (scannedResult != null) {
                        setState(() {
                          _scannedBarcode = scannedResult.toString();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Scanned: $_scannedBarcode"),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                //----------------------------------------------------------------
                // (B) DEVICES AVAILABLE CARD (using new itemdetails keys)
                //----------------------------------------------------------------
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Devices available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 1) If loading, show a progress indicator
                        if (isLoadingApi) ...[
                          Center(child: CircularProgressIndicator()),
                        ]

                        // 2) If error, show message
                        else if (apiErrorMessage != null) ...[
                          Text(
                            apiErrorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ]

                        // 3) Otherwise, show list of items from the API
                        else ...[
                            // If the list is empty and not loading, show 'No items'
                            if (apiDevicesList.isEmpty)
                              const Center(
                                child: Text("No devices found."),
                              )
                            else
                            // Display each item’s keys in a ListView
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: apiDevicesList.length,
                                itemBuilder: (context, index) {
                                  final device = apiDevicesList[index];

                                  // The new keys from the API
                                  // "active_flag", "description", "from_date",
                                  // "issuance_status", "item_id", "location_id",
                                  // "qr_id", "ref_id", "request_number", "to_date"
                                  final itemId =
                                      device['item_id']?.toString() ?? 'Unknown';
                                  final desc = device['description']?.toString() ?? '';
                                  final issuanceStatus =
                                      device['issuance_status']?.toString() ?? '';
                                  final refId =
                                      device['ref_id']?.toString() ?? '';
                                  final fromDate =
                                      device['from_date']?.toString() ?? '';
                                  final toDate =
                                      device['to_date']?.toString() ?? '';

                                  return ListTile(
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                    leading: const Icon(
                                      Icons.devices_other,
                                      color: Color(0xFF2E7D32),
                                    ),
                                    title: Text(
                                      desc.isNotEmpty ? desc : '(No description)',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Item ID: $itemId\n"
                                          "Issuance Status: $issuanceStatus\n"
                                          "Ref ID: $refId\n"
                                          "From: $fromDate\n"
                                          "To: $toDate",
                                    ),
                                  );
                                },
                              ),
                          ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                //----------------------------------------------------------------
                // (C) SELECT EQUIPMENT SECTION (existing code)
                //----------------------------------------------------------------
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Select Equipment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Search field
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search equipment...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: _filterEquipment,
                        ),
                        const SizedBox(height: 16),

                        // Equipment list with checkboxes
                        Container(
                          height: 300, // scrollable
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: filteredList.isEmpty
                              ? const Center(
                            child: Text("No equipment available"),
                          )
                              : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final name = item['name'] ?? '';
                              final category = item['category'] ?? '';
                              final status = item['status'] ?? '';
                              final availableCount =
                                  item['equipments_available'] ?? 0;

                              final bool isUnavailable =
                                  status.toLowerCase() ==
                                      'unavailable';
                              final bool isChecked =
                              selectedEquipments.contains(item);

                              return ListTile(
                                onTap: () =>
                                    _showEquipmentDialog(item),
                                title: Text(name),
                                subtitle: Text(
                                  "Category: $category\n"
                                      "Status: $status\n"
                                      "Available: $availableCount",
                                ),
                                leading: const Icon(
                                  Icons.precision_manufacturing,
                                ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: isUnavailable
                                      ? null // disable if unavailable
                                      : (bool? newValue) {
                                    if (newValue == null)
                                      return;
                                    _toggleItemSelection(
                                        item, newValue);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          selectedCount > 0
                              ? "$selectedCount item(s) selected"
                              : "No items selected",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                //----------------------------------------------------------------
                // (D) DATE & USAGE INFO SECTION (existing code)
                //----------------------------------------------------------------
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Equipment Usage Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                  const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text:
                                  "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                                ),
                                onTap: () => _pickDate(true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                  const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text:
                                  "${_endDate.day}/${_endDate.month}/${_endDate.year}",
                                ),
                                onTap: () => _pickDate(false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon:
                            const Icon(Icons.location_on_outlined),
                          ),
                          onChanged: (value) => _location = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Purpose',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon:
                            const Icon(Icons.description_outlined),
                          ),
                          maxLines: 3,
                          onChanged: (value) => _purpose = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a purpose';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        SwitchListTile(
                          title: const Text(
                            "Urgent Request",
                            style:
                            TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text(
                            "Mark if needed within 24 hours",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _isUrgent,
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (bool value) {
                            setState(() {
                              _isUrgent = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                //----------------------------------------------------------------
                // (E) SUBMIT REQUEST BUTTON
                //----------------------------------------------------------------
                ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(fontSize: 16),
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

// class EquipmentStatusPage extends StatefulWidget {
//   final User user;
//
//   const EquipmentStatusPage({Key? key, required this.user}) : super(key: key);
//
//   @override
//   State<EquipmentStatusPage> createState() => _EquipmentStatusPageState();
// }
//
// class _EquipmentStatusPageState extends State<EquipmentStatusPage> {
//   final TextEditingController searchController = TextEditingController();
//
//   /// We'll store the entire item map here for easy search & display.
//   List<Map<String, dynamic>> equipmentList = [];
//   List<Map<String, dynamic>> displayedList = [];
//   List<Map<String, dynamic>> filteredList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEquipment();
//   }
//
//   /// Load all equipment from DropDownOption, then pick up to 10 random items
//   /// for the "Recently Added" list.
//   void _loadEquipment() {
//     final List<Map<String, dynamic>> allEquipment = [];
//
//     for (var item in DropDownOption.equipmentData) {
//       allEquipment.add(item);
//     }
//
//     setState(() {
//       equipmentList = allEquipment;
//       displayedList = _getRandomItems(equipmentList, 10);
//       filteredList = List.from(displayedList);
//     });
//   }
//
//   /// Picks up to [count] random items from the list for "Recently Added" display.
//   List<Map<String, dynamic>> _getRandomItems(
//       List<Map<String, dynamic>> list, int count) {
//     if (list.length <= count) return List.from(list);
//     list.shuffle(Random());
//     return list.sublist(0, count);
//   }
//
//   /// Search by the 'name' field in each item.
//   void _filterEquipment(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredList = List.from(displayedList);
//       } else {
//         filteredList = equipmentList
//             .where((item) {
//           final itemName = (item['name'] ?? '').toLowerCase();
//           return itemName.contains(query.toLowerCase());
//         })
//             .toList();
//       }
//     });
//   }
//
//   /// Show a dialog with more details about the tapped equipment.
//   void _showEquipmentDialog(Map<String, dynamic> equipment) {
//     final status = (equipment['status'] ?? '').toString().toLowerCase();
//
//     // Common fields
//     final category = equipment['category'] ?? 'Unknown';
//     final name = equipment['name'] ?? 'Unknown';
//     final condition = equipment['condition'] ?? 'Unknown';
//     final description = equipment['description'] ?? 'No description';
//     final totalEquipments = (equipment['total_equipments'] ?? 0).toString();
//     final equipmentsAvailable = (equipment['equipments_available'] ?? 0).toString();
//
//     final bool isAvailable = status == 'available';
//
//     // Example date range placeholders if unavailable
//     final unavailableFrom = '2023-09-01';
//     final unavailableTo = '2023-09-10';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // Wrap content
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isAvailable ? 'Item is Available!' : 'Item is Unavailable!',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: isAvailable ? Colors.green[700] : Colors.red[700],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text('Category: $category'),
//                   Text('Name: $name'),
//                   Text('Status: ${equipment['status'] ?? 'Unknown'}'),
//                   Text('Condition: $condition'),
//                   Text('Description: $description'),
//                   Text('Total Equipments: $totalEquipments'),
//                   Text('Equipments Available: $equipmentsAvailable'),
//                   const SizedBox(height: 10),
//                   if (!isAvailable)
//                     Text(
//                       'Unavailable From: $unavailableFrom\n'
//                           'Unavailable To:   $unavailableTo',
//                       style: TextStyle(color: Colors.red[600]),
//                     ),
//                   const SizedBox(height: 20),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('OK'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   /// Example logout logic (if needed)
//   void _logout() {
//     // You can replace this with your real logout code
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Logging out...")),
//     );
//     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Use the same color for the app bar as the rest of the app
//       appBar: AppBar(
//         title: const Text("Equipment Status"),
//         backgroundColor: const Color(0xFF2E7D32),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             // Go back to the previous route (e.g., your MedicalDashboard)
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Container(
//         // Same gradient background as in the MedicalDashboard
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
//             stops: [0.0, 0.1],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               /// Search field
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: "Search equipment...",
//                   prefixIcon: const Icon(Icons.search),
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onChanged: _filterEquipment,
//               ),
//               const SizedBox(height: 20),
//
//               /// Card showing "Recently Added Equipment" or filtered results
//               Expanded(
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Recently Added Equipment",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Divider(),
//                         Expanded(
//                           child: filteredList.isEmpty
//                               ? const Center(child: Text("No equipment available"))
//                               : ListView.builder(
//                             itemCount: filteredList.length,
//                             itemBuilder: (context, index) {
//                               final item = filteredList[index];
//                               final name = item['name'] ?? '';
//                               final category = item['category'] ?? '';
//                               final status = item['status'] ?? '';
//                               final availableCount =
//                                   item['equipments_available'] ?? 0;
//
//                               return ListTile(
//                                 onTap: () => _showEquipmentDialog(item),
//                                 title: Text(name),
//                                 subtitle: Text(
//                                   "Category: $category\n"
//                                       "Status: $status\n"
//                                       "Available: $availableCount",
//                                 ),
//                                 leading: const Icon(Icons.precision_manufacturing),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class EquipmentStatusPage extends StatefulWidget {
  final User user;

  const EquipmentStatusPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EquipmentStatusPage> createState() => _EquipmentStatusPageState();
}

class _EquipmentStatusPageState extends State<EquipmentStatusPage> {
  final TextEditingController searchController = TextEditingController();

  // The existing lists for "Recently Added Equipment"
  List<Map<String, dynamic>> equipmentList = [];
  List<Map<String, dynamic>> displayedList = [];
  List<Map<String, dynamic>> filteredList = [];

  // NEW: For the itemdetails API
  List<Map<String, dynamic>> statusApiDevicesList = [];
  bool statusIsLoadingApi = false;
  String? statusApiErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadEquipment();    // existing logic
    _fetchStatusApi();   // fetch data from the new API
  }

  //----------------------------------------------------------------------------
  // 1) FETCH DATA FROM https://uat.goclaims.in/inventory_hub/itemdetails
  //----------------------------------------------------------------------------
  Future<void> _fetchStatusApi() async {
    setState(() {
      statusIsLoadingApi = true;
      statusApiErrorMessage = null;
    });

    try {
      final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Map<String, dynamic>> devices = jsonData
            .map((item) => item as Map<String, dynamic>)
            .toList();

        setState(() {
          statusApiDevicesList = devices;
          statusIsLoadingApi = false;
        });
      } else {
        setState(() {
          statusApiErrorMessage =
          'Error: ${response.statusCode} while fetching status devices.';
          statusIsLoadingApi = false;
        });
      }
    } catch (e) {
      setState(() {
        statusApiErrorMessage = 'Exception: $e';
        statusIsLoadingApi = false;
      });
    }
  }

  //----------------------------------------------------------------------------
  // 2) EXISTING LOGIC FOR "Recently Added Equipment"
  //----------------------------------------------------------------------------
  void _loadEquipment() {
    final List<Map<String, dynamic>> allEquipment = [];
    for (var item in DropDownOption.equipmentData) {
      allEquipment.add(item);
    }

    setState(() {
      equipmentList = allEquipment;
      displayedList = _getRandomItems(equipmentList, 10);
      filteredList = List.from(displayedList);
    });
  }

  List<Map<String, dynamic>> _getRandomItems(
      List<Map<String, dynamic>> list, int count) {
    if (list.length <= count) return List.from(list);
    list.shuffle(Random());
    return list.sublist(0, count);
  }

  void _filterEquipment(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(displayedList);
      } else {
        filteredList = equipmentList
            .where((item) {
          final itemName = (item['name'] ?? '').toLowerCase();
          return itemName.contains(query.toLowerCase());
        })
            .toList();
      }
    });
  }

  void _showEquipmentDialog(Map<String, dynamic> equipment) {
    // existing code to show equipment details
    final status = (equipment['status'] ?? '').toString().toLowerCase();
    final category = equipment['category'] ?? 'Unknown';
    final name = equipment['name'] ?? 'Unknown';
    final condition = equipment['condition'] ?? 'Unknown';
    final description = equipment['description'] ?? 'No description';
    final totalEquipments = (equipment['total_equipments'] ?? 0).toString();
    final equipmentsAvailable = (equipment['equipments_available'] ?? 0).toString();
    final bool isAvailable = status == 'available';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable
                        ? 'Item is Available!'
                        : 'Item is Unavailable!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Category: $category'),
                  Text('Name: $name'),
                  Text('Status: ${equipment['status'] ?? 'Unknown'}'),
                  Text('Condition: $condition'),
                  Text('Description: $description'),
                  Text('Total Equipments: $totalEquipments'),
                  Text('Equipments Available: $equipmentsAvailable'),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logging out...")),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  //----------------------------------------------------------------------------
  // 3) BUILD UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Status"),
        backgroundColor: const Color(0xFF2E7D32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        // same gradient as in your MedicalDashboard
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //----------------------------------------------------------------
              // (A) NEW BACKGROUND CARD (API DATA) ABOVE THE SEARCH BAR
              //----------------------------------------------------------------
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Equipment from API",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 1) If loading, show indicator
                      if (statusIsLoadingApi) ...[
                        Center(child: CircularProgressIndicator()),
                      ]
                      // 2) If there's an error, show it
                      else if (statusApiErrorMessage != null) ...[
                        Text(
                          statusApiErrorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                      // 3) Otherwise, show the list
                      else ...[
                          if (statusApiDevicesList.isEmpty)
                            const Center(child: Text("No devices found."))
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: statusApiDevicesList.length,
                              itemBuilder: (context, index) {
                                final device = statusApiDevicesList[index];

                                // The itemdetails keys:
                                // "active_flag", "description", "from_date",
                                // "issuance_status", "item_id", "location_id",
                                // "qr_id", "ref_id", "request_number", "to_date"

                                final itemId =
                                    device['item_id']?.toString() ?? 'Unknown';
                                final desc = device['description']?.toString() ?? '';
                                final issuanceStatus =
                                    device['issuance_status']?.toString() ?? '';
                                final fromDate =
                                    device['from_date']?.toString() ?? '';
                                final toDate =
                                    device['to_date']?.toString() ?? '';
                                final refId =
                                    device['ref_id']?.toString() ?? '';

                                return ListTile(
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                                  leading: const Icon(
                                    Icons.devices_other,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  title: Text(
                                    desc.isNotEmpty ? desc : '(No description)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Item ID: $itemId\n"
                                        "Issuance: $issuanceStatus\n"
                                        "Ref ID: $refId\n"
                                        "From: $fromDate\n"
                                        "To: $toDate",
                                  ),
                                );
                              },
                            ),
                        ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------------
              // (B) SEARCH BAR
              //----------------------------------------------------------------
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search equipment...",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _filterEquipment,
              ),

              const SizedBox(height: 20),

              //----------------------------------------------------------------
              // (C) RECENTLY ADDED EQUIPMENT LIST
              //----------------------------------------------------------------
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recently Added Equipment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: filteredList.isEmpty
                              ? const Center(child: Text("No equipment available"))
                              : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final name = item['name'] ?? '';
                              final category = item['category'] ?? '';
                              final status = item['status'] ?? '';
                              final availableCount =
                                  item['equipments_available'] ?? 0;

                              return ListTile(
                                onTap: () => _showEquipmentDialog(item),
                                title: Text(name),
                                subtitle: Text(
                                  "Category: $category\n"
                                      "Status: $status\n"
                                      "Available: $availableCount",
                                ),
                                leading: const Icon(
                                  Icons.precision_manufacturing,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReturnMedicalEquipmentPage extends StatefulWidget {
  final User user;

  ReturnMedicalEquipmentPage({required this.user});

  @override
  _ReturnMedicalEquipmentPageState createState() =>
      _ReturnMedicalEquipmentPageState();
}

class _ReturnMedicalEquipmentPageState
    extends State<ReturnMedicalEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEquipment;
  String _condition = 'Excellent';
  String _notes = '';
  bool _needsMaintenance = false;

  // OPTIONAL: to store the scanned barcode
  String? _scannedBarcodeData;

  List<Map<String, dynamic>> _borrowedEquipment = [
    {
      'id': '001',
      'name': 'Portable Ultrasound',
      'dueDate': 'Tomorrow, 9:00 AM',
      'location': 'Operating Room 3',
    },
    {
      'id': '002',
      'name': 'Infusion Pump',
      'dueDate': 'February 26, 2:00 PM',
      'location': 'ICU Room 202',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Medical Equipment"),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.1],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //-------------------------------------------------
                  // 1) SCAN EQUIPMENT BUTTON (MOVED ABOVE SELECTION)
                  //-------------------------------------------------
                  ElevatedButton.icon(
                    onPressed: () async {
                      final scannedResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraInController(),
                        ),
                      );
                      if (scannedResult != null) {
                        setState(() {
                          _scannedBarcodeData = scannedResult.toString();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Scanned: $_scannedBarcodeData",
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text("Scan Equipment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),

                  SizedBox(height: 16),

                  //-------------------------------------------------
                  // 2) SELECT EQUIPMENT TO RETURN CARD
                  //-------------------------------------------------
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Equipment to Return",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          SizedBox(height: 16),
                          ..._borrowedEquipment.map(
                                (equipment) =>
                                _buildEquipmentSelectionCard(equipment),
                          ).toList(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  //-------------------------------------------------
                  // 3) RETURN DETAILS CARD
                  //    Only visible if user selected equipment
                  //-------------------------------------------------
                  if (_selectedEquipment != null) ...[
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Return Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Equipment Condition
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Equipment Condition',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon:
                                Icon(Icons.health_and_safety_outlined),
                              ),
                              value: _condition,
                              items: ['Excellent', 'Good', 'Fair', 'Poor']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _condition = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 16),

                            // Notes / Issues
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Notes / Issues',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.note_alt_outlined),
                              ),
                              maxLines: 3,
                              onChanged: (value) {
                                _notes = value;
                              },
                            ),
                            SizedBox(height: 16),

                            // Needs Maintenance switch
                            SwitchListTile(
                              title: Text(
                                "Needs Maintenance",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "Mark if equipment requires service",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: _needsMaintenance,
                              activeColor: Color(0xFF2E7D32),
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onChanged: (bool value) {
                                setState(() {
                                  _needsMaintenance = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    //-------------------------------------------------
                    // 4) CONFIRM RETURN BUTTON
                    //-------------------------------------------------
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Submit form
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Confirm Return",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This builds each borrowed equipment item (radio selection).
  Widget _buildEquipmentSelectionCard(Map<String, dynamic> equipment) {
    bool isSelected = _selectedEquipment == equipment['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEquipment = equipment['id'];
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            isSelected ? Color(0xFF2E7D32) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: equipment['id'],
              groupValue: _selectedEquipment,
              onChanged: (value) {
                setState(() {
                  _selectedEquipment = value as String;
                });
              },
              activeColor: Color(0xFF2E7D32),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Due: ${equipment['dueDate']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        equipment['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.medical_services_outlined,
              color: Color(0xFF2E7D32),
            ),
          ],
        ),
      ),
    );
  }
}
