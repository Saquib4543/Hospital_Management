import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EquipmentDisplay extends StatefulWidget {
  final List<String> scannedItems;

  const EquipmentDisplay({Key? key, required this.scannedItems})
      : super(key: key);

  @override
  _EquipmentDisplayState createState() => _EquipmentDisplayState();
}

enum EquipmentAction { none, take, submit }

class _EquipmentDisplayState extends State<EquipmentDisplay> {
  // Equipment list variables
  late List<String> allItems;
  late List<bool> isSelected;
  // Current selected action (none, take or submit)
  EquipmentAction selectedAction = EquipmentAction.none;
  // TAKE EQUIPMENT card fields
  bool isRequest = true; // true = Request, false = Reserve
  DateTime? takeFromDate;
  DateTime? takeToDate;
  final TextEditingController purposeController = TextEditingController();
  // SUBMIT EQUIPMENT card fields
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool needsMaintenance = false; // default off

  @override
  void initState() {
    super.initState();
    // Copy scanned items
    allItems = List.from(widget.scannedItems);
    // By default, all items are selected
    isSelected = List.generate(allItems.length, (_) => true);
  }

  /// Toggles all items selection.
  void _toggleSelectAll(bool selectAll) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = selectAll;
      }
    });
  }

  /// Date picker helper for Take Equipment card.
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



  void _submitTakeEquipment() {
    final selectedItems = <String>[];
    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i]) selectedItems.add(allItems[i]);
    }
    _showDialog("Equipment Take Request", "Type: ${isRequest ? 'Request' : 'Reserve'}\n"
        "From: ${takeFromDate != null ? DateFormat('dd/MM/yyyy').format(takeFromDate!) : 'N/A'}\n"
        "To: ${takeToDate != null ? DateFormat('dd/MM/yyyy').format(takeToDate!) : 'N/A'}\n"
        "Purpose: ${purposeController.text}\n\n"
        "Selected Items:\n${selectedItems.join('\n')}");
  }



  void _submitSubmitEquipment() {
    final selectedItems = <String>[];
    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i]) selectedItems.add(allItems[i]);
    }
    _showDialog("Equipment Return", "Condition: ${conditionController.text}\n"
        "Notes/Issues: ${notesController.text}\n"
        "Needs Maintenance: ${needsMaintenance ? 'Yes' : 'No'}\n\n"
        "Selected Items:\n${selectedItems.join('\n')}");
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedAction = EquipmentAction.none;
              });
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final selectedCount = isSelected.where((b) => b).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Display"),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEquipmentSelection(selectedCount),
            _buildActionSelection(),
            if (selectedAction == EquipmentAction.take) _buildTakeEquipmentCard(),
            if (selectedAction == EquipmentAction.submit) _buildSubmitEquipmentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSelection(int selectedCount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Items Scanned:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Selected: $selectedCount / ${allItems.length}",
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: allItems.length,
                itemBuilder: (ctx, i) {
                  return CheckboxListTile(
                    title: Text(allItems[i]),
                    value: isSelected[i],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          isSelected[i] = val;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            label: const Text("Take Equipment"),
            selected: selectedAction == EquipmentAction.take,
            onSelected: (selected) {
              setState(() {
                selectedAction = selected ? EquipmentAction.take : EquipmentAction.none;
              });
            },
          ),
          ChoiceChip(
            label: const Text("Submit Equipment"),
            selected: selectedAction == EquipmentAction.submit,
            onSelected: (selected) {
              setState(() {
                selectedAction = selected ? EquipmentAction.submit : EquipmentAction.none;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Build the card for "Take Equipment" action.
  Widget _buildTakeEquipmentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Take Equipment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Toggle between Request and Reserve
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Request"),
                Switch(
                  value: !isRequest,
                  onChanged: (val) {
                    setState(() {
                      isRequest = !val;
                    });
                  },
                ),
                const Text("Reserve"),
              ],
            ),
            const SizedBox(height: 16),
            // From Date and To Date fields
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTakeDate(pickFromDate: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        takeFromDate == null
                            ? "From Date"
                            : "${takeFromDate!.day}/${takeFromDate!.month}/${takeFromDate!.year}",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTakeDate(pickFromDate: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        takeToDate == null
                            ? "To Date"
                            : "${takeToDate!.day}/${takeToDate!.month}/${takeToDate!.year}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Purpose field
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: "Purpose",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitTakeEquipment,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the card for "Submit Equipment" action.
  Widget _buildSubmitEquipmentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Submit Equipment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Equipment Condition field
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(
                labelText: "Equipment Condition",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Notes / Issues field
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Notes / Issues",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            // Needs Maintenance switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Needs Maintenance?",
                  style: TextStyle(fontSize: 16),
                ),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitSubmitEquipment,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
