import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hospital_inventory_management/Employee/Pages/DropDown_Option.dart';
import 'package:hospital_inventory_management/main.dart';
import 'package:hospital_inventory_management/Employee/Pages/Camera_Out_Controller.dart';

import '../../models/user_model.dart';

class RequestEquipmentPage extends StatefulWidget {
  final User user;

  const RequestEquipmentPage({Key? key, required this.user}) : super(key: key);

  @override
  _RequestEquipmentPageState createState() => _RequestEquipmentPageState();
}

class _RequestEquipmentPageState extends State<RequestEquipmentPage> {
  final _formKey = GlobalKey<FormState>();

  // Date fields
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));

  // Other form fields
  String _purpose = '';
  String _location = '';
  bool _isUrgent = false;

  // For scanning feedback
  String? _scannedBarcode;

  /// Equipment data
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> equipmentList = [];
  List<Map<String, dynamic>> displayedList = [];
  List<Map<String, dynamic>> filteredList = [];
  final Set<Map<String, dynamic>> selectedEquipments = {};

  /// NEW: to store the API data from itemdetails
  List<Map<String, dynamic>> apiDevicesList = [];
  bool isLoadingApi = false;
  String? apiErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
    _fetchDevices(); // fetch from the new API endpoint
  }

  //----------------------------------------------------------------------------
  // 1) FETCH DEVICES FROM THE NEW API (itemdetails)
  //----------------------------------------------------------------------------
  Future<void> _fetchDevices() async {
    setState(() {
      isLoadingApi = true;
      apiErrorMessage = null;
    });

    try {
      final url = Uri.parse('https://uat.goclaims.in/inventory_hub/itemdetails');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Convert each dynamic map to a Map<String, dynamic>
        final List<Map<String, dynamic>> devices =
        jsonData.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          apiDevicesList = devices;
          isLoadingApi = false;
        });
      } else {
        setState(() {
          apiErrorMessage = 'Error: ${response.statusCode} while fetching devices.';
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

  //----------------------------------------------------------------------------
  // 2) EXISTING LOGIC FOR LOADING EQUIPMENT
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
    // Optionally show a dialog with details about the equipment
    // For now, just a placeholder
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(equipment['name'] ?? 'Unknown'),
        content: Text("Category: ${equipment['category']}\n"
            "Status: ${equipment['status']}\n"
            "Available: ${equipment['equipments_available']}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void _toggleItemSelection(Map<String, dynamic> item, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedEquipments.add(item);
      } else {
        selectedEquipments.remove(item);
      }
    });
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request submitted!")),
      );
      Navigator.pop(context); // close the page
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate.add(Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  //----------------------------------------------------------------------------
  // 3) BUILD UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final selectedCount = selectedEquipments.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Medical Equipment"),
        backgroundColor: const Color(0xFF2E7D32),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // (A) SCAN EQUIPMENT BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan Equipment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () async {
                      final scannedResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraOutController(),
                        ),
                      );
                      if (scannedResult != null) {
                        setState(() {
                          _scannedBarcode = scannedResult.toString();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Scanned: $_scannedBarcode"),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // (B) DEVICES AVAILABLE CARD (from new API)
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
                          "Devices available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isLoadingApi) ...[
                          Center(child: CircularProgressIndicator()),
                        ] else if (apiErrorMessage != null) ...[
                          Text(
                            apiErrorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ] else ...[
                          if (apiDevicesList.isEmpty)
                            const Center(
                              child: Text("No devices found."),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: apiDevicesList.length,
                              itemBuilder: (context, index) {
                                final device = apiDevicesList[index];
                                final itemId =
                                    device['item_id']?.toString() ?? 'Unknown';
                                final desc =
                                    device['description']?.toString() ?? '';
                                final issuanceStatus =
                                    device['issuance_status']?.toString() ?? '';
                                final refId =
                                    device['ref_id']?.toString() ?? '';
                                final fromDate =
                                    device['from_date']?.toString() ?? '';
                                final toDate =
                                    device['to_date']?.toString() ?? '';

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
                                        "Issuance Status: $issuanceStatus\n"
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

                // (C) SELECT EQUIPMENT SECTION
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Select Equipment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search equipment...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: _filterEquipment,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: filteredList.isEmpty
                              ? const Center(
                            child: Text("No equipment available"),
                          )
                              : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final name = item['name'] ?? '';
                              final category = item['category'] ?? '';
                              final status = item['status'] ?? '';
                              final availableCount =
                                  item['equipments_available'] ?? 0;

                              final bool isUnavailable =
                                  status.toLowerCase() == 'unavailable';
                              final bool isChecked =
                              selectedEquipments.contains(item);

                              return ListTile(
                                onTap: () => _showEquipmentDialog(item),
                                title: Text(name),
                                subtitle: Text(
                                  "Category: $category\n"
                                      "Status: $status\n"
                                      "Available: $availableCount",
                                ),
                                leading: const Icon(
                                  Icons.precision_manufacturing,
                                ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: isUnavailable
                                      ? null // disable if unavailable
                                      : (bool? newValue) {
                                    if (newValue == null) return;
                                    _toggleItemSelection(
                                        item, newValue);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedCount > 0
                              ? "$selectedCount item(s) selected"
                              : "No items selected",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // (D) DATE & USAGE INFO SECTION
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Equipment Usage Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                  const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text:
                                  "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                                ),
                                onTap: () => _pickDate(true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                  const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text:
                                  "${_endDate.day}/${_endDate.month}/${_endDate.year}",
                                ),
                                onTap: () => _pickDate(false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon:
                            const Icon(Icons.location_on_outlined),
                          ),
                          onChanged: (value) => _location = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Purpose',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon:
                            const Icon(Icons.description_outlined),
                          ),
                          maxLines: 3,
                          onChanged: (value) => _purpose = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a purpose';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text(
                            "Urgent Request",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text(
                            "Mark if needed within 24 hours",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _isUrgent,
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (bool value) {
                            setState(() {
                              _isUrgent = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // (E) SUBMIT REQUEST BUTTON
                ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
