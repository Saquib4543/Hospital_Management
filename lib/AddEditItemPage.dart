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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();

  // Quantity and flag selections
  int? selectedQuantityChip;
  String? selectedFlag = "active"; // Default value

  // Predefined quantities for quick selection
  final List<int> quantityOptions = [1, 5, 10, 25, 50, 100];

  // Available flags for the item
  final List<Map<String, dynamic>> flagOptions = [
    {"value": "active", "label": "Active", "color": Colors.green},
    {"value": "discontinued", "label": "Discontinued", "color": Colors.orange},
    {"value": "critical", "label": "Critical Stock", "color": Colors.red},
    {"value": "expired", "label": "Expired", "color": Colors.grey},
  ];

  // List of all manufacturers
  final List<Manufacturer> manufacturers = [
    // Indian Manufacturers
    Manufacturer(
      id: "1",
      name: "Cipla Ltd.",
      contact: "Umang Vohra",
      email: "contact@cipla.com",
      phone: "+91 22 2482 6000",
      address: "Cipla House, Peninsula Business Park, Mumbai, Maharashtra 400013",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "2",
      name: "Sun Pharmaceutical Industries Ltd.",
      contact: "Dilip Shanghvi",
      email: "info@sunpharma.com",
      phone: "+91 22 4324 4324",
      address: "Sun House, CTS No. 201 B/1, Western Express Highway, Goregaon (E), Mumbai 400063",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "3",
      name: "Dr. Reddy's Laboratories",
      contact: "G V Prasad",
      email: "contact@drreddys.com",
      phone: "+91 40 4900 2900",
      address: "8-2-337, Road No. 3, Banjara Hills, Hyderabad, Telangana 500034",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "4",
      name: "Hindustan Syringes & Medical Devices Ltd.",
      contact: "Rajiv Nath",
      email: "info@hmdhealthcare.com",
      phone: "+91 129 4070000",
      address: "175/1 Bhai Mohan Singh Nagar, Faridabad, Haryana 121004",
      category: "Medical Devices",
    ),
    Manufacturer(
      id: "5",
      name: "Poly Medicure Ltd.",
      contact: "Himanshu Baid",
      email: "info@polymedicure.com",
      phone: "+91 120 429 2100",
      address: "Plot No. 105, 106, Sector 59, Faridabad, Haryana 121004",
      category: "Medical Devices",
    ),
    Manufacturer(
      id: "6",
      name: "Trivitron Healthcare",
      contact: "G.S.K. Velu",
      email: "info@trivitron.com",
      phone: "+91 44 6630 1000",
      address: "15, Jawaharlal Nehru Road, Ekkattuthangal, Chennai, Tamil Nadu 600032",
      category: "Medical Equipment",
    ),
    Manufacturer(
      id: "7",
      name: "BPL Medical Technologies",
      contact: "Sunil Khurana",
      email: "info@bplmedicaltechnologies.com",
      phone: "+91 80 2839 5963",
      address: "11th KM, Bannerghatta Road, Arakere, Bengaluru, Karnataka 560076",
      category: "Medical Equipment",
    ),
    Manufacturer(
      id: "8",
      name: "Transasia Bio-Medicals Ltd.",
      contact: "Suresh Vazirani",
      email: "info@transasia.co.in",
      phone: "+91 22 4040 8000",
      address: "Transasia House, 8 Chandivali Studio Road, Mumbai, Maharashtra 400072",
      category: "Diagnostics",
    ),
    Manufacturer(
      id: "9",
      name: "J Mitra & Co. Pvt. Ltd.",
      contact: "Jatin Mahajan",
      email: "info@jmitra.co.in",
      phone: "+91 11 4567 7777",
      address: "A-180, Okhla Industrial Area, Phase-1, New Delhi 110020",
      category: "Diagnostics",
    ),
    Manufacturer(
      id: "10",
      name: "Stryker India Pvt. Ltd.",
      contact: "Ram Rangarajan",
      email: "india.info@stryker.com",
      phone: "+91 124 4964 100",
      address: "8th Floor, Building 9A, DLF Cyber City, Gurgaon, Haryana 122002",
      category: "Orthopaedic Devices",
    ),
    Manufacturer(
      id: "11",
      name: "Paramount Surgimed Ltd.",
      contact: "Shaily Grover",
      email: "info@paramountsurgimed.com",
      phone: "+91 11 4567 9999",
      address: "66, Sector 25, Phase II, Faridabad, Haryana 121004",
      category: "Surgical Instruments",
    ),
    Manufacturer(
      id: "12",
      name: "Romsons Scientific & Surgical Industries Pvt. Ltd.",
      contact: "Pawan Sharma",
      email: "info@romsons.com",
      phone: "+91 120 2770 001",
      address: "51, Sector 27-C, Mathura Road, Faridabad, Haryana 121003",
      category: "Disposable Medical Supplies",
    ),
    Manufacturer(
      id: "13",
      name: "Meril Life Sciences Pvt. Ltd.",
      contact: "Sanjeev Bhatt",
      email: "info@merillife.com",
      phone: "+91 265 2646 300",
      address: "Survey No. 135/139, Bilakhia House, Muktanand Marg, Vadodara, Gujarat 390015",
      category: "Cardiovascular Devices",
    ),
    Manufacturer(
      id: "14",
      name: "Narang Medical Ltd.",
      contact: "Vijay Narang",
      email: "narang@narang.com",
      phone: "+91 11 4559 5900",
      address: "Narang Tower, 23 Rajindra Place, New Delhi 110008",
      category: "Hospital Furniture",
    ),
    Manufacturer(
      id: "15",
      name: "TTK Healthcare Ltd.",
      contact: "T T Jagannathan",
      email: "info@ttkhealthcare.com",
      phone: "+91 44 2831 0000",
      address: "No. 6, Cathedral Road, Chennai, Tamil Nadu 600086",
      category: "Reproductive Healthcare",
    ),
    // Adding new manufacturers
    Manufacturer(
      id: "16",
      name: "Medtronic India Pvt. Ltd.",
      contact: "Michael Blackwell",
      email: "info@medtronic.co.in",
      phone: "+91 22 3355 5000",
      address: "1241, Solitaire Corporate Park, Andheri (E), Mumbai, Maharashtra 400093",
      category: "Medical Devices",
      isPremium: true,
    ),
    Manufacturer(
      id: "17",
      name: "Abbott Healthcare Pvt. Ltd.",
      contact: "Ambati Venu",
      email: "customer.service@abbott.com",
      phone: "+91 22 3816 2000",
      address: "Abbott India House, Godrej BKC, Bandra (E), Mumbai, Maharashtra 400051",
      category: "Pharmaceuticals",
      isPremium: true,
    ),
    Manufacturer(
      id: "18",
      name: "GE Healthcare India",
      contact: "Shravan Subramanyam",
      email: "gecares@ge.com",
      phone: "+91 124 410 1500",
      address: "Ground Floor, Tower C, Signature Towers, South City 1, Gurugram, Haryana 122001",
      category: "Medical Equipment",
      isPremium: true,
    ),
  ];

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
    _descriptionController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _batchNumberController.dispose();
    super.dispose();
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
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item Details",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildAnimatedFormField(
                              controller: _nameController,
                              label: "Item Name*",
                              icon: Icons.inventory_2_rounded,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter item name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            _buildAnimatedFormField(
                              controller: _descriptionController,
                              label: "Description",
                              icon: Icons.description_rounded,
                              maxLines: 3,
                            ),
                            SizedBox(height: 24),
                            _buildManufacturerDropdown(),
                            SizedBox(height: 24),
                            _buildQuantitySection(),
                            SizedBox(height: 24),
                            _buildAnimatedFormField(
                              controller: _priceController,
                              label: "Price (₹)*",
                              icon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter price';
                                }
                                if (double.tryParse(value!) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAnimatedFormField(
                                    controller: _locationController,
                                    label: "Location*",
                                    icon: Icons.location_on_rounded,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildAnimatedFormField(
                                    controller: _batchNumberController,
                                    label: "Batch Number*",
                                    icon: Icons.qr_code_rounded,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter batch number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            _buildFlagSection(),
                            SizedBox(height: 32),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shopping_cart_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Quantity*",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedFormField(
                controller: _quantityController,
                label: "Custom Quantity",
                icon: Icons.edit_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if ((value?.isEmpty ?? true) && selectedQuantityChip == null) {
                    return 'Please enter or select a quantity';
                  }
                  if (value!.isNotEmpty && int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quantityOptions.map((quantity) {
            return ChoiceChip(
              label: Text(
                quantity.toString(),
                style: GoogleFonts.poppins(
                  color: selectedQuantityChip == quantity ? Colors.white : Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selectedQuantityChip == quantity,
              selectedColor: Colors.blue,
              backgroundColor: Colors.blue[50],
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedQuantityChip = quantity;
                    _quantityController.text = quantity.toString();
                  } else if (selectedQuantityChip == quantity) {
                    selectedQuantityChip = null;
                    _quantityController.text = '';
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFlagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Item Status",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: flagOptions.map((flag) {
            final Color baseColor = flag["color"] as Color;
            return ChoiceChip(
              label: Text(
                flag["label"],
                style: GoogleFonts.poppins(
                  color: selectedFlag == flag["value"] ? Colors.white : baseColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selectedFlag == flag["value"],
              selectedColor: baseColor,
              backgroundColor: baseColor.withOpacity(0.1),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedFlag = flag["value"];
                  }
                });
              },
              avatar: selectedFlag == flag["value"]
                  ? Icon(Icons.check_circle, color: Colors.white, size: 18)
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.text.isNotEmpty ? Colors.blue : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.blue),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            // If typing in quantity field, unselect any chip
            if (controller == _quantityController && selectedQuantityChip != null && value != selectedQuantityChip.toString()) {
              selectedQuantityChip = null;
            }
          });
        },
      ),
    );
  }

  Widget _buildManufacturerDropdown() {
    // Manufacturer dropdown code remains unchanged
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedManufacturer != null ? Colors.blue : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedManufacturer,
        icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue),
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Manufacturer*",
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.factory_rounded, color: Colors.blue),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: manufacturers.map((manufacturer) {
          return DropdownMenuItem(
            value: manufacturer.id,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    manufacturer.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (manufacturer.isPremium == true) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Premium",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => selectedManufacturer = value);

          // Show manufacturer details in a bottom sheet when selected
          if (value != null) {
            final selectedMfr = manufacturers.firstWhere((m) => m.id == value);
            _showManufacturerDetails(selectedMfr);
          }
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a manufacturer';
          }
          return null;
        },
      ),
    );
  }

  void _showManufacturerDetails(Manufacturer manufacturer) {
    // Manufacturer details code remains unchanged
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  radius: 24,
                  child: Text(
                    manufacturer.name.substring(0, 1),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              manufacturer.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (manufacturer.isPremium == true) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Premium",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        manufacturer.category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildInfoRow(Icons.person, "Contact Person", manufacturer.contact),
            _buildInfoRow(Icons.email, "Email", manufacturer.email),
            _buildInfoRow(Icons.phone, "Phone", manufacturer.phone),
            _buildInfoRow(Icons.location_on, "Address", manufacturer.address),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    // Info row code remains unchanged
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Prepare the API payload
            Map<String, dynamic> requestBody = {
              "item_name": _nameController.text.trim(),
              "category": _descriptionController.text.trim(),
              "uom_id": "2", // Assuming this is a fixed value
              "price": _priceController.text.trim(),
              "manufacturer": selectedManufacturer ?? "Unknown",
              "batch_number": _batchNumberController.text.trim(),
              "remaining_life": "unlimited",
              "active_flag": selectedFlag ?? "active",
              "usage": _descriptionController.text.trim(),
              "location": _locationController.text.trim(),
              "quantity": int.tryParse(_quantityController.text.trim()) ?? 0,
            };

            try {
              var response = await http.post(
                Uri.parse("https://uat.goclaims.in/inventory_hub/items"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(requestBody),
              );

              Navigator.pop(context); // Close loading dialog

              if (response.statusCode == 200 || response.statusCode == 201) {
                // Show success animation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Item Added Successfully!",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context); // Go back after success
                        },
                        child: Text(
                          "Done",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to add item: ${response.body}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Save Item",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Manufacturer model class
class Manufacturer {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String phone;
  final String address;
  final String category;
  final bool isPremium;

  Manufacturer({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.phone,
    required this.address,
    required this.category,
    this.isPremium = false,
  });
}

class EditItemPage extends StatefulWidget {
  final int itemId;

  const EditItemPage({required this.itemId, Key? key}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _locationController;
  String? selectedManufacturer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController();
    _locationController = TextEditingController();
    _fetchItemDetails();
  }

  Future<void> _fetchItemDetails() async {
    final url = Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nameController.text = data['name'];
          _descriptionController.text = data['description'];
          _quantityController.text = data['quantity'].toString();
          _locationController.text = data['location'];
          selectedManufacturer = data['manufacturerId'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load item details');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching item details: $e')),
      );
    }
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}');
    final body = jsonEncode({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'quantity': int.parse(_quantityController.text),
      'location': _locationController.text,
      'manufacturerId': selectedManufacturer,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to update item');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Item')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty || int.tryParse(value) == null ? 'Enter valid quantity' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateItem,
                child: Text('Update Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
