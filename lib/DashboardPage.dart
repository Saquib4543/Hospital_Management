import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AddEditItemPage.dart';
import 'ItemDetailsPage.dart';
import 'ItemListPage.dart';
import 'ItemSearchDelegate.dart';
import 'ManufacturerPage.dart';
import 'QRCodePage.dart';
import 'main.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic> _dashboardData = {
    "available_count": "0",
    "issued_count": 0,
    "reserved_count": 0,
    "total_items": 0,
    "total_quantity": "0",
    "recent_updates": []
  };

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://uat.goclaims.in/inventory_hub/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchDashboardData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 32),
                _isLoading
                    ? _buildLoadingStats()
                    : _hasError
                    ? _buildErrorStats()
                    : _buildStatCards(),
                SizedBox(height: 32),
                _buildMainGrid(context),
                SizedBox(height: 32),
                _buildRecentUpdates(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          );
        },
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
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

  Widget _buildLoadingStats() {
    return Row(
      children: [
        _buildLoadingStatCard(),
        SizedBox(width: 16),
        _buildLoadingStatCard(),
        SizedBox(width: 16),
        _buildLoadingStatCard(),
      ].map((widget) => Expanded(child: widget)).toList(),
    );
  }

  Widget _buildLoadingStatCard() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Spacer(),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: 80,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStats() {
    return Row(
      children: [
        _buildStatCard(
          "Available Items",
          "0",
          "N/A",
          Colors.blue[700]!,
          Icons.inventory_2_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Issued Items",
          "0",
          "N/A",
          Colors.green[700]!,
          Icons.local_shipping_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Reserved Items",
          "0",
          "N/A",
          Colors.orange[700]!,
          Icons.pending_actions_outlined,
        ),
      ].map((widget) => Expanded(child: widget)).toList(),
    );
  }

  Widget _buildStatCards() {
    final String availableCount = _dashboardData['available_count'] ?? "0";
    final String issuedCount = (_dashboardData['issued_count'] ?? 0).toString();
    final String reservedCount = (_dashboardData['reserved_count'] ?? 0).toString();
    final String totalItems = (_dashboardData['total_items'] ?? 0).toString();

    // Calculate trend percentages (you might want to store previous values to calculate actual trends)
    // For now using placeholders
    final availableTrend = "+5.2%";
    final issuedTrend = "+3.1%";
    final reservedTrend = "-2.4%";

    return Row(
      children: [
        _buildStatCard(
          "Available Items",
          availableCount,
          availableTrend,
          Colors.blue[700]!,
          Icons.inventory_2_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Issued Items",
          issuedCount,
          issuedTrend,
          Colors.green[700]!,
          Icons.local_shipping_outlined,
        ),
        SizedBox(width: 16),
        _buildStatCard(
          "Reserved Items",
          reservedCount,
          reservedTrend,
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

  Widget _buildRecentUpdates() {
    final recentUpdates = _dashboardData['recent_updates'] as List? ?? [];

    if (_isLoading) {
      return _buildLoadingRecentUpdates();
    }

    if (_hasError || recentUpdates.isEmpty) {
      return _buildEmptyRecentUpdates();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Updates",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentUpdates.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final update = recentUpdates[index];
              return ListTile(
                title: Text('Item ID: ${update['item_id']}'),
                subtitle: Text('Updated: ${update['updated_at']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusChip('Qty: ${update['quantity']}', Colors.blue),
                    SizedBox(width: 8),
                    _buildStatusChip('Reserved: ${update['reserved']}', Colors.orange),
                    SizedBox(width: 8),
                    _buildStatusChip('Issued: ${update['issued']}', Colors.green),
                  ],
                ),
                onTap: () {
                  // Navigate to item details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsPage(itemId: update['item_id']),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, MaterialColor color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoadingRecentUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Updates",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                subtitle: Container(
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) => Container(
                    width: 60,
                    height: 24,
                    margin: EdgeInsets.only(left: i > 0 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRecentUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Updates",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
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
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 48,
                  color: Colors.blue[300],
                ),
                SizedBox(height: 16),
                Text(
                  "No recent updates available",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Recent inventory changes will appear here",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    final totalItemsCount = _dashboardData['total_items']?.toString() ?? "0";

    final cards = [
      _buildActionCard(
        context,
        "Items",
        Icons.inventory_2_outlined,
        ItemListPage(),
        Colors.blue,
        "View and manage items",
        "$totalItemsCount items in stock",
      ),
      _buildActionCard(
        context,
        "Manufacturers",
        Icons.factory_outlined,
        ManufacturerListPage(),
        Colors.green,
        "Manage suppliers",
        "Supplier management",
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