import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';

class EquipmentStatusPage extends StatefulWidget {
  final String userReferenceId;

  const EquipmentStatusPage({Key? key, required this.userReferenceId})
      : super(key: key);

  @override
  State<EquipmentStatusPage> createState() => _EquipmentStatusPageState();
}

class _EquipmentStatusPageState extends State<EquipmentStatusPage> {
  final TextEditingController searchController = TextEditingController();

  // API list + filtered list
  List<Map<String, dynamic>> apiDevicesList = [];
  List<Map<String, dynamic>> filteredDevicesList = [];

  bool isLoadingApi = false;
  String? apiErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchApiDevices();
  }

  // ---------------------------------------------------------------------------
  //  1) FETCH DATA FROM https://uat.goclaims.in/inventory_hub/itemdetails
  // ---------------------------------------------------------------------------
  Future<void> _fetchApiDevices() async {
    setState(() {
      isLoadingApi = true;
      apiErrorMessage = null;
    });

    try {
      final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Map<String, dynamic>> devices =
        jsonData.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          apiDevicesList = devices;
          // Initially, the filtered list is the full set
          filteredDevicesList = devices;
          isLoadingApi = false;
        });
      } else {
        setState(() {
          apiErrorMessage = 'Error ${response.statusCode} loading devices.';
          isLoadingApi = false;
        });
      }
    } catch (e) {
      setState(() {
        apiErrorMessage = 'Exception: $e';
        isLoadingApi = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  //  2) SEARCH / FILTER
  // ---------------------------------------------------------------------------
  void _filterDevices(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDevicesList = List.from(apiDevicesList);
      });
      return;
    }
    query = query.toLowerCase();
    setState(() {
      filteredDevicesList = apiDevicesList.where((device) {
        final desc = (device['description'] ?? '').toString().toLowerCase();
        return desc.contains(query);
      }).toList();
    });
  }

  // ---------------------------------------------------------------------------
  //  3) LOGOUT (IF NEEDED)
  // ---------------------------------------------------------------------------
  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logging out...")),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // ---------------------------------------------------------------------------
  //  4) SHOW ITEM DIALOG
  // ---------------------------------------------------------------------------
  void _showItemDialog(Map<String, dynamic> device) {
    final itemId = device['item_id']?.toString() ?? 'Unknown';
    final desc = device['description']?.toString() ?? 'No description';
    final issuance = device['issuance_status']?.toString() ?? 'Unknown';
    final fromDate = device['from_date']?.toString() ?? '';
    final toDate = device['to_date']?.toString() ?? '';
    final refId = device['ref_id']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Item ID: $itemId'),
                Text('Issuance: $issuance'),
                Text('Ref ID: $refId'),
                Text('From: $fromDate'),
                Text('To: $toDate'),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  5) BUILD UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Updated AppBar color to match new gradient theme
      appBar: AppBar(
        title: const Text("Equipment Status"),
        backgroundColor: const Color(0xFF3B7AF5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
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

          // 2) Optional pattern overlay (like in Login)
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),

          // 3) Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // (A) SEARCH BAR
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search by description...",
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: _filterDevices,
                ),

                const SizedBox(height: 16),

                // (B) EQUIPMENT LIST (from API)
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: _buildApiList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiList() {
    if (isLoadingApi) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiErrorMessage != null) {
      return Text(apiErrorMessage!, style: const TextStyle(color: Colors.red));
    } else if (filteredDevicesList.isEmpty) {
      return const Center(child: Text("No matching devices found."));
    } else {
      return ListView.builder(
        itemCount: filteredDevicesList.length,
        itemBuilder: (context, index) {
          final device = filteredDevicesList[index];
          final itemId = device['item_id']?.toString() ?? 'Unknown';
          final desc = device['description']?.toString() ?? '(No description)';
          final issuance = device['issuance_status']?.toString() ?? 'Unknown';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: const Icon(
              Icons.devices_other,
              color: Color(0xFF3B7AF5), // or 0xFF2E7D32
            ),
            title: Text(
              desc,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Item ID: $itemId\nIssuance: $issuance"),
            onTap: () => _showItemDialog(device),
          );
        },
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Optional grid pattern painter
// ---------------------------------------------------------------------------
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const gridSize = 30.0;

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
