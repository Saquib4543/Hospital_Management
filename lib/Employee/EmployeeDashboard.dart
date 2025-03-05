import 'package:flutter/material.dart';

import '../LoginPage.dart';
import '../main.dart';


class MedicalDashboard extends StatelessWidget {
  final User user;

  MedicalDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MediTrack Pro"),
        backgroundColor: Color(0xFF2E7D32), // Medical green
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
              // _buildCriticalInventory(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalEquipmentSelectionPage(),
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
                "Pending",
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
                      builder: (context) => MedicalEquipmentSelectionPage(),
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
                  "Report Issue",
                  Icons.report_problem_outlined,
                      () {},
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

  Widget _medicalEquipmentCard(String item, String date, RequestStatus status, String location) {
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
        return "PENDING";
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

  // Widget _buildCriticalInventory() {
  //   return Padding(
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Critical Inventory Alert",
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         Container(
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(
  //               color: Colors.red.withOpacity(0.3),
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.1),
  //                 blurRadius: 5,
  //                 offset: Offset(0, 2),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.red.withOpacity(0.1),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Icon(
  //                       Icons.warning_amber_rounded,
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //                   SizedBox(width: 12),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Low Stock Alert",
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.red,
  //                         ),
  //                       ),
  //                       Text(
  //                         "These items need attention",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.grey[600],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 16),
  //               _criticalItem("Infusion Pumps", "2 remaining", 20, 2),
  //               SizedBox(height: 10),
  //               _criticalItem("Pulse Oximeters", "3 remaining", 15, 3),
  //               SizedBox(height: 10),
  //               _criticalItem("Stethoscopes", "4 remaining", 25, 4),
  //               SizedBox(height: 16),
  //               ElevatedButton(
  //                 onPressed: () {},
  //                 child: Text("Order Supplies"),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Color(0xFF2E7D32),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                   minimumSize: Size(double.infinity, 0),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    ),child: Text(
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

// New Medical Equipment Request Page
class MedicalEquipmentSelectionPage extends StatefulWidget {
  @override
  _MedicalEquipmentSelectionPageState createState() => _MedicalEquipmentSelectionPageState();
}

class _MedicalEquipmentSelectionPageState extends State<MedicalEquipmentSelectionPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 2));
  String _purpose = '';
  String _location = '';
  bool _isUrgent = false;

  // Equipment categories for better organization
  final Map<String, List<String>> _equipmentCategories = {
    'Respiratory': ['Ventilator', 'Oxygen Concentrator', 'CPAP Machine'],
    'Monitoring': ['Patient Monitor', 'ECG Machine', 'Pulse Oximeter', 'Blood Pressure Monitor'],
    'Diagnostic': ['Portable Ultrasound', 'X-Ray Machine', 'CT Scanner'],
    'Surgical': ['Surgical Microscope', 'Anesthesia Machine', 'Defibrillator', 'Electrosurgical Unit'],
    'Infusion': ['Infusion Pump', 'Syringe Pump', 'Feeding Pump'],
  };

  // Map to track selected equipment (item name -> selected status)
  Map<String, bool> _selectedEquipment = {};

  // Initialize selected equipment map
  @override
  void initState() {
    super.initState();
    _equipmentCategories.forEach((category, items) {
      items.forEach((item) {
        _selectedEquipment[item] = false;
      });
    });
  }

