import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../LoginPage.dart';
import '../main.dart';
import 'MedicalDashboard Functions/user_provider.dart';
import 'Pages/Camera_In_Controller.dart';
import 'Pages/DropDown_Option.dart';
import 'MedicalDashboard Functions/EquipmentStatusPage.dart';
import 'MedicalDashboard Functions/RequestEquipmentPage.dart';
import 'MedicalDashboard Functions/ReturnEquipmentPage.dart';

enum RequestStatus {
  pending,
  approved,
  rejected,
  borrowed,
  returned,
  overdue,
}

class MedicalDashboard extends StatelessWidget {
  final String username;

  const MedicalDashboard({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String? userReferenceId = userProvider.referenceId;

    return Scaffold(
      // If you prefer an AppBar that matches the new gradient's top color:
      appBar: AppBar(
        title: const Text("MediTrack Pro",style: TextStyle(color: Colors.white),),
        // Example: matching the first color in your new gradient
        backgroundColor: const Color(0xFF3B7AF5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _showProfile(context, userReferenceId),
          ),
        ],
      ),

      // Wrap the body in a Stack so we can place a gradient & optional pattern
      body: Stack(
        children: [
          // 1) Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
          ),

          // 2) Optional pattern overlay (like in your LoginPage)
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),

          // 3) Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A container or card for the top “Staff Header”
                _buildStaffHeader(userReferenceId),
                const SizedBox(height: 8),

                // Summaries + Quick actions, etc. in white cards
                _buildEquipmentSummary(),
                _buildQuickActions(context),
                _buildActiveRequests(),
                _buildRecentActivities(),
              ],
            ),
          ),
        ],
      ),

      drawer: _buildDrawer(context, userReferenceId),
    );
  }

  // -------------------------------------------------------------
  // Drawer
  // -------------------------------------------------------------
  Widget _buildDrawer(BuildContext context, String? referenceId) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with gradient
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    _getFirstName(username)[0], // Extract first letter
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0xFF3B7AF5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getFirstName(username), // Extract first name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Employee ID: ${referenceId ?? 'N/A'}", // Show reference ID
                  style: const TextStyle(
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
          const Divider(),
          _drawerItem(Icons.settings_outlined, "Settings"),
          _drawerItem(Icons.help_outline, "Help & FAQ"),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              // Handle logout logic here
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

  // -------------------------------------------------------------
  // Staff Header
  // -------------------------------------------------------------
  Widget _buildStaffHeader(String? referenceId) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon or avatar
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${_getFirstName(username)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Employee ID: ${referenceId ?? 'N/A'}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Monday, February 24, 2025", // or dynamic date
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Equipment Summary
  // -------------------------------------------------------------
  Widget _buildEquipmentSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Equipment Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B7AF5),
                ),
              ),
              const SizedBox(height: 16),
              // Use Wrap instead of Row to avoid overflow on small screens
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 16,
                children: [
                  _summaryItem(
                    "Active",
                    "7",
                    Icons.medical_information,
                    const Color(0xFF2E7D32),
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
        ),
      ),
    );
  }

  Widget _summaryItem(
      String label,
      String count,
      IconData icon,
      Color color,
      ) {
    return SizedBox(
      width: 100, // fixed width so they can wrap nicely
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Quick Actions (Equipments + Equipment Status)
  // -------------------------------------------------------------
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _actionCard(
                context,
                "Equipments",
                Icons.devices,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const CameraInController(),
                    ),
                  );
                },
                const Color(0xFF8E24AA),
              ),
              _actionCard(
                context,
                "Equipment Status",
                Icons.report_problem_outlined,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EquipmentStatusPage(userReferenceId: ''),
                    ),
                  );
                },
                const Color(0xFFE53935),
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
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Active Medical Equipment
  // -------------------------------------------------------------
  Widget _buildActiveRequests() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + "View All"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Medical Equipment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle "View All"
                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _medicalEquipmentCard(
            "Portable Ultrasound",
            "Due: Tomorrow, 9:00 AM",
            RequestStatus.borrowed,
            "Operating Room 3",
          ),
          const SizedBox(height: 10),
          _medicalEquipmentCard(
            "Infusion Pump",
            "Due: February 26, 2:00 PM",
            RequestStatus.borrowed,
            "ICU Room 202",
          ),
          const SizedBox(height: 10),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
          ),
        ),
        // Name
        title: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        // Status label below name, plus date + location
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            const SizedBox(height: 6),
            Text(date),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
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
          icon: const Icon(Icons.more_vert),
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
        return const Color(0xFF1565C0);
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
    }
  }

  // -------------------------------------------------------------
  // Recent Activities
  // -------------------------------------------------------------
  Widget _buildRecentActivities() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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

  Widget _timelineItem(
      String title,
      String time,
      IconData icon,
      Color color, {
        bool isFirst = false,
        bool isLast = false,
      }) {
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
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

  // -------------------------------------------------------------
  // Notifications (Bottom Sheet)
  // -------------------------------------------------------------
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Mark all as read",
                        style: TextStyle(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _notificationItem(
                        "Equipment Request Approved",
                        "Your request for Infusion Pump has been approved",
                        DateTime.now().subtract(const Duration(hours: 1)),
                        isUnread: true,
                      ),
                      _notificationItem(
                        "Return Reminder",
                        "Portable Ultrasound is due tomorrow by 9:00 AM",
                        DateTime.now().subtract(const Duration(hours: 3)),
                        isUnread: true,
                      ),
                      _notificationItem(
                        "New Equipment Available",
                        "10 new Pulse Oximeters have been added to inventory",
                        DateTime.now().subtract(const Duration(days: 1)),
                      ),
                      _notificationItem(
                        "Equipment Maintenance",
                        "Scheduled maintenance for Ventilators on Feb 28",
                        DateTime.now().subtract(const Duration(days: 2)),
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

  Widget _notificationItem(
      String title,
      String message,
      DateTime time, {
        bool isUnread = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        isUnread ? const Color(0xFF3B7AF5).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? const Color(0xFF3B7AF5).withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot indicator for unread notifications
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread ? const Color(0xFF3B7AF5) : Colors.transparent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
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

  // -------------------------------------------------------------
  // Profile (Bottom Sheet)
  // -------------------------------------------------------------
  void _showProfile(BuildContext context, String? referenceId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
                ),
              ),
              child: Center(
                child: Text(
                  _getFirstName(username)[0], // Extract first letter
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getFirstName(username),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              username, // Show email as username
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Employee ID: ${referenceId ?? 'N/A'}", // Show reference ID
              style: const TextStyle(
                color: Color(0xFF3B7AF5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Extracts the first name from a username
  String _getFirstName(String username) {
    final parts = username.split(RegExp(r"[.@]")); // Split on dot or @
    return parts.isNotEmpty
        ? parts[0][0].toUpperCase() + parts[0].substring(1)
        : username;
  }
}

// -------------------------------------------------------------
// OPTIONAL: GridPatternPainter if you want the same patterned overlay
// -------------------------------------------------------------
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const double gridSize = 30.0;

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
