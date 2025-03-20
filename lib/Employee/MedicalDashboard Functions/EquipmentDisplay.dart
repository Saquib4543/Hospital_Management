// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/user_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:hospital_inventory_management/Employee/MedicalDashboard Functions/item_details.dart';
// import 'package:provider/provider.dart';
// import '../EmployeeDashboard.dart';
//
// enum EquipmentAction {
//   none,
//   take,
//   submit,
// }
//
// class EquipmentDisplay extends StatefulWidget {
//   final List<Item_Details> scannedItems;
//
//   const EquipmentDisplay({Key? key, required this.scannedItems})
//       : super(key: key);
//
//   @override
//   _EquipmentDisplayState createState() => _EquipmentDisplayState();
// }
//
// class _EquipmentDisplayState extends State<EquipmentDisplay> {
//   late List<Item_Details> allItems;
//   late List<bool> isSelected;
//
//   // Which action is chosen? None / Take / Submit
//   EquipmentAction selectedAction = EquipmentAction.none;
//
//   // TAKE equipment
//   bool isRequest = true; // true => "Issued", false => "Reserved"
//   DateTime? takeFromDate;
//   DateTime? takeToDate;
//   final TextEditingController purposeController = TextEditingController();
//
//   // SUBMIT equipment
//   final TextEditingController conditionController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   bool needsMaintenance = false;
//
//   // Let user manually enter location
//   final TextEditingController userLocationController = TextEditingController();
//
//   // Example placeholders; in your real code, set these from actual login data:
//   final String currentUserId = "john.doe@hospital.com";
//
//   @override
//   void initState() {
//     super.initState();
//     // Copy scanned items
//     allItems = List.from(widget.scannedItems);
//     // Mark them all selected by default
//     isSelected = List.generate(allItems.length, (_) => true);
//   }
//
//   // ---------------------------------------------------------------------------
//   //  API: POST call to update multiple items in a single request
//   // ---------------------------------------------------------------------------
//   Future<void> _updateItemsInBulk({
//     required String referenceId,
//     required List<Map<String, dynamic>> itemsData,
//   }) async {
//     final url =
//         'https://uat.goclaims.in/inventory_hub/multiple_itemdetails/$referenceId';
//
//     debugPrint('--------------------------------------------------------');
//     debugPrint('** _updateItemsInBulk called with referenceId = $referenceId');
//     debugPrint('Sending POST request to: $url');
//
//     // Body is an array of objects
//     final body = json.encode(itemsData);
//
//     debugPrint('** Request body: $body');
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       debugPrint('** Response status code: ${response.statusCode}');
//       debugPrint('** Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         debugPrint('Success: Bulk update\n');
//       } else {
//         debugPrint(
//             'Error ${response.statusCode} in bulk update: ${response.body}\n');
//       }
//     } catch (e) {
//       debugPrint('Exception in bulk update: $e\n');
//     }
//   }
//
//   // ---------------------------------------------------------------------------
//   //  PICK TAKE DATE (From/To) - using yyyy-MM-dd HH:mm:ss
//   // ---------------------------------------------------------------------------
//   final _serverDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//
//   Future<void> _pickTakeDate({required bool pickFromDate}) async {
//     final currentDate = pickFromDate
//         ? (takeFromDate ?? DateTime.now())
//         : (takeToDate ?? DateTime.now().add(const Duration(days: 1)));
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: currentDate,
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2050),
//     );
//     if (picked != null) {
//       setState(() {
//         if (pickFromDate) {
//           takeFromDate = picked;
//           if (takeToDate == null || takeFromDate!.isAfter(takeToDate!)) {
//             takeToDate = takeFromDate!.add(const Duration(days: 1));
//           }
//         } else {
//           takeToDate = picked;
//           if (takeFromDate == null || takeToDate!.isBefore(takeFromDate!)) {
//             takeFromDate = takeToDate!.subtract(const Duration(days: 1));
//           }
//         }
//       });
//     }
//   }
//
//   // ---------------------------------------------------------------------------
//   //   TAKE (ISSUED/RESERVE) EQUIPMENT
//   // ---------------------------------------------------------------------------
//   Future<void> _submitTakeEquipment() async {
//     final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
//     final selectedItems = <Item_Details>[];
//
//     for (int i = 0; i < allItems.length; i++) {
//       if (isSelected[i] && !_isCheckboxDisabled(allItems[i], EquipmentAction.take)) {
//         selectedItems.add(allItems[i]);
//       }
//     }
//
//     // The server wants "Issued" or "Reserved"
//     final String newStatus = isRequest ? 'Issued' : 'Reserved';
//
//     // Format with date + time
//     final String fromDateStr = (takeFromDate == null)
//         ? ""
//         : _serverDateFormat.format(takeFromDate!);
//     final String toDateStr = (takeToDate == null)
//         ? ""
//         : _serverDateFormat.format(takeToDate!);
//
//     // Grab the user-entered location
//     final userLocation = userLocationController.text.trim();
//
//     debugPrint('--------------------------------------------------------');
//     debugPrint('** _submitTakeEquipment called');
//     debugPrint('   isRequest => $isRequest => $newStatus');
//     debugPrint('   fromDateStr = $fromDateStr');
//     debugPrint('   toDateStr   = $toDateStr');
//     debugPrint('   purpose     = ${purposeController.text}');
//     debugPrint('   userLoc     = $userLocation');
//     debugPrint('   selectedItems count = ${selectedItems.length}');
//
//     // Build the array of objects
//     final List<Map<String, dynamic>> itemsData = [];
//     for (final item in selectedItems) {
//       itemsData.add({
//         "issuance_status": newStatus,
//         "from_date": fromDateStr,
//         "to_date": toDateStr,
//         "user_location": userLocation,
//         "qr_id": item.id,  // <- qr_id is included for each item
//       });
//     }
//
//     // Make ONE bulk request
//     await _updateItemsInBulk(referenceId: referenceId, itemsData: itemsData);
//
//     // Summarize each item with the user location and QR
//     final itemsSummary = selectedItems.map((item) {
//       return '${item.name} (qr: ${item.id}, loc: $userLocation)';
//     }).join('\n');
//
//     // Show success dialog, and after pressing OK, go back to MedicalDashboard
//     _showDialog(
//       "Equipment Take",
//       "Type: $newStatus\n"
//           "From: $fromDateStr\n"
//           "To: $toDateStr\n"
//           "Purpose: ${purposeController.text}\n"
//           "User Location: $userLocation\n\n"
//           "Selected Items:\n$itemsSummary",
//       onOk: _navigateToMedicalDashboard,  // <--- after OK
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //   SUBMIT (RETURN) EQUIPMENT
//   // ---------------------------------------------------------------------------
//   Future<void> _submitSubmitEquipment() async {
//     final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
//     final selectedItems = <Item_Details>[];
//
//     for (int i = 0; i < allItems.length; i++) {
//       if (isSelected[i] && !_isCheckboxDisabled(allItems[i], EquipmentAction.submit)) {
//         selectedItems.add(allItems[i]);
//       }
//     }
//
//     // Usually returning an item => "Available"
//     const String newStatus = 'Available';
//     const String fromDateStr = "";
//     const String toDateStr = "";
//
//     // Grab user-entered location
//     final userLocation = userLocationController.text.trim();
//
//     debugPrint('--------------------------------------------------------');
//     debugPrint('** _submitSubmitEquipment called');
//     debugPrint('   condition       = ${conditionController.text}');
//     debugPrint('   notes           = ${notesController.text}');
//     debugPrint('   needsMaintenance= $needsMaintenance');
//     debugPrint('   userLoc         = $userLocation');
//     debugPrint('   selectedItems count = ${selectedItems.length}');
//
//     // Build the array of objects for one bulk request
//     final List<Map<String, dynamic>> itemsData = [];
//     for (final item in selectedItems) {
//       itemsData.add({
//         "issuance_status": newStatus,
//         "from_date": fromDateStr,
//         "to_date": toDateStr,
//         "user_location": userLocation,
//         "qr_id": item.id,  // <- qr_id is included for each item
//       });
//     }
//
//     // Make ONE bulk request
//     await _updateItemsInBulk(referenceId: referenceId, itemsData: itemsData);
//
//     // Summarize each item with the user location and QR
//     final itemsSummary = selectedItems.map((item) {
//       return '${item.name} (qr: ${item.id}, loc: $userLocation)';
//     }).join('\n');
//
//     // Show success dialog, and after pressing OK, go back to MedicalDashboard
//     _showDialog(
//       "Equipment Return",
//       "Condition: ${conditionController.text}\n"
//           "Notes/Issues: ${notesController.text}\n"
//           "Needs Maintenance: ${needsMaintenance ? 'Yes' : 'No'}\n"
//           "User Location: $userLocation\n\n"
//           "Selected Items:\n$itemsSummary",
//       onOk: _navigateToMedicalDashboard, // <--- after OK
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //   NAVIGATE TO THE MEDICALDASHBOARD
//   // ---------------------------------------------------------------------------
//   void _navigateToMedicalDashboard() {
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         // Replace with however you create MedicalDashboard
//         builder: (_) => MedicalDashboard(username: currentUserId),
//       ),
//           (route) => false,
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //   Check which items are disabled based on current action
//   // ---------------------------------------------------------------------------
//   bool _isCheckboxDisabled(Item_Details item, EquipmentAction action) {
//     final status = item.issuanceStatus.toLowerCase();
//
//     if (action == EquipmentAction.take) {
//       // Only "Take" items that are "available"
//       return status != 'available';
//     } else if (action == EquipmentAction.submit) {
//       // Only "Submit" (return) items that are NOT "available"
//       return status == 'available';
//     }
//     return false;
//   }
//
//   // ---------------------------------------------------------------------------
//   //   Show a simple dialog
//   //   Add an optional callback onOk that triggers after the user presses "OK"
//   // ---------------------------------------------------------------------------
//   void _showDialog(String title, String content, {VoidCallback? onOk}) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);   // Close the dialog
//               if (onOk != null) {
//                 onOk();                // Then do the callback
//               } else {
//                 // If no callback, reset action
//                 setState(() {
//                   selectedAction = EquipmentAction.none;
//                 });
//               }
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //   BUILD UI (with scrolling for mobile responsiveness)
//   // ---------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Equipment Display"),
//         backgroundColor: const Color(0xFF2E7D32),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // 1) Show the item list FIRST
//             _buildEquipmentSelection(),
//
//             // 2) Then show the action selection chips
//             _buildActionSelection(),
//
//             // 3) Show either the TAKE or the SUBMIT card
//             if (selectedAction == EquipmentAction.take) _buildTakeEquipmentCard(),
//             if (selectedAction == EquipmentAction.submit) _buildSubmitEquipmentCard(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //  ROW: Choice chips for "Take" or "Submit"
//   // ---------------------------------------------------------------------------
//   Widget _buildActionSelection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ChoiceChip(
//           label: const Text("Take Equipment"),
//           selected: selectedAction == EquipmentAction.take,
//           onSelected: (selected) {
//             setState(() {
//               selectedAction = selected ? EquipmentAction.take : EquipmentAction.none;
//             });
//           },
//         ),
//         ChoiceChip(
//           label: const Text("Submit Equipment"),
//           selected: selectedAction == EquipmentAction.submit,
//           onSelected: (selected) {
//             setState(() {
//               selectedAction =
//               selected ? EquipmentAction.submit : EquipmentAction.none;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //        CARD: List of scanned items with checkboxes
//   // ---------------------------------------------------------------------------
//   Widget _buildEquipmentSelection() {
//     final selectedCount = isSelected.where((b) => b).length;
//
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Title row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Items Scanned:",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Selected: $selectedCount / ${allItems.length}",
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//             const Divider(),
//
//             // We let the ListView shrink so the whole page can scroll
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: allItems.length,
//               itemBuilder: (ctx, i) {
//                 final item = allItems[i];
//                 final disabled = _isCheckboxDisabled(item, selectedAction);
//
//                 return CheckboxListTile(
//                   title: Text('${item.name} (${item.id})'),
//                   subtitle: Text(
//                     'Status: ${item.issuanceStatus}\n'
//                         'Description: ${item.description}',
//                   ),
//                   // If disabled => can't toggle
//                   value: isSelected[i] && !disabled,
//                   onChanged: disabled
//                       ? null
//                       : (val) {
//                     if (val != null) {
//                       setState(() {
//                         isSelected[i] = val;
//                       });
//                     }
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //         CARD: "Take Equipment" (Issued or Reserved)
//   // ---------------------------------------------------------------------------
//   Widget _buildTakeEquipmentCard() {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               "Take Equipment",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             // Switch between "Issued" and "Reserved"
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Issued"),
//                 Switch(
//                   value: !isRequest,
//                   onChanged: (val) {
//                     setState(() {
//                       isRequest = !val;
//                     });
//                   },
//                 ),
//                 const Text("Reserved"),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Date pickers
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _pickTakeDate(pickFromDate: true),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         takeFromDate == null
//                             ? "From Date"
//                             : _serverDateFormat.format(takeFromDate!),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => _pickTakeDate(pickFromDate: false),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         takeToDate == null
//                             ? "To Date"
//                             : _serverDateFormat.format(takeToDate!),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Purpose text field
//             TextField(
//               controller: purposeController,
//               decoration: const InputDecoration(
//                 labelText: "Purpose",
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 16),
//
//             // user location text field (same controller for both cards)
//             TextField(
//               controller: userLocationController,
//               decoration: const InputDecoration(
//                 labelText: "User Location",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             ElevatedButton(
//               onPressed: _submitTakeEquipment,
//               child: const Text("Update to Issued/Reserved"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   //          CARD: "Submit Equipment" (Return => Available)
//   // ---------------------------------------------------------------------------
//   Widget _buildSubmitEquipmentCard() {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               "Submit Equipment",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             // Condition field
//             TextField(
//               controller: conditionController,
//               decoration: const InputDecoration(
//                 labelText: "Equipment Condition",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Notes field
//             TextField(
//               controller: notesController,
//               decoration: const InputDecoration(
//                 labelText: "Notes / Issues",
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 16),
//
//             // Maintenance switch
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Needs Maintenance?"),
//                 Switch(
//                   value: needsMaintenance,
//                   onChanged: (val) {
//                     setState(() {
//                       needsMaintenance = val;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // user location text field
//             TextField(
//               controller: userLocationController,
//               decoration: const InputDecoration(
//                 labelText: "User Location",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             ElevatedButton(
//               onPressed: _submitSubmitEquipment,
//               child: const Text("Return (Set to Available)"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../EmployeeDashboard.dart';
import 'item_details.dart';
import 'user_provider.dart';

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

  // ----------------- TAKE (ISSUED/RESERVED) -----------------
  Future<void> _submitTakeEquipment() async {
    final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
    final selectedItems = <Item_Details>[];

    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i] && !_isCheckboxDisabled(allItems[i], EquipmentAction.take)) {
        selectedItems.add(allItems[i]);
      }
    }

    final String newStatus = isRequest ? 'Issued' : 'Reserved';
    final String fromDateStr = takeFromDate == null
        ? ""
        : _serverDateFormat.format(takeFromDate!);
    final String toDateStr = takeToDate == null
        ? ""
        : _serverDateFormat.format(takeToDate!);

    final userLocation = userLocationController.text.trim();

    debugPrint('** _submitTakeEquipment => $newStatus, count=${selectedItems.length}');

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

    _showDialog(
      "Equipment Take",
      "Type: $newStatus\n"
          "From: $fromDateStr\n"
          "To: $toDateStr\n"
          "Purpose: ${purposeController.text}\n"
          "User Location: $userLocation\n\n"
          "Items:\n$itemsSummary",
      onOk: _navigateToMedicalDashboard,
    );
  }

  // ----------------- SUBMIT (RETURN -> AVAILABLE) -----------------
  Future<void> _submitSubmitEquipment() async {
    final String referenceId = "eba1b267-d8e5-4778-8bfd-f3a1917b66f4";
    final selectedItems = <Item_Details>[];

    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i] && !_isCheckboxDisabled(allItems[i], EquipmentAction.submit)) {
        selectedItems.add(allItems[i]);
      }
    }

    const String newStatus = 'Available';
    const String fromDateStr = "";
    const String toDateStr = "";

    final userLocation = userLocationController.text.trim();

    debugPrint('** _submitSubmitEquipment => $newStatus, count=${selectedItems.length}');

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

    _showDialog(
      "Equipment Return",
      "Condition: ${conditionController.text}\n"
          "Notes/Issues: ${notesController.text}\n"
          "Needs Maintenance: ${needsMaintenance ? 'Yes' : 'No'}\n"
          "User Location: $userLocation\n\n"
          "Items:\n$itemsSummary",
      onOk: _navigateToMedicalDashboard,
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
      return status != 'available';
    } else if (action == EquipmentAction.submit) {
      return status == 'available';
    }
    return false;
  }

  void _showDialog(String title, String content, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text("OK"),
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
          if (takeToDate == null || takeFromDate!.isAfter(takeToDate!)) {
            takeToDate = takeFromDate!.add(const Duration(days: 1));
          }
        } else {
          takeToDate = picked;
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
      // If you prefer a consistent color on the app bar from the gradient,
      // you can do that or set it to transparent and place the gradient behind it.
      appBar: AppBar(
        title: const Text("Equipment Display"),
        backgroundColor: const Color(0xFF3B7AF5), // or 0xFF2E7D32
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1) Background gradient + pattern
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  // ----------------- LIST OF SCANNED ITEMS -----------------
  Widget _buildEquipmentSelection() {
    final selectedCount = isSelected.where((b) => b).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scanned Items:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),
        Text(
          "Selected: $selectedCount / ${allItems.length}",
          style: const TextStyle(fontSize: 14),
        ),
        const Divider(),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allItems.length,
          itemBuilder: (ctx, i) {
            final item = allItems[i];
            final disabled = _isCheckboxDisabled(item, selectedAction);

            return CheckboxListTile(
              title: Text(
                '${item.name} (${item.id})',
                style: TextStyle(color: Colors.grey[800]),
              ),
              subtitle: Text(
                'Status: ${item.issuanceStatus}\nDescription: ${item.description}',
                style: TextStyle(color: Colors.grey[600]),
              ),
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

        ElevatedButton(
          onPressed: _submitTakeEquipment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B7AF5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Update to Issued/Reserved"),
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

        ElevatedButton(
          onPressed: _submitSubmitEquipment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B7AF5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Return (Set to Available)"),
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

    final gridSize = 30.0;

    // Horizontal
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
