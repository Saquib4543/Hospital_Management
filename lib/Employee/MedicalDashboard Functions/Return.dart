import 'package:flutter/material.dart';

class ReturnPage extends StatefulWidget {
  final List<String> scannedItems;

  const ReturnPage({Key? key, required this.scannedItems}) : super(key: key);

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  /// The full list of items scanned from CameraInController
  late List<String> allItems;

  /// Whether each item is selected for return
  late List<bool> isSelected;

  /// Text fields for equipment condition & notes
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  /// Slider (switch) for "Needs Maintenance" – default is off (false)
  bool needsMaintenance = false;

  @override
  void initState() {
    super.initState();
    // Copy the scanned items into our local list
    allItems = List.from(widget.scannedItems);

    // By default, select all items
    isSelected = List.generate(allItems.length, (_) => true);
  }

  /// Helper to select or unselect all items
  void _toggleSelectAll(bool selectAll) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = selectAll;
      }
    });
  }

  /// Called when the user confirms the return
  void _confirmReturn() {
    // Gather only the items that are selected
    final List<String> selectedItems = [];
    for (int i = 0; i < allItems.length; i++) {
      if (isSelected[i]) {
        selectedItems.add(allItems[i]);
      }
    }

    // Show a simple dialog with the final return info
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Return Equipment"),
        content: Text(
          "Condition: ${conditionController.text}\n"
              "Notes / Issues: ${notesController.text}\n"
              "Needs Maintenance: $needsMaintenance\n\n"
              "Selected for Return:\n  ${selectedItems.join('\n  ')}",
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
    // Number of items currently selected
    final int selectedCount = isSelected.where((b) => b).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Return Equipment"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Equipment List with checkboxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Items to Return:",
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
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  return CheckboxListTile(
                    title: Text(item),
                    value: isSelected[index],
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        isSelected[index] = val;
                      });
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

            const SizedBox(height: 16),

            // 2) Equipment Condition
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(
                labelText: "Equipment Condition",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 3) Notes / Issues
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Notes / Issues",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // 4) Needs Maintenance switch (slider)
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
            // 5) Confirm Return button
            ElevatedButton(
              onPressed: _confirmReturn,
              child: const Text("Confirm Return"),
            ),
          ],
        ),
      ),
    );
  }
}
