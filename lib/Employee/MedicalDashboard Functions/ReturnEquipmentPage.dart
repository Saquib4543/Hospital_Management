import 'package:flutter/material.dart';
import 'package:hospital_inventory_management/main.dart';
import 'package:hospital_inventory_management/Employee/Pages/Camera_In_Controller.dart';

import '../../models/user_model.dart';

class ReturnMedicalEquipmentPage extends StatefulWidget {
  final User user;

  const ReturnMedicalEquipmentPage({Key? key, required this.user})
      : super(key: key);

  @override
  _ReturnMedicalEquipmentPageState createState() =>
      _ReturnMedicalEquipmentPageState();
}

class _ReturnMedicalEquipmentPageState
    extends State<ReturnMedicalEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEquipment;
  String _condition = 'Excellent';
  String _notes = '';
  bool _needsMaintenance = false;

  // OPTIONAL: to store the scanned barcode
  String? _scannedBarcodeData;

  List<Map<String, dynamic>> _borrowedEquipment = [
    {
      'id': '001',
      'name': 'Portable Ultrasound',
      'dueDate': 'Tomorrow, 9:00 AM',
      'location': 'Operating Room 3',
    },
    {
      'id': '002',
      'name': 'Infusion Pump',
      'dueDate': 'February 26, 2:00 PM',
      'location': 'ICU Room 202',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Medical Equipment"),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFFF5F5F5)],
            stops: [0.0, 0.1],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) SCAN EQUIPMENT BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      final scannedResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraInController(),
                        ),
                      );
                      if (scannedResult != null) {
                        setState(() {
                          _scannedBarcodeData = scannedResult.toString();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Scanned: $_scannedBarcodeData"),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text("Scan Equipment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 2) SELECT EQUIPMENT TO RETURN CARD
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Equipment to Return",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          SizedBox(height: 16),
                          ..._borrowedEquipment.map(
                                (equipment) =>
                                _buildEquipmentSelectionCard(equipment),
                          ).toList(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 3) RETURN DETAILS CARD
                  if (_selectedEquipment != null) ...[
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Return Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Equipment Condition
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Equipment Condition',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon:
                                Icon(Icons.health_and_safety_outlined),
                              ),
                              value: _condition,
                              items: ['Excellent', 'Good', 'Fair', 'Poor']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _condition = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 16),

                            // Notes / Issues
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Notes / Issues',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.note_alt_outlined),
                              ),
                              maxLines: 3,
                              onChanged: (value) {
                                _notes = value;
                              },
                            ),
                            SizedBox(height: 16),

                            // Needs Maintenance switch
                            SwitchListTile(
                              title: Text(
                                "Needs Maintenance",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "Mark if equipment requires service",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: _needsMaintenance,
                              activeColor: Color(0xFF2E7D32),
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onChanged: (bool value) {
                                setState(() {
                                  _needsMaintenance = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // 4) CONFIRM RETURN BUTTON
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Submit form
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Confirm Return",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This builds each borrowed equipment item (radio selection).
  Widget _buildEquipmentSelectionCard(Map<String, dynamic> equipment) {
    bool isSelected = _selectedEquipment == equipment['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEquipment = equipment['id'];
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            isSelected ? Color(0xFF2E7D32) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: equipment['id'],
              groupValue: _selectedEquipment,
              onChanged: (value) {
                setState(() {
                  _selectedEquipment = value as String;
                });
              },
              activeColor: Color(0xFF2E7D32),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Due: ${equipment['dueDate']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        equipment['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.medical_services_outlined,
              color: Color(0xFF2E7D32),
            ),
          ],
        ),
      ),
    );
  }
}
