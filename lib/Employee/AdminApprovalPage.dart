
import 'package:flutter/material.dart';

import '../main.dart';

class AdminApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Equipment Requests"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPendingRequests(),
            _buildActiveRequests(),
            _buildRequestHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequests() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildRequestCard(
          context,
          RequestStatus.pending,
          "John Doe",
          "Laptop",
          "Project presentation",
          "2025-02-25",
        );
      },
    );
  }

  Widget _buildActiveRequests() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildRequestCard(
          context,
          RequestStatus.borrowed,
          "Jane Smith",
          "Projector",
          "Team meeting",
          "2025-02-28",
        );
      },
    );
  }

  Widget _buildRequestHistory() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRequestCard(
          context,
          RequestStatus.returned,
          "Bob Wilson",
          "Monitor",
          "Remote work setup",
          "2025-02-20",
        );
      },
    );
  }

  Widget _buildRequestCard(
      BuildContext context,
      RequestStatus status,
      String employeeName,
      String equipment,
      String purpose,
      String dueDate,
      ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(employeeName[0]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        equipment,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Purpose:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(purpose),
            SizedBox(height: 8),
            Text(
              "Due Date: $dueDate",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            if (status == RequestStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showRejectDialog(context),
                    child: Text("Reject"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showApproveDialog(context),
                    child: Text("Approve"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    Color color;
    String text;

    switch (status) {
      case RequestStatus.pending:
        color = Colors.orange;
        text = "PENDING";
        break;
      case RequestStatus.approved:
        color = Colors.green;
        text = "APPROVED";
        break;
      case RequestStatus.rejected:
        color = Colors.red;
        text = "REJECTED";
        break;
      case RequestStatus.borrowed:
        color = Colors.blue;
        text = "BORROWED";
        break;
      case RequestStatus.returned:
        color = Colors.grey;
        text = "RETURNED";
        break;
      case RequestStatus.overdue:
        color = Colors.purple;
        text = "OVERDUE";
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Approve Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to approve this request?"),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Notes (Optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Approve logic
              Navigator.pop(context);
            },
            child: Text("Approve"),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reject Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please provide a reason for rejection:"),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please provide a reason';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Reject logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Reject"),
          ),
        ],
      ),
    );
  }
}
