import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'AddEditItemPage.dart';
import 'main.dart';  // Import this package

class ItemDetailsPage extends StatelessWidget {
  final Item item;

  ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditItemPage(item: item),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                ),
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: item.id,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    "Description",
                    item.description,
                    Icons.description,
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    "Quantity",
                    item.quantity.toString(),
                    Icons.shopping_cart,
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    "Location",
                    item.location,
                    Icons.location_on,
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    "Last Updated",
                    item.lastUpdated.toString(),
                    Icons.update,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
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
}
