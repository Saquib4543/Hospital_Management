// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'main.dart';
//
// class AddItemPage extends StatefulWidget {
//   @override
//   _AddItemPageState createState() => _AddItemPageState();
// }
//
// class _AddItemPageState extends State<AddItemPage> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   String? selectedManufacturer;
//   String? selectedActiveFlag;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   // Form field controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _quantityController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           "Add New Item",
//           style: GoogleFonts.poppins(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Item Details",
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 24),
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.all(24),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             _buildAnimatedFormField(
//                               controller: _nameController,
//                               label: "Item Name",
//                               icon: Icons.inventory_2_rounded,
//                               validator: (value) {
//                                 if (value?.isEmpty ?? true) {
//                                   return 'Please enter item name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 24),
//                             _buildAnimatedFormField(
//                               controller: _descriptionController,
//                               label: "Description",
//                               icon: Icons.description_rounded,
//                               maxLines: 3,
//                             ),
//                             SizedBox(height: 24),
//                             _buildManufacturerDropdown(),
//                             SizedBox(height: 24),
//                             _buildAnimatedFormField(
//                               controller: _quantityController,
//                               label: "Quantity",
//                               icon: Icons.shopping_cart_rounded,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value?.isEmpty ?? true) {
//                                   return 'Please enter quantity';
//                                 }
//                                 if (int.tryParse(value!) == null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 24),
//                             _buildAnimatedFormField(
//                               controller: _locationController,
//                               label: "Location",
//                               icon: Icons.location_on_rounded,
//                               validator: (value) {
//                                 if (value?.isEmpty ?? true) {
//                                   return 'Please enter location';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 32),
//                             _buildSaveButton(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int? maxLines,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: controller.text.isNotEmpty ? Colors.blue : Colors.grey[300]!,
//           width: 1.5,
//         ),
//       ),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines ?? 1,
//         keyboardType: keyboardType,
//         validator: validator,
//         style: GoogleFonts.poppins(
//           fontSize: 16,
//           color: Colors.black87,
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.poppins(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//           prefixIcon: Icon(icon, color: Colors.blue),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         onChanged: (value) => setState(() {}),
//       ),
//     );
//   }
//
//   Widget _buildManufacturerDropdown() {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: selectedManufacturer != null ? Colors.blue : Colors.grey[300]!,
//           width: 1.5,
//         ),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: selectedManufacturer,
//         icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue),
//         decoration: InputDecoration(
//           labelText: "Manufacturer",
//           labelStyle: GoogleFonts.poppins(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//           prefixIcon: Icon(Icons.factory_rounded, color: Colors.blue),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         items: [
//           DropdownMenuItem(
//             value: "1",
//             child: Row(
//               children: [
//                 Text(
//                   "Manufacturer A",
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.green[50],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     "Premium",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.green,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           DropdownMenuItem(
//             value: "2",
//             child: Text(
//               "Manufacturer B",
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//         onChanged: (value) {
//           setState(() => selectedManufacturer = value);
//         },
//         validator: (value) {
//           if (value == null) {
//             return 'Please select a manufacturer';
//           }
//           return null;
//         },
//       ),
//     );
//   }
//
//   Widget _buildSaveButton() {
//     return Container(
//       height: 56,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         onPressed: () async {
//           if (_formKey.currentState?.validate() ?? false) {
//             // Show loading dialog
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) => Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//
//             // Prepare the API payload
//             Map<String, dynamic> requestBody = {
//               "item_name": _nameController.text.trim(),
//               "category": _descriptionController.text.trim(),
//               "uom_id": "2", // Assuming this is a fixed value
//               "price": "98", // You may want to add a field for price input
//               "manufacturer": selectedManufacturer ?? "Unknown",
//               "batch_number": "BATCH1", // You might want to input this dynamically
//               "remaining_life": "unlimited",
//               "active_flag": "active",
//               "usage": _descriptionController.text.trim(),
//             };
//
//             try {
//               var response = await http.post(
//                 Uri.parse("https://uat.goclaims.in/inventory_hub/items"),
//                 headers: {"Content-Type": "application/json"},
//                 body: jsonEncode(requestBody),
//               );
//
//               Navigator.pop(context); // Close loading dialog
//
//               if (response.statusCode == 200 || response.statusCode == 201) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Item added successfully!")),
//                 );
//                 Navigator.pop(context); // Go back after success
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Failed to add item: ${response.body}")),
//                 );
//               }
//             } catch (e) {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Error: $e")),
//               );
//             }
//           }
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.save_rounded, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               "Save Item",
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class EditItemPage extends StatefulWidget {
//   final int itemId;
//
//   const EditItemPage({required this.itemId, Key? key}) : super(key: key);
//
//   @override
//   _EditItemPageState createState() => _EditItemPageState();
// }
//
// class _EditItemPageState extends State<EditItemPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _quantityController;
//   late TextEditingController _locationController;
//   String? selectedManufacturer;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _quantityController = TextEditingController();
//     _locationController = TextEditingController();
//     _fetchItemDetails();
//   }
//
//   Future<void> _fetchItemDetails() async {
//     final url = Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _nameController.text = data['name'];
//           _descriptionController.text = data['description'];
//           _quantityController.text = data['quantity'].toString();
//           _locationController.text = data['location'];
//           selectedManufacturer = data['manufacturerId'];
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load item details');
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching item details: $e')),
//       );
//     }
//   }
//
//   Future<void> _updateItem() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final url = Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}');
//     final body = jsonEncode({
//       'name': _nameController.text,
//       'description': _descriptionController.text,
//       'quantity': int.parse(_quantityController.text),
//       'location': _locationController.text,
//       'manufacturerId': selectedManufacturer,
//     });
//
//     try {
//       final response = await http.put(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Item updated successfully')),
//         );
//         Navigator.pop(context, true);
//       } else {
//         throw Exception('Failed to update item');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating item: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Item')),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) => value!.isEmpty ? 'Enter name' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: InputDecoration(labelText: 'Quantity'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                 value!.isEmpty || int.tryParse(value) == null ? 'Enter valid quantity' : null,
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateItem,
//                 child: Text('Update Item'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? selectedManufacturer;
  String? selectedActiveFlag;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _uomController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  final TextEditingController _remainingLifeController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _uomController.dispose();
    _priceController.dispose();
    _batchNumberController.dispose();
    _remainingLifeController.dispose();
    _usageController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: Colors.blue),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged, IconData icon) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: Colors.blue),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Future<void> _submitItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      Map<String, dynamic> requestBody = {
        "item_name": _nameController.text.trim(),
        "category": _categoryController.text.trim(),
        "uom_id": _uomController.text.trim(),
        "price": _priceController.text.trim(),
        "manufacturer": selectedManufacturer ?? "Unknown",
        "batch_number": _batchNumberController.text.trim(),
        "remaining_life": _remainingLifeController.text.trim(),
        "active_flag": selectedActiveFlag ?? "active",
        "usage": _usageController.text.trim(),
      };

      try {
        var response = await http.post(
          Uri.parse("https://uat.goclaims.in/inventory_hub/items"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        Navigator.pop(context);

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Item added successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add item: ${response.body}")),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add New Item",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Details",
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  _buildDropdown("Active Flag", ["active", "inactive"], selectedActiveFlag, (value) => setState(() => selectedActiveFlag = value), Icons.toggle_on),
                  SizedBox(height: 16),
                  _buildDropdown("Manufacturer", ["Manufacturer A", "Manufacturer B"], selectedManufacturer, (value) => setState(() => selectedManufacturer = value), Icons.factory),
                  SizedBox(height: 16),
                  _buildTextField("Item Name", _nameController, Icons.inventory),
                  SizedBox(height: 16),
                  _buildTextField("Category", _categoryController, Icons.category),
                  SizedBox(height: 16),
                  _buildTextField("UOM ID", _uomController, Icons.code),
                  SizedBox(height: 16),
                  _buildTextField("Price", _priceController, Icons.attach_money),
                  SizedBox(height: 16),
                  _buildTextField("Batch Number", _batchNumberController, Icons.confirmation_number),
                  SizedBox(height: 16),
                  _buildTextField("Remaining Life", _remainingLifeController, Icons.timer),
                  SizedBox(height: 16),
                  _buildTextField("Usage", _usageController, Icons.history),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submitItem(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Save Item",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

