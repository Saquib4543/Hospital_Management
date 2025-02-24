import 'package:flutter/material.dart';

class ExpiringItem {
  final String name;
  final int daysLeft;

  ExpiringItem({required this.name, required this.daysLeft});
}

class ExpiringItemsPage extends StatelessWidget {
  final List<ExpiringItem> expiringItems = [
    ExpiringItem(name: "Surgical Gloves", daysLeft: 15),
    ExpiringItem(name: "Face Masks", daysLeft: 30),
    ExpiringItem(name: "Sterile Bandages", daysLeft: 10),
    ExpiringItem(name: "IV Fluids", daysLeft: 7),
    ExpiringItem(name: "Insulin Syringes", daysLeft: 5),
    ExpiringItem(name: "Blood Test Strips", daysLeft: 20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expiring Medical Equipment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: expiringItems.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  expiringItems[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Expires in ${expiringItems[index].daysLeft} days",
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(Icons.warning, color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
