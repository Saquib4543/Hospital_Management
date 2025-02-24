import 'package:flutter/material.dart';

import 'main.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedManufacturer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Item")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Item Name",
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Manufacturer",
                  prefixIcon: Icon(Icons.factory),
                ),
                value: selectedManufacturer,
                items: [
                  DropdownMenuItem(value: "1", child: Text("Manufacturer A")),
                  DropdownMenuItem(value: "2", child: Text("Manufacturer B")),
                ],
                onChanged: (value) {
                  setState(() => selectedManufacturer = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a manufacturer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Quantity",
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter location';
                  }
                  return null;
                },
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
                    // Save item logic here
                    Navigator.pop(context);
                  }
                },
                child: Text("Save Item", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EditItemPage extends StatefulWidget {
  final Item item;

  EditItemPage({required this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late String? selectedManufacturer;

  @override
  void initState() {
    super.initState();
    selectedManufacturer = widget.item.manufacturerId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.item.name}"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: widget.item.name,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.item.description,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Manufacturer",
                  prefixIcon: Icon(Icons.factory),
                ),
                value: selectedManufacturer,
                items: [
                  DropdownMenuItem(value: "1", child: Text("Manufacturer A")),
                  DropdownMenuItem(value: "2", child: Text("Manufacturer B")),
                ],
                onChanged: (value) {
                  setState(() => selectedManufacturer = value);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.item.quantity.toString(),
                decoration: InputDecoration(
                  labelText: "Quantity",
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.item.location,
                decoration: InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter location';
                  }
                  return null;
                },
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
                    // Update item logic here
                    Navigator.pop(context);
                  }
                },
                child: Text("Update Item", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Are you sure you want to delete ${widget.item.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Delete item logic here
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to list
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}