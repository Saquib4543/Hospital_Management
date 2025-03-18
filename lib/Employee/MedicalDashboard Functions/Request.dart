import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  final List<String> scannedItems;

  const RequestPage({Key? key, required this.scannedItems}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // "Request" or "Reserve"
  bool isRequest = true; // true => "Request"; false => "Reserve"

  // Date range
  DateTime? fromDate;
  DateTime? toDate;

  // Location & Purpose
  final TextEditingController locationController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  // For item selection
  late List<String> allItems;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    // Copy scanned items
    allItems = List.from(widget.scannedItems);
    // By default, select all items
    isSelected = List.generate(allItems.length, (_) => true);
  }

  /// Toggle switch: "Request" vs. "Reserve"
  void _onSwitchChanged(bool newVal) {
    setState(() {
      // if newVal = true => isRequest = false => "Reserve"
      // if newVal = false => isRequest = true => "Request"
      isRequest = !newVal;
    });
  }

  // Mock item status
  String _getItemStatus(String barcode) {
    if (barcode.contains("1")) return "Available";
    if (barcode.contains("2")) return "In Use";
    return "Unknown";
  }

  /// Date pickers
  Future<void> _pickDate({required bool pickFromDate}) async {
    final currentDate = pickFromDate
        ? (fromDate ?? DateTime.now())
        : (toDate ?? DateTime.now().add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        if (pickFromDate) {
          fromDate = picked;
          // Adjust toDate if needed
          if (toDate == null || fromDate!.isAfter(toDate!)) {
            toDate = fromDate!.add(const Duration(days: 1));
          }
        } else {
          toDate = picked;
          // Adjust fromDate if needed
          if (fromDate == null || toDate!.isBefore(fromDate!)) {
            fromDate = toDate!.subtract(const Duration(days: 1));
          }
        }
      });
    }
  }

  /// Select / unselect all
  void _toggleSelectAll(bool selectAll) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = selectAll;
      }
    });
  }

  /// Final submit
  void _onSubmit() {
    // Gather selected items
    final selectedItems = <String>[];
    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i]) {
        selectedItems.add(allItems[i]);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Equipment Request"),
        content: Text(
          "Type: ${isRequest ? 'Request' : 'Reserve'}\n"
              "From: ${fromDate != null ? fromDate.toString().split(' ')[0] : 'N/A'}\n"
              "To:   ${toDate != null ? toDate.toString().split(' ')[0] : 'N/A'}\n"
              "Location: ${locationController.text}\n"
              "Purpose:  ${purposeController.text}\n\n"
              "Selected Items:\n  ${selectedItems.join('\n  ')}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
        title: const Text("Request / Reserve Equipment"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1) Switch for "Request" vs. "Reserve"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Request"),
                Switch(
                  value: !isRequest, // if switch is ON => Reserve
                  onChanged: _onSwitchChanged,
                ),
                const Text("Reserve"),
              ],
            ),
            const Divider(),

            // 2) Date range
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(pickFromDate: true),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        fromDate == null
                            ? "From Date"
                            : "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(pickFromDate: false),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        toDate == null
                            ? "To Date"
                            : "${toDate!.day}/${toDate!.month}/${toDate!.year}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3) Location
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 4) Purpose
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: "Purpose",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // 5) Scanned item list with statuses, all checkboxes, select all
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Items Scanned:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _toggleSelectAll(true),
                  child: const Text("Select All"),
                ),
                TextButton(
                  onPressed: () => _toggleSelectAll(false),
                  child: const Text("Unselect All"),
                ),
              ],
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: allItems.length,
                itemBuilder: (ctx, i) {
                  final item = allItems[i];
                  final status = _getItemStatus(item);
                  return CheckboxListTile(
                    title: Text(item),
                    subtitle: Text("Status: $status"),
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
            const SizedBox(height: 8),
            Text(
              "Selected: $selectedCount / ${allItems.length}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

            // 6) Submit
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
