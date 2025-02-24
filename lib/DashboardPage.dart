import 'package:flutter/material.dart';

import 'AddEditItemPage.dart';
import 'ItemDetailsPage.dart';
import 'ItemListPage.dart';
import 'ItemSearchDelegate.dart';
import 'ManufacturerPage.dart';
import 'QRCodePage.dart';
import 'main.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: Text("Dashboard", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.notifications_outlined, color: Colors.black54),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.search, color: Colors.black54),
      //       onPressed: () {},
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: CircleAvatar(
      //         backgroundColor: Colors.blue[100],
      //         child: Text("A", style: TextStyle(color: Colors.blue[700])),
      //       ),
      //     ),
      //   ],
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 32),
              _buildStatCards(),
              SizedBox(height: 32),
              _buildMainGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Welcome back, ",
              style: TextStyle(fontSize: 28, color: Colors.black87),
            ),
            Text(
              "Admin!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Manage your inventory efficiently and track performance",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _buildStatCard(
          "Total Items",
          "2,846",
          "+12.5%",
          Colors.blue[700]!,
          Icons.inventory_2_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Active Orders",
          "148",
          "+8.2%",
          Colors.green[700]!,
          Icons.local_shipping_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Pending Items",
          "24",
          "-2.4%",
          Colors.orange[700]!,
          Icons.pending_actions_outlined,
        ),
      ].map((widget) => Expanded(child: widget)).toList(),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      String trend,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trend.contains('+') ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: trend.contains('+') ? Colors.green[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    final cards = [
      _buildActionCard(
        context,
        "Items",
        Icons.inventory_2_outlined,
        ItemListPage(),
        Colors.blue,
        "View and manage items",
        "2,846 items in stock",
      ),
      _buildActionCard(
        context,
        "Manufacturers",
        Icons.factory_outlined,
        ManufacturerListPage(),
        Colors.green,
        "Manage suppliers",
        "48 active suppliers",
      ),
      _buildActionCard(
        context,
        "Scan QR",
        Icons.qr_code_scanner,
        QRScannerPage(),
        Colors.purple,
        "Quick item lookup",
        "Instant scanning",
      ),
      _buildActionCard(
        context,
        "Add Item",
        Icons.add_box_outlined,
        AddItemPage(),
        Colors.orange,
        "Create new entry",
        "Quick item creation",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.2,
          children: cards,
        );
      },
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Widget page,
      MaterialColor color,
      String description,
      String subtitle,
      ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  icon,
                  size: 100,
                  color: color[50],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: color[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


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

