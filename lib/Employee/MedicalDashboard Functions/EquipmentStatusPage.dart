import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hospital_inventory_management/Employee/Pages/DropDown_Option.dart';
import 'package:hospital_inventory_management/main.dart';

class EquipmentStatusPage extends StatefulWidget {
  final User user;

  const EquipmentStatusPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EquipmentStatusPage> createState() => _EquipmentStatusPageState();
}

class _EquipmentStatusPageState extends State<EquipmentStatusPage> {
  final TextEditingController searchController = TextEditingController();

  // The existing lists for "Recently Added Equipment"
  List<Map<String, dynamic>> equipmentList = [];
  List<Map<String, dynamic>> displayedList = [];
  List<Map<String, dynamic>> filteredList = [];

  // NEW: For the itemdetails API
  List<Map<String, dynamic>> statusApiDevicesList = [];
  bool statusIsLoadingApi = false;
  String? statusApiErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadEquipment();    // existing logic
    _fetchStatusApi();   // fetch data from the new API
  }

  //----------------------------------------------------------------------------
  // 1) FETCH DATA FROM https://uat.goclaims.in/inventory_hub/itemdetails
  //----------------------------------------------------------------------------
  Future<void> _fetchStatusApi() async {
    setState(() {
      statusIsLoadingApi = true;
      statusApiErrorMessage = null;
    });

    try {
      final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Map<String, dynamic>> devices =
        jsonData.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          statusApiDevicesList = devices;
          statusIsLoadingApi = false;
        });
      } else {
        setState(() {
          statusApiErrorMessage =
          'Error: ${response.statusCode} while fetching status devices.';
          statusIsLoadingApi = false;
        });
      }
    } catch (e) {
      setState(() {
        statusApiErrorMessage = 'Exception: $e';
        statusIsLoadingApi = false;
      });
    }
  }

  //----------------------------------------------------------------------------
  // 2) EXISTING LOGIC FOR "Recently Added Equipment"
  //----------------------------------------------------------------------------
  void _loadEquipment() {
    final List<Map<String, dynamic>> allEquipment = [];
    for (var item in DropDownOption.equipmentData) {
      allEquipment.add(item);
    }

    setState(() {
      equipmentList = allEquipment;
      displayedList = _getRandomItems(equipmentList, 10);
      filteredList = List.from(displayedList);
    });
  }

  List<Map<String, dynamic>> _getRandomItems(
      List<Map<String, dynamic>> list, int count) {
    if (list.length <= count) return List.from(list);
    list.shuffle(Random());
    return list.sublist(0, count);
  }

  void _filterEquipment(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(displayedList);
      } else {
        filteredList = equipmentList
            .where((item) {
          final itemName = (item['name'] ?? '').toLowerCase();
          return itemName.contains(query.toLowerCase());
        })
            .toList();
      }
    });
  }

  void _showEquipmentDialog(Map<String, dynamic> equipment) {
    final status = (equipment['status'] ?? '').toString().toLowerCase();
    final category = equipment['category'] ?? 'Unknown';
    final name = equipment['name'] ?? 'Unknown';
    final condition = equipment['condition'] ?? 'Unknown';
    final description = equipment['description'] ?? 'No description';
    final totalEquipments = (equipment['total_equipments'] ?? 0).toString();
    final equipmentsAvailable =
    (equipment['equipments_available'] ?? 0).toString();
    final bool isAvailable = status == 'available';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable ? 'Item is Available!' : 'Item is Unavailable!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Category: $category'),
                  Text('Name: $name'),
                  Text('Status: ${equipment['status'] ?? 'Unknown'}'),
                  Text('Condition: $condition'),
                  Text('Description: $description'),
                  Text('Total Equipments: $totalEquipments'),
                  Text('Equipments Available: $equipmentsAvailable'),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logging out...")),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  //----------------------------------------------------------------------------
  // 3) BUILD UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Status"),
        backgroundColor: const Color(0xFF2E7D32),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // (A) NEW BACKGROUND CARD (API DATA)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Equipment from API",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (statusIsLoadingApi) ...[
                        Center(child: CircularProgressIndicator()),
                      ] else if (statusApiErrorMessage != null) ...[
                        Text(
                          statusApiErrorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ] else ...[
                        if (statusApiDevicesList.isEmpty)
                          const Center(child: Text("No devices found."))
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: statusApiDevicesList.length,
                            itemBuilder: (context, index) {
                              final device = statusApiDevicesList[index];
                              final itemId =
                                  device['item_id']?.toString() ?? 'Unknown';
                              final desc =
                                  device['description']?.toString() ?? '';
                              final issuanceStatus =
                                  device['issuance_status']?.toString() ?? '';
                              final fromDate =
                                  device['from_date']?.toString() ?? '';
                              final toDate =
                                  device['to_date']?.toString() ?? '';
                              final refId =
                                  device['ref_id']?.toString() ?? '';

                              return ListTile(
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 4),
                                leading: const Icon(
                                  Icons.devices_other,
                                  color: Color(0xFF2E7D32),
                                ),
                                title: Text(
                                  desc.isNotEmpty
                                      ? desc
                                      : '(No description)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Item ID: $itemId\n"
                                      "Issuance: $issuanceStatus\n"
                                      "Ref ID: $refId\n"
                                      "From: $fromDate\n"
                                      "To: $toDate",
                                ),
                              );
                            },
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // (B) SEARCH BAR
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search equipment...",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _filterEquipment,
              ),

              const SizedBox(height: 20),

              // (C) RECENTLY ADDED EQUIPMENT LIST
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recently Added Equipment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: filteredList.isEmpty
                              ? const Center(
                              child: Text("No equipment available"))
                              : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final name = item['name'] ?? '';
                              final category = item['category'] ?? '';
                              final status = item['status'] ?? '';
                              final availableCount =
                                  item['equipments_available'] ?? 0;

                              return ListTile(
                                onTap: () =>
                                    _showEquipmentDialog(item),
                                title: Text(name),
                                subtitle: Text(
                                  "Category: $category\n"
                                      "Status: $status\n"
                                      "Available: $availableCount",
                                ),
                                leading: const Icon(
                                  Icons.precision_manufacturing,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
