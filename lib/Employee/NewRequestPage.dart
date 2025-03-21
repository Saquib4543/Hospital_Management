import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';

class NewRequestPage extends StatefulWidget {
  final User user;

  NewRequestPage({required this.user});

  @override
  _NewRequestPageState createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Equipment")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Equipment",
                  prefixIcon: Icon(Icons.inventory),
                ),
                items: [
                  DropdownMenuItem(value: "1", child: Text("Laptop")),
                  DropdownMenuItem(value: "2", child: Text("Projector")),
                  DropdownMenuItem(value: "3", child: Text("Monitor")),
                ],
                onChanged: (value) {
                  setState(() => selectedItem = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Purpose",
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter purpose';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Expected Return Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "Select Date",
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Submit request logic
                    Navigator.pop(context);
                  }
                },
                child: Text("Submit Request", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}