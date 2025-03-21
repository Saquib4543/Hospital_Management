import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../EmployeeDashboard.dart';
import 'item_details.dart';

enum EquipmentAction {
  none,
  take,
  reserve,
  submit,
}

class EquipmentDisplay extends StatefulWidget {
  final List<Item_Details> scannedItems;

  const EquipmentDisplay({Key? key, required this.scannedItems})
      : super(key: key);

  @override
  _EquipmentDisplayState createState() => _EquipmentDisplayState();
}

class _EquipmentDisplayState extends State<EquipmentDisplay> {
  // All scanned items
  late List<Item_Details> allItems;
  // Whether each item is selected (indexed by allItems)
  late List<bool> isSelected;

  // The user’s current chosen action
  EquipmentAction selectedAction = EquipmentAction.none;

  // TAKE / RESERVE
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController userLocationController = TextEditingController();

  // SUBMIT
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool needsMaintenance = false;

  final String currentUserId = "john.doe@hospital.com";
  final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4"; // example
  final _serverDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    // Copy scannedItems into allItems
    allItems = List.from(widget.scannedItems);
    // Initially, no items selected
    isSelected = List.generate(allItems.length, (_) => false);
  }

  // ----------------- API: Bulk Update -----------------
  /// Returns the `http.Response` so each action can handle success/fail status.
  Future<http.Response?> _updateItemsInBulk({
    required String referenceId,
    required List<Map<String, dynamic>> itemsData,
  }) async {
    final url =
        'https://uat.goclaims.in/inventory_hub/multiple_itemdetails/$referenceId';

    debugPrint('--------------------------------------------------------');
    debugPrint('** _updateItemsInBulk called => $url');
    final body = json.encode(itemsData);
    debugPrint('** Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      debugPrint('** Response status: ${response.statusCode}');
      debugPrint('** Response body: ${response.body}');
      return response;
    } catch (e) {
      debugPrint('Exception (API call): $e');
      return null; // indicates an exception/failure
    }
  }

  // Helper: show snack bar for validations or statuses
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ----------------- TAKE → Issued -----------------
  Future<void> _submitTakeEquipment() async {
    // Validate fields
    if (fromDate == null || toDate == null) {
      _showSnackbar("Please select both From and To dates.");
      return;
    }
    if (purposeController.text.trim().isEmpty) {
      _showSnackbar("Please enter the purpose.");
      return;
    }
    if (userLocationController.text.trim().isEmpty) {
      _showSnackbar("Please enter the user location.");
      return;
    }

    // Gather selected items
    final selectedItems = _getDisplayedItems().where((item) {
      final idx = allItems.indexOf(item);
      return isSelected[idx];
    }).toList();
    if (selectedItems.isEmpty) {
      _showSnackbar("No items selected to take.");
      return;
    }

    final String newStatus = 'Issued';
    final String fromDateStr = _serverDateFormat.format(fromDate!);
    final String toDateStr = _serverDateFormat.format(toDate!);
    final userLocation = userLocationController.text.trim();

    final List<Map<String, dynamic>> itemsData = [];
    for (final item in selectedItems) {
      itemsData.add({
        "issuance_status": newStatus,
        "from_date": fromDateStr,
        "to_date": toDateStr,
        "user_location": userLocation,
        "qr_id": item.id, // ensuring qr_id is passed
      });
    }

    // Call the API
    final response = await _updateItemsInBulk(
      referenceId: referenceId,
      itemsData: itemsData,
    );

    if (response == null) {
      // Exception
      _showSnackbar("Failed to submit data (network error).");
      return;
    }

    if (response.statusCode == 200) {
      // Show success snack bar
      _showSnackbar("Successfully submitted data!");

      // Show summary in dialog
      final itemsSummary = selectedItems
          .map((item) => '${item.name} (QR: ${item.id}, loc: $userLocation)')
          .join('\n');

      _showEnhancedDialog(
        "Equipment Take",
        "Status: $newStatus\n"
            "From: $fromDateStr\n"
            "To: $toDateStr\n"
            "Purpose: ${purposeController.text}\n"
            "User Location: $userLocation\n\n"
            "Items:\n$itemsSummary",
      );
    } else {
      // Show failure snack bar
      _showSnackbar("Failed to submit data. Status: ${response.statusCode}");
    }
  }

  // ----------------- RESERVE → Reserved -----------------
  Future<void> _submitReserveEquipment() async {
    // Validate fields
    if (fromDate == null || toDate == null) {
      _showSnackbar("Please select both From and To dates.");
      return;
    }
    if (purposeController.text.trim().isEmpty) {
      _showSnackbar("Please enter the purpose.");
      return;
    }
    if (userLocationController.text.trim().isEmpty) {
      _showSnackbar("Please enter the user location.");
      return;
    }

    // Gather selected items
    final selectedItems = _getDisplayedItems().where((item) {
      final idx = allItems.indexOf(item);
      return isSelected[idx];
    }).toList();
    if (selectedItems.isEmpty) {
      _showSnackbar("No items selected to reserve.");
      return;
    }

    final String newStatus = 'Reserved';
    final String fromDateStr = _serverDateFormat.format(fromDate!);
    final String toDateStr = _serverDateFormat.format(toDate!);
    final userLocation = userLocationController.text.trim();

    final List<Map<String, dynamic>> itemsData = [];
    for (final item in selectedItems) {
      itemsData.add({
        "issuance_status": newStatus,
        "from_date": fromDateStr,
        "to_date": toDateStr,
        "user_location": userLocation,
        "qr_id": item.id, // ensuring qr_id is passed
      });
    }

    // Call the API
    final response = await _updateItemsInBulk(
      referenceId: referenceId,
      itemsData: itemsData,
    );

    if (response == null) {
      // Exception
      _showSnackbar("Failed to submit data (network error).");
      return;
    }

    if (response.statusCode == 200) {
      // Show success snack bar
      _showSnackbar("Successfully submitted data!");

      // Show summary in dialog
      final itemsSummary = selectedItems
          .map((item) => '${item.name} (QR: ${item.id}, loc: $userLocation)')
          .join('\n');

      _showEnhancedDialog(
        "Equipment Reserve",
        "Status: $newStatus\n"
            "From: $fromDateStr\n"
            "To: $toDateStr\n"
            "Purpose: ${purposeController.text}\n"
            "User Location: $userLocation\n\n"
            "Items:\n$itemsSummary",
      );
    } else {
      // Show failure snack bar
      _showSnackbar("Failed to submit data. Status: ${response.statusCode}");
    }
  }

  // ----------------- SUBMIT → Available -----------------
  Future<void> _submitSubmitEquipment() async {
    // Validate fields
    if (conditionController.text.trim().isEmpty) {
      _showSnackbar("Please enter the equipment condition.");
      return;
    }
    if (userLocationController.text.trim().isEmpty) {
      _showSnackbar("Please enter the user location.");
      return;
    }

    // Gather selected items
    final selectedItems = _getDisplayedItems().where((item) {
      final idx = allItems.indexOf(item);
      return isSelected[idx];
    }).toList();
    if (selectedItems.isEmpty) {
      _showSnackbar("No items selected to submit/return.");
      return;
    }

    const String newStatus = 'Available';
    const String fromDateStr = "";
    const String toDateStr = "";
    final userLocation = userLocationController.text.trim();

    final List<Map<String, dynamic>> itemsData = [];
    for (final item in selectedItems) {
      itemsData.add({
        "issuance_status": newStatus,
        "from_date": fromDateStr,
        "to_date": toDateStr,
        "user_location": userLocation,
        "qr_id": item.id, // ensuring qr_id is passed
      });
    }

    // Call the API
    final response = await _updateItemsInBulk(
      referenceId: referenceId,
      itemsData: itemsData,
    );

    if (response == null) {
      // Exception
      _showSnackbar("Failed to submit data (network error).");
      return;
    }

    if (response.statusCode == 200) {
      // Show success snack bar
      _showSnackbar("Successfully submitted data!");

      // Show summary in dialog
      final itemsSummary = selectedItems
          .map((item) => '${item.name} (QR: ${item.id}, loc: $userLocation)')
          .join('\n');

      _showEnhancedDialog(
        "Equipment Return",
        "Condition: ${conditionController.text}\n"
            "Notes/Issues: ${notesController.text}\n"
            "Needs Maintenance: ${needsMaintenance ? 'Yes' : 'No'}\n"
            "User Location: $userLocation\n\n"
            "Items:\n$itemsSummary",
      );
    } else {
      // Show failure snack bar
      _showSnackbar("Failed to submit data. Status: ${response.statusCode}");
    }
  }

  // ----------------- NAVIGATE BACK TO DASHBOARD -----------------
  void _navigateToMedicalDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MedicalDashboard(),
      ),
          (route) => false,
    );
  }

  /// Shows an enhanced popup with two buttons:
  /// "Continue" -> Closes pop-up
  /// "Complete" -> Redirects to MedicalDashboard
  void _showEnhancedDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continue"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToMedicalDashboard();
            },
            child: const Text("Complete"),
          ),
        ],
      ),
    );
  }

  // ----------------- PICK DATE UI HELPER -----------------
  Future<void> _pickDate({required bool pickFromDate}) async {
    final initial = pickFromDate
        ? (fromDate ?? DateTime.now())
        : (toDate ?? DateTime.now().add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        if (pickFromDate) {
          fromDate = picked;
          // ensure toDate is at least one day after fromDate if not set
          if (toDate == null || fromDate!.isAfter(toDate!)) {
            toDate = fromDate!.add(const Duration(days: 1));
          }
        } else {
          toDate = picked;
          // ensure fromDate is before toDate if not set
          if (fromDate == null || toDate!.isBefore(fromDate!)) {
            fromDate = toDate!.subtract(const Duration(days: 1));
          }
        }
      });
    }
  }

  // ----------------- FILTER ITEMS BASED ON ACTION -----------------
  List<Item_Details> _getDisplayedItems() {
    // If user hasn't chosen anything yet, show all
    if (selectedAction == EquipmentAction.none) return allItems;

    if (selectedAction == EquipmentAction.take) {
      // show only items "Available"
      return allItems
          .where((item) => item.issuanceStatus.toLowerCase() == 'available')
          .toList();
    } else if (selectedAction == EquipmentAction.reserve) {
      // show only items "Available"
      return allItems
          .where((item) => item.issuanceStatus.toLowerCase() == 'available')
          .toList();
    } else if (selectedAction == EquipmentAction.submit) {
      // show only items "Issued" or "Reserved"
      return allItems.where((item) {
        final status = item.issuanceStatus.toLowerCase();
        return (status == 'issued' || status == 'reserved');
      }).toList();
    }
    return allItems;
  }

  // ----------------- BUILD UI -----------------
  @override
  Widget build(BuildContext context) {
    final displayedItems = _getDisplayedItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Equipment Display",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B7AF5),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1) Background gradient (blue)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
          ),
          // 2) Light pattern overlay
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),
          // 3) Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card containing the main content
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // -------------- LIST OF SCANNED ITEMS --------------
                          _buildEquipmentSelection(displayedItems),

                          const SizedBox(height: 16),

                          // -------------- HORIZONTAL SCROLL ROW OF BUTTONS --------------
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedAction = EquipmentAction.take;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B7AF5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Take Equipment"),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedAction = EquipmentAction.reserve;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B7AF5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Reserve Equipment"),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedAction = EquipmentAction.submit;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B7AF5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Submit Equipment"),
                                ),
                              ],
                            ),
                          ),

                          // -------------- FORMS FOR EACH ACTION --------------
                          const SizedBox(height: 16),
                          if (selectedAction == EquipmentAction.take)
                            _buildTakeEquipmentCard(),
                          if (selectedAction == EquipmentAction.reserve)
                            _buildReserveEquipmentCard(),
                          if (selectedAction == EquipmentAction.submit)
                            _buildSubmitEquipmentCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- SCANNED ITEMS LIST (CHECKBOXES) -----------------
  Widget _buildEquipmentSelection(List<Item_Details> displayedItems) {
    // Number selected among *displayed* items
    final selectedCount = displayedItems.where((item) {
      final idx = allItems.indexOf(item);
      return isSelected[idx];
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Scanned Items:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Selected: $selectedCount / ${displayedItems.length}",
          style: const TextStyle(fontSize: 14),
        ),
        const Divider(),

        // Each item with checkbox
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedItems.length,
          itemBuilder: (ctx, i) {
            final item = displayedItems[i];
            final idxInAll = allItems.indexOf(item);
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: CheckboxListTile(
                title: Text(
                  'Item Name: ${item.name}',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'QR: ${item.id}\n'
                      'Status: ${item.issuanceStatus}\n'
                      'Description: ${item.description}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                value: isSelected[idxInAll],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      isSelected[idxInAll] = val;
                    });
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // Reusable input decoration for text fields (blue background, black text)
  InputDecoration _blueTextFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      fillColor: const Color(0xFF3B7AF5), // TextField background
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // ----------------- TAKE EQUIPMENT CARD -----------------
  Widget _buildTakeEquipmentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Take Equipment (Issued)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),

        // Date pickers
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(pickFromDate: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B7AF5),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    fromDate == null
                        ? "From Date"
                        : _serverDateFormat.format(fromDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(pickFromDate: false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B7AF5),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    toDate == null
                        ? "To Date"
                        : _serverDateFormat.format(toDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Purpose
        TextField(
          controller: purposeController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("Purpose"),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // User location
        TextField(
          controller: userLocationController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("User Location"),
        ),
        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitTakeEquipment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B7AF5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Update to Issued"),
          ),
        ),
      ],
    );
  }

  // ----------------- RESERVE EQUIPMENT CARD -----------------
  Widget _buildReserveEquipmentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reserve Equipment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),

        // Date pickers
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(pickFromDate: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B7AF5),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    fromDate == null
                        ? "From Date"
                        : _serverDateFormat.format(fromDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(pickFromDate: false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B7AF5),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    toDate == null
                        ? "To Date"
                        : _serverDateFormat.format(toDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Purpose
        TextField(
          controller: purposeController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("Purpose"),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // User location
        TextField(
          controller: userLocationController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("User Location"),
        ),
        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitReserveEquipment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B7AF5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Update to Reserved"),
          ),
        ),
      ],
    );
  }

  // ----------------- SUBMIT EQUIPMENT CARD (RETURN) -----------------
  Widget _buildSubmitEquipmentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Submit Equipment (Return to Available)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),

        // Condition
        TextField(
          controller: conditionController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("Equipment Condition"),
        ),
        const SizedBox(height: 16),

        // Notes
        TextField(
          controller: notesController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("Notes / Issues"),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // Maintenance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Needs Maintenance?", style: TextStyle(color: Colors.black)),
            Switch(
              value: needsMaintenance,
              onChanged: (val) {
                setState(() {
                  needsMaintenance = val;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Location
        TextField(
          controller: userLocationController,
          style: const TextStyle(color: Colors.black),
          decoration: _blueTextFieldDecoration("User Location"),
        ),
        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitSubmitEquipment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B7AF5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Return (Set to Available)"),
          ),
        ),
      ],
    );
  }
}

// ----------------- Grid Pattern Painter (light overlay) -----------------
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const double gridSize = 30.0;

    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