  // Count of selected items
  int get _selectedCount => _selectedEquipment.values.where((selected) => selected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Equipment Request", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Color(0xFF0D47A1),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFFF5F5F5)],
            stops: [0.0, 0.15],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Progress indicator and summary
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      _buildProgressIndicator(),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$_selectedCount equipment selected",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            _isUrgent ? "Urgent Request" : "Standard Request",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        ),

                        // Equipment selection section
                        SliverToBoxAdapter(
                          child: _buildSectionHeader("Equipment Selection"),
                        ),

                        // Equipment categories
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              String category = _equipmentCategories.keys.elementAt(index);
                              return _buildEquipmentCategoryCard(category);
                            },
                            childCount: _equipmentCategories.length,
                          ),
                        ),

                        // Request details section
                        SliverToBoxAdapter(
                          child: _buildSectionHeader("Request Details"),
                        ),

                        SliverToBoxAdapter(
                          child: _buildRequestDetailsCard(),
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(height: 100), // Bottom padding
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
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedCount > 0) {
              _submitRequest();
            } else if (_selectedCount == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select at least one piece of equipment'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Text(
            "Submit Request",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(double.infinity, 0),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: _selectedCount > 0 ? 1.0 : 0.0,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 3,
        ),
        Text(
          _selectedCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _buildEquipmentCategoryCard(String category) {
    List<String> equipmentItems = _equipmentCategories[category]!;
    // Count selected items in this category
    int selectedInCategory = equipmentItems
        .where((item) => _selectedEquipment[item] == true)
        .length;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              _getCategoryIcon(category),
              color: Color(0xFF0D47A1),
              size: 22,
            ),
            SizedBox(width: 12),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "$selectedInCategory of ${equipmentItems.length} selected",
          style: TextStyle(fontSize: 12),
        ),
        childrenPadding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: selectedInCategory > 0,
        children: equipmentItems.map((item) {
          return _buildEquipmentItem(item);
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Respiratory':
        return Icons.air;
      case 'Monitoring':
        return Icons.monitor_heart;
      case 'Diagnostic':
        return Icons.biotech;
      case 'Surgical':
        return Icons.medical_services;
      case 'Infusion':
        return Icons.water_drop;
      default:
        return Icons.medical_information;
    }
  }

  Widget _buildEquipmentItem(String equipment) {
    return CheckboxListTile(
      title: Text(
        equipment,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF0D47A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "Available: 3",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
        ],
      ),
      value: _selectedEquipment[equipment],
      activeColor: Color(0xFF0D47A1),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      onChanged: (bool? value) {
        setState(() {
          _selectedEquipment[equipment] = value ?? false;
        });
      },
    );
  }

  Widget _buildRequestDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF0D47A1),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate.add(Duration(days: 1));
                          }
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: _startDate.add(Duration(days: 30)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF0D47A1),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildLocationField(),
            SizedBox(height: 16),
            _buildPurposeField(),
            SizedBox(height: 16),
            _buildUrgentSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF0D47A1),
                ),
                SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Location/Room',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: Color(0xFF0D47A1),
        ),
        hintText: 'e.g., ICU Room 205',
      ),
      onChanged: (value) {
        _location = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter location';
        }
        return null;
      },
    );
  }

  Widget _buildPurposeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Purpose',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 45),
          child: Icon(
            Icons.description_outlined,
            color: Color(0xFF0D47A1),
          ),
        ),
        hintText: 'Briefly describe purpose of equipment usage',
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      onChanged: (value) {
        _purpose = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter purpose';
        }
        return null;
      },
    );
  }

  Widget _buildUrgentSwitch() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isUrgent ? Colors.red.shade300 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
        color: _isUrgent ? Colors.red.shade50 : Colors.transparent,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Urgent Request",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _isUrgent ? Colors.red.shade800 : Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Mark if needed within 24 hours",
                style: TextStyle(
                  fontSize: 12,
                  color: _isUrgent ? Colors.red.shade700 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Spacer(),
          Switch(
            value: _isUrgent,
            activeColor: Colors.red.shade700,
            onChanged: (bool value) {
              setState(() {
                _isUrgent = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF0D47A1)),
            SizedBox(width: 8),
            Text("Help & Information"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
                icon: Icons.inventory_2,
                title: "Equipment Selection",
                description: "Select equipment by category. Each item shows current availability."
            ),
            _buildHelpItem(
                icon: Icons.calendar_today,
                title: "Request Period",
                description: "Choose start and end dates for equipment usage."
            ),
            _buildHelpItem(
                icon: Icons.priority_high,
                title: "Urgent Requests",
                description: "Mark requests as urgent only if needed within 24 hours."
            ),
            _buildHelpItem(
                icon: Icons.security,
                title: "Responsibility",
                description: "You are responsible for the equipment during the requested period."
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF0D47A1),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF0D47A1)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitRequest() {
    // Get list of selected equipment
    List<String> selectedItems = _selectedEquipment.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Get category for each selected item
    Map<String, List<String>> categorizedItems = {};
    _equipmentCategories.forEach((category, items) {
      List<String> selectedInCategory = items
          .where((item) => _selectedEquipment[item] == true)
          .toList();

      if (selectedInCategory.isNotEmpty) {
        categorizedItems[category] = selectedInCategory;
      }
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF0D47A1)),
            SizedBox(width: 8),
            Text("Request Submitted"),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF0D47A1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Request #MEQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _isUrgent ? "Priority: Urgent" : "Priority: Standard",
                      style: TextStyle(
                        color: _isUrgent ? Colors.red : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Duration: ${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year}",
                    ),
                    Text("Location: $_location"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Selected Equipment:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...categorizedItems.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    ...entry.value.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF0D47A1), size: 16),
                          SizedBox(width: 8),
                          Text(item),
                        ],
                      ),
                    )),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: Text("OK"),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF0D47A1),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
// Return Medical Equipment Page
class ReturnMedicalEquipmentPage extends StatefulWidget {
  final User user;

  ReturnMedicalEquipmentPage({required this.user});

  @override
  _ReturnMedicalEquipmentPageState createState() => _ReturnMedicalEquipmentPageState();
}

class _ReturnMedicalEquipmentPageState extends State<ReturnMedicalEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEquipment;
  String _condition = 'Excellent';
  String _notes = '';
  bool _needsMaintenance = false;

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
                          ..._borrowedEquipment.map((equipment) => _buildEquipmentSelectionCard(equipment)).toList(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
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
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Equipment Condition',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.health_and_safety_outlined),
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
            color: isSelected
                ? Color(0xFF2E7D32)
                : Colors.grey.withOpacity(0.3),
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