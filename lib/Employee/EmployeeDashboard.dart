import 'package:flutter/material.dart';
import 'package:hospital_inventory_management/Employee/Pages/DropDown_Option.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard Functions/RequestEquipmentPage.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard Functions/ReturnEquipmentPage.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard Functions/EquipmentStatusPage.dart';
import '../LoginPage.dart';
import '../main.dart';
import '../models/user_model.dart';
import 'Pages/Camera_In_Controller.dart';

enum RequestStatus {
  pending,
  approved,
  rejected,
  borrowed,
  returned,
  overdue,
}

class MedicalDashboard extends StatelessWidget {
  final User user;

  const MedicalDashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediTrack Pro"),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
          // IconButton(
          //   icon: const Icon(Icons.person_outline),
          //   onPressed: () => _showProfile(context),
          // ),
        ],
      ),
      // drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
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
              // _buildStaffHeader(),
              _buildEquipmentSummary(),
              _buildQuickActions(context),
              _buildActiveRequests(),
              _buildRecentActivities(),
            ],
          ),
        ),
      ),
      // If you still want a floating action button:
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NewMedicalRequestPage(user: user),
      //     ),
      //   ),
      //   backgroundColor: const Color(0xFF2E7D32),
      //   child: const Icon(Icons.add_circle_outline),
      //   tooltip: 'Request New Equipment',
      // ),
    );
  }

  // -------------------------------------------------------------
  // Drawer
  // -------------------------------------------------------------
  // Widget _buildDrawer(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         // Drawer Header
  //         DrawerHeader(
  //           decoration: const BoxDecoration(
  //             gradient: LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  //             ),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               CircleAvatar(
  //                 radius: 36,
  //                 backgroundColor: Colors.white,
  //                 child: Text(
  //                   user.name[0],
  //                   style: const TextStyle(
  //                     fontSize: 30,
  //                     color: Color(0xFF2E7D32),
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Text(
  //                 user.name,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Text(
  //                 user.department,
  //                 style: const TextStyle(
  //                   color: Colors.white70,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         _drawerItem(Icons.dashboard_outlined, "Dashboard"),
  //         _drawerItem(Icons.medical_services_outlined, "Equipment Catalog"),
  //         _drawerItem(Icons.history_outlined, "Request History"),
  //         _drawerItem(Icons.analytics_outlined, "Usage Analytics"),
  //         _drawerItem(Icons.support_outlined, "Support"),
  //         const Divider(),
  //         _drawerItem(Icons.settings_outlined, "Settings"),
  //         _drawerItem(Icons.help_outline, "Help & FAQ"),
  //         ListTile(
  //           leading: const Icon(Icons.logout),
  //           title: const Text("Logout"),
  //           onTap: () {
  //             Navigator.pop(context);
  //             // e.g. Navigator.pushReplacementNamed(context, '/login');
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
  // Widget _buildStaffHeader() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Icon(
  //               Icons.medical_services,
  //               color: Colors.white,
  //               size: 28,
  //             ),
  //             const SizedBox(width: 14),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Hello, Dr. ${user.name.split(' ')[0]}",
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   "${user.department} • Staff ID: ${user.employeeId}",
  //                   style: TextStyle(
  //                     color: Colors.white.withOpacity(0.8),
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Text(
  //           "Monday, February 24, 2025", // or dynamic date
  //           style: TextStyle(
  //             color: Colors.white.withOpacity(0.9),
  //             fontSize: 14,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // -------------------------------------------------------------
  // Equipment Summary
  // -------------------------------------------------------------
  Widget _buildEquipmentSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Equipment Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _summaryItem(
      String label, String count, IconData icon, Color color) {
    return Column(
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
    );
  }

  // -------------------------------------------------------------
  // Quick Actions (includes "Equipments" + "Equipment Status")
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
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // 1) "Equipments" button (camera scanning flow)
              Expanded(
                child: _actionCard(
                  context,
                  "Equipments",
                  Icons.devices,
                      () {
                    // Example: open your scanning flow
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const CameraInController(),
                      ),
                    );
                  },
                  const Color(0xFF8E24AA),
                ),
              ),
              const SizedBox(width: 16),

              // 2) "Equipment Status" button
              Expanded(
                child: _actionCard(
                  context,
                  "Equipment Status",
                  Icons.report_problem_outlined,
                      () {
                    // Navigate to your EquipmentStatusPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => EquipmentStatusPage(user: user),
                      ),
                    );
                  },
                  const Color(0xFFE53935),
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
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle "View All"
                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Some example items
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
        title: Row(
          children: [
            Text(
              item,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
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
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(date),
            const SizedBox(height: 2),
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
      default:
        return status.toString().split('.').last.toUpperCase();
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
              color: Colors.grey,
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
  // Notifications (Placeholder)
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

  Widget _notificationItem(String title, String message, DateTime time,
      {bool isUnread = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFF2E7D32).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? const Color(0xFF2E7D32).withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread ? const Color(0xFF2E7D32) : Colors.transparent,
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
  // Profile (Placeholder)
  // -------------------------------------------------------------
  // void _showProfile(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Example avatar
  //           Container(
  //             width: 100,
  //             height: 100,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 user.name[0],
  //                 style: const TextStyle(
  //                   fontSize: 40,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             user,
  //             style: const TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             user.email,
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //             decoration: BoxDecoration(
  //               color: const Color(0xFF2E7D32).withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(
  //                 color: const Color(0xFF2E7D32).withOpacity(0.3),
  //               ),
  //             ),
  //             child: Text(
  //               user.department,
  //               style: const TextStyle(
  //                 color: Color(0xFF2E7D32),
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[100],
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 _profileStatItem("Requests", "24"),
  //                 _profileStatItem("Active", "7"),
  //                 _profileStatItem("Returned", "17"),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: OutlinedButton(
  //                   onPressed: () {},
  //                   style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                     side: const BorderSide(color: Color(0xFF2E7D32)),
  //                   ),
  //                   child: const Text("Edit Profile"),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     // e.g. Navigator.pushReplacementNamed(context, '/login');
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF2E7D32),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                   ),
  //                   child: const Text("Logout"),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _profileStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 4),
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
