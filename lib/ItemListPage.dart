import 'package:flutter/material.dart';

import 'AddEditItemPage.dart';
import 'ItemDetailsPage.dart';
import 'ItemSearchDelegate.dart';
import 'main.dart';

class ItemListPage extends StatelessWidget {
  final List<Item> items = [
    Item(
      id: "1",
      name: "Surgical Mask",
      description: "3-ply disposable face mask",
      manufacturerId: "1",
      quantity: 1000,
      location: "Warehouse A",
      lastUpdated: DateTime.now(),
    ),
    Item(
      id: "2",
      name: "Stethoscope",
      description: "Professional grade diagnostic tool",
      manufacturerId: "2",
      quantity: 50,
      location: "Storage B",
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ItemSearchDelegate(items),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.inventory_2, color: Colors.blue),
              ),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Qty: ${item.quantity} • ${item.location}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailsPage(item: item),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItemPage()),
        ),
      ),
    );
  }
}
