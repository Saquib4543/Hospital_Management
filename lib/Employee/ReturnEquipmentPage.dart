import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';

class ReturnEquipmentPage extends StatelessWidget {
  final User user;

  ReturnEquipmentPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Return Equipment")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 2, // Example count
        itemBuilder: (context, index) {
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
                      Icon(Icons.laptop, size: 32, color: Colors.blue),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Laptop",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Borrowed: 15th Feb 2025",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due Date",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "25th Feb 2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showReturnDialog(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Return Now"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Return Equipment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please confirm the equipment condition:"),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Notes",
                hintText: "Any damages or issues?",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
              // Process return logic
              Navigator.pop(context);
              _showReturnConfirmation(context);
            },
            child: Text("Confirm Return"),
          ),
        ],
      ),
    );
  }

  void _showReturnConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Equipment has been marked for return. Please deliver it to the inventory department."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
