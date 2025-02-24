import 'package:flutter/material.dart';

import 'main.dart';

class ManufacturerListPage extends StatelessWidget {
  final List<Manufacturer> manufacturers = [
    Manufacturer(
      id: "1",
      name: "Medical Supplies Co.",
      contact: "John Doe",
      email: "john@medicalsupplies.com",
      phone: "+1 234 567 8900",
      address: "123 Medical Drive, Health City, HC 12345",
    ),
    Manufacturer(
      id: "2",
      name: "Healthcare Products Inc.",
      contact: "Jane Smith",
      email: "jane@healthcareproducts.com",
      phone: "+1 234 567 8901",
      address: "456 Health Avenue, Care City, CC 67890",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manufacturers")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: manufacturers.length,
        itemBuilder: (context, index) {
          final manufacturer = manufacturers[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.factory, color: Colors.green),
              ),
              title: Text(
                manufacturer.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(manufacturer.contact),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildManufacturerInfo(
                        Icons.email,
                        "Email",
                        manufacturer.email,
                      ),
                      SizedBox(height: 8),
                      _buildManufacturerInfo(
                        Icons.phone,
                        "Phone",
                        manufacturer.phone,
                      ),
                      SizedBox(height: 8),
                      _buildManufacturerInfo(
                        Icons.location_on,
                        "Address",
                        manufacturer.address,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add manufacturer logic
        },
      ),
    );
  }

  Widget _buildManufacturerInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
