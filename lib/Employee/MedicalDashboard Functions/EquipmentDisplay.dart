import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../EmployeeDashboard.dart';
import 'item_details.dart';

enum EquipmentAction {
  none,
  take,
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
  late List<Item_Details> allItems;
  late List<bool> isSelected;

  EquipmentAction selectedAction = EquipmentAction.none;

  // TAKE
  bool isRequest = true; // true => "Issued", false => "Reserved"
  DateTime? takeFromDate;
  DateTime? takeToDate;
  final TextEditingController purposeController = TextEditingController();

  // SUBMIT
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool needsMaintenance = false;

  // Manually enter location
  final TextEditingController userLocationController = TextEditingController();

  final String currentUserId = "john.doe@hospital.com";

  final _serverDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    allItems = List.from(widget.scannedItems);
    // By default, each item is selected
    isSelected = List.generate(allItems.length, (_) => true);
  }

  // ----------------- Bulk Update API -----------------
  Future<void> _updateItemsInBulk({
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
      if (response.statusCode == 200) {
        debugPrint('Success!');
      } else {
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  // Helper: show snack bar for validations
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ----------------- TAKE (ISSUED/RESERVED) -----------------
  Future<void> _submitTakeEquipment() async {
    // Validate required fields
    if (takeFromDate == null || takeToDate == null) {
      _showValidationError("Please select both From and To dates.");
      return;
    }
    if (purposeController.text.trim().isEmpty) {
      _showValidationError("Please enter the purpose.");
      return;
    }
    if (userLocationController.text.trim().isEmpty) {
      _showValidationError("Please enter the user location.");
      return;
    }

    final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
    final selectedItems = <Item_Details>[];

    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i] &&
          !_isCheckboxDisabled(allItems[i], EquipmentAction.take)) {
        selectedItems.add(allItems[i]);
      }
    }

    final String newStatus = isRequest ? 'Issued' : 'Reserved';
    final String fromDateStr = _serverDateFormat.format(takeFromDate!);
    final String toDateStr = _serverDateFormat.format(takeToDate!);

    final userLocation = userLocationController.text.trim();

    debugPrint(
        '** _submitTakeEquipment => $newStatus, count=${selectedItems.length}');

    final List<Map<String, dynamic>> itemsData = [];
    for (final item in selectedItems) {
      itemsData.add({
        "issuance_status": newStatus,
        "from_date": fromDateStr,
        "to_date": toDateStr,
        "user_location": userLocation,
        "qr_id": item.id,
      });
    }

    await _updateItemsInBulk(referenceId: referenceId, itemsData: itemsData);

    final itemsSummary = selectedItems
        .map((item) => '${item.name} (qr: ${item.id}, loc: $userLocation)')
        .join('\n');

    _showEnhancedDialog(
      "Equipment Take",
      "Type: $newStatus\n"
          "From: $fromDateStr\n"
          "To: $toDateStr\n"
          "Purpose: ${purposeController.text}\n"
          "User Location: $userLocation\n\n"
          "Items:\n$itemsSummary",
    );
  }

  // ----------------- SUBMIT (RETURN -> AVAILABLE) -----------------
  Future<void> _submitSubmitEquipment() async {
    // Validate fields
    if (conditionController.text.trim().isEmpty) {
      _showValidationError("Please enter the equipment condition.");
      return;
    }
    if (userLocationController.text.trim().isEmpty) {
      _showValidationError("Please enter the user location.");
      return;
    }

    final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
    final selectedItems = <Item_Details>[];

    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i] &&
          !_isCheckboxDisabled(allItems[i], EquipmentAction.submit)) {
        selectedItems.add(allItems[i]);
      }
    }

    const String newStatus = 'Available';
    const String fromDateStr = "";
    const String toDateStr = "";

    final userLocation = userLocationController.text.trim();

    debugPrint(
        '** _submitSubmitEquipment => $newStatus, count=${selectedItems.length}');

    final List<Map<String, dynamic>> itemsData = [];
    for (final item in selectedItems) {
      itemsData.add({
        "issuance_status": newStatus,
        "from_date": fromDateStr,
        "to_date": toDateStr,
        "user_location": userLocation,
        "qr_id": item.id,
      });
    }

    await _updateItemsInBulk(referenceId: referenceId, itemsData: itemsData);

    final itemsSummary = selectedItems
        .map((item) => '${item.name} (qr: ${item.id}, loc: $userLocation)')
        .join('\n');

    _showEnhancedDialog(
      "Equipment Return",
      "Condition: ${conditionController.text}\n"
          "Notes/Issues: ${notesController.text}\n"
          "Needs Maintenance: ${needsMaintenance ? 'Yes' : 'No'}\n"
          "User Location: $userLocation\n\n"
          "Items:\n$itemsSummary",
    );
  }

  // ----------------- NAVIGATE BACK TO MEDICAL DASHBOARD -----------------
  void _navigateToMedicalDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MedicalDashboard(username: currentUserId),
      ),
          (route) => false,
    );
  }

  bool _isCheckboxDisabled(Item_Details item, EquipmentAction action) {
    final status = item.issuanceStatus.toLowerCase();
    if (action == EquipmentAction.take) {
      return status != 'available';  // can only take if it's 'available'
    } else if (action == EquipmentAction.submit) {
      return status == 'available';  // can only submit if it's not 'available'
    }
    return false;
  }

  /// Shows an enhanced popup with two buttons:
  /// "Continue" -> Just closes pop-up
  /// "Complete" -> Redirect to MedicalDashboard
  void _showEnhancedDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          // "Continue" on bottom left
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continue"),
          ),
          // "Complete" on bottom right
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
  Future<void> _pickTakeDate({required bool pickFromDate}) async {
    final currentDate = pickFromDate
        ? (takeFromDate ?? DateTime.now())
        : (takeToDate ?? DateTime.now().add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        if (pickFromDate) {
          takeFromDate = picked;
          // ensure toDate is at least one day after fromDate
          if (takeToDate == null || takeFromDate!.isAfter(takeToDate!)) {
            takeToDate = takeFromDate!.add(const Duration(days: 1));
          }
        } else {
          takeToDate = picked;
          // ensure fromDate is before toDate
          if (takeFromDate == null || takeToDate!.isBefore(takeFromDate!)) {
            takeFromDate = takeToDate!.subtract(const Duration(days: 1));
          }
        }
      });
    }
  }

  // ----------------- BUILD UI -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Display", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF3B7AF5),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1) Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
          ),
          // 1B) Pattern overlay
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),

          // 2) Scrollable content
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
                          _buildEquipmentSelection(),
                          const SizedBox(height: 16),
                          _buildActionSelection(),
                          const SizedBox(height: 16),
                          if (selectedAction == EquipmentAction.take)
                            _buildTakeEquipmentCard(),
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

  // ----------------- ACTION CHIPS -----------------
  Widget _buildActionSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("Take Equipment"),
          selected: selectedAction == EquipmentAction.take,
          showCheckmark: false,
          onSelected: (selected) {
            setState(() {
              selectedAction =
              selected ? EquipmentAction.take : EquipmentAction.none;
            });
          },
        ),
        const SizedBox(width: 16),
        ChoiceChip(
          label: const Text("Submit Equipment"),
          selected: selectedAction == EquipmentAction.submit,
          showCheckmark: false,
          onSelected: (selected) {
            setState(() {
              selectedAction =
              selected ? EquipmentAction.submit : EquipmentAction.none;
            });
          },
        ),
      ],
    );
  }

  // ----------------- LIST OF SCANNED ITEMS (with checkboxes in separate cards) -----------------
  Widget _buildEquipmentSelection() {
    final selectedCount = isSelected.where((b) => b).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scanned Items:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Selected: $selectedCount / ${allItems.length}",
          style: const TextStyle(fontSize: 14),
        ),
        const Divider(),

        // We display each item in its own Card, with a checkbox
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allItems.length,
          itemBuilder: (ctx, i) {
            final item = allItems[i];
            final disabled = _isCheckboxDisabled(item, selectedAction);

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
                // If it's disabled, we forcibly uncheck the item
                value: isSelected[i] && !disabled,
                onChanged: disabled
                    ? null
                    : (val) {
                  if (val != null) {
                    setState(() {
                      isSelected[i] = val;
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

  // ----------------- TAKE EQUIPMENT CARD -----------------
  Widget _buildTakeEquipmentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Take Equipment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Switch => Issued or Reserved
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Issued"),
            Switch(
              value: !isRequest,
              onChanged: (val) {
                setState(() {
                  isRequest = !val;
                });
              },
            ),
            const Text("Reserved"),
          ],
        ),
        const SizedBox(height: 16),

        // Date pickers
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickTakeDate(pickFromDate: true),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    takeFromDate == null
                        ? "From Date"
                        : _serverDateFormat.format(takeFromDate!),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _pickTakeDate(pickFromDate: false),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    takeToDate == null
                        ? "To Date"
                        : _serverDateFormat.format(takeToDate!),
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
          decoration: const InputDecoration(
            labelText: "Purpose",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // User location
        TextField(
          controller: userLocationController,
          decoration: const InputDecoration(
            labelText: "User Location",
            border: OutlineInputBorder(),
          ),
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
            child: const Text("Update to Issued/Reserved"),
          ),
        ),
      ],
    );
  }

  // ----------------- SUBMIT EQUIPMENT CARD -----------------
  Widget _buildSubmitEquipmentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Submit Equipment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Condition
        TextField(
          controller: conditionController,
          decoration: const InputDecoration(
            labelText: "Equipment Condition",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Notes
        TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: "Notes / Issues",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // Maintenance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Needs Maintenance?"),
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
          decoration: const InputDecoration(
            labelText: "User Location",
            border: OutlineInputBorder(),
          ),
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

// ----------------- Grid Pattern Painter (like in Login) -----------------
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
