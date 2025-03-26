// Create a new SubcategoryListPage.dart file:

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io' show File;

import 'package:url_launcher/url_launcher.dart';


class CategoryDetailsPage extends StatefulWidget {
  final int categoryId;

  const CategoryDetailsPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final String apiUrl = "https://uat.goclaims.in/inventory_hub/itemdetails";

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  List<CategoryDetail> categoryDetails = [];
  TextEditingController searchController = TextEditingController();
  List<CategoryDetail> filteredDetails = [];

  final String addItemApiUrl = "https://uat.goclaims.in/inventory_hub/itemdetails";
  List<Map<String, dynamic>> locations = []; // Will store location data for dropdown
  bool isLoadingLocations = false;
  TextEditingController descriptionController = TextEditingController();
  int? selectedLocationId = null;
  final String createdBy = "tauheed"; // Static value as requested


  @override
  void initState() {
    super.initState();
    _loadCategoryDetails();
    searchController.addListener(_filterDetails);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  Future<void> _loadLocations() async {
    setState(() {
      isLoadingLocations = true;
    });

    try {
      final response = await http.get(Uri.parse('https://uat.goclaims.in/inventory_hub/locations'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          locations = data.map((item) {
            return {
              'id': item['id'],
              'name': item['location_name'],
              'status': item['location_status'],
            };
          }).toList();

          // Automatically select the first location if available
          if (locations.isNotEmpty) {
            selectedLocationId = locations.first['id'];
          }

          isLoadingLocations = false;
        });
      } else {
        throw Exception("Failed to load locations");
      }
    } catch (e) {
      setState(() {
        isLoadingLocations = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading locations: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addNewItem() async {
    if (selectedLocationId == null) {
      _showErrorSnackBar("Please select a location");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter a description");
      return;
    }

    _showLoadingSnackBar("Adding new item...");

    try {
      final Map<String, dynamic> itemData = {
        "item_id": widget.categoryId.toString(), // From previous screen
        "location_id": selectedLocationId,  // Ensure selectedLocationId is set
        "description": descriptionController.text.trim(),
        "created_by": createdBy
      };

      final response = await http.post(
        Uri.parse(addItemApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(itemData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackBar("Item added successfully");

        // Clear form after successful addition
        descriptionController.clear();
        selectedLocationId = locations.isNotEmpty ? locations.first['id'] : null;

        // Reload data
        _loadCategoryDetails();
        Navigator.pop(context); // Close the dialog/modal
      } else {
        throw Exception("Failed to add item. Status code: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackBar("Failed to add item: $e");
    }
  }

// Add this method to show the add item form
  void _showAddItemForm() {
    // Clear form state
    descriptionController.clear();
    selectedLocationId = locations.isNotEmpty ? locations.first['id'] : null;

    // Preload locations if needed
    if (locations.isEmpty) {
      _loadLocations();
    }

    // Get keyboard height to adjust bottom padding
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + keyboardPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Draggable indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Form header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Add New Item",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            )
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey.shade700),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    Divider(height: 32),

                    // Location Dropdown
                    Text(
                        "Location",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: isLoadingLocations
                          ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      )
                          : locations.isEmpty
                          ? Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber.shade700),
                            SizedBox(width: 8),
                            Text("No locations available", style: TextStyle(color: Colors.amber.shade900)),
                          ],
                        ),
                      )
                          : DropdownButtonFormField<int>(
                        value: selectedLocationId,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor.withOpacity(0.7),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          hintText: "Select a location",
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        items: locations.map((location) {
                          return DropdownMenuItem<int>(
                            value: location['id'],
                            child: Row(
                              children: [
                                Text(location['name']),
                                SizedBox(width: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: location['status'] == 'Active'
                                        ? Colors.green.shade50
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    location['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: location['status'] == 'Active'
                                          ? Colors.green.shade700
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedLocationId = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Description Input
                    Row(
                      children: [
                        Text(
                            "Description",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            )
                        ),
                        Text(" *", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter item description",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
                        ),
                        contentPadding: EdgeInsets.all(16),
                        counterText: "${descriptionController.text.length}/200",
                      ),
                      maxLength: 200,
                      onChanged: (text) {
                        setModalState(() {}); // Update counter
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a description'),
                                backgroundColor: Colors.red.shade400,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          _addNewItem();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text(
                                "Add Item",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _filterDetails() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDetails = categoryDetails.where((detail) {
        return detail.description.toLowerCase().contains(query) ||
            detail.createdBy.toLowerCase().contains(query) ||
            detail.itemId.toString().contains(query) ||
            detail.activeFlag.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadCategoryDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        categoryDetails = jsonData
            .map((detail) => CategoryDetail.fromJson(detail))
            .where((detail) => detail.itemId == widget.categoryId)
            .toList();

        filteredDetails = List.from(categoryDetails);

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load category details (status: ${response.statusCode})");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _downloadQRCode(String base64Image) async {
    try {
      // Convert Base64 string to bytes
      Uint8List bytes = base64Decode(base64Image);

      // Get storage directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/QRCode.png';

      // Save the image file
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("QR Code saved to $filePath")),
      );

      // Optional: Allow user to share/download it
      // await Share.shareFiles([filePath], text: "Here is your QR Code");

    } catch (e) {
      debugPrint("Error saving QR code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download QR Code")),
      );
    }
  }
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 3),
      ),
    );
  }
  String _getModifiedQrUrl(String originalUrl) {
    if (originalUrl.contains("response-content-disposition")) {
      return originalUrl;  // If already modified, return as is
    }
    return "$originalUrl&response-content-disposition=inline";
  }


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Uint8List _base64ToImage(String base64String) {
    return base64Decode(base64String);
  }


  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(12),
      ),
    );
  }

  // Helper method to get the base64 string regardless of type
  String _getQrImageString(dynamic qrImage) {
    if (qrImage is List) {
      return qrImage.isNotEmpty ? qrImage[0] : "";
    } else if (qrImage is String) {
      return qrImage;
    }
    return "";
  }

// For the Image.memory widget:


  void _viewFullDetails(CategoryDetail detail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item Details",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey.shade100),
                        shape: MaterialStateProperty.all(CircleBorder()),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6),
                Text(
                  "Complete information about this item",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                Divider(height: 30),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Basic Information",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDetailItem("Item ID", detail.itemId.toString(), leadingIcon: Icons.tag),
                      _buildDetailItem("Description", detail.description, leadingIcon: Icons.description),
                      _buildDetailItem("Status", detail.activeFlag,
                          valueColor: detail.activeFlag.toLowerCase() == "active" ? Colors.green : Colors.red,
                          leadingIcon: Icons.circle,
                          leadingIconColor: detail.activeFlag.toLowerCase() == "active" ? Colors.green : Colors.red),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Additional Information",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDetailItem("Created By", detail.createdBy, leadingIcon: Icons.person),
                      _buildDetailItem("Issuance Status", detail.issuanceStatus, leadingIcon: Icons.assignment_turned_in),
                      _buildDetailItem("Request Number", detail.requestNumber, leadingIcon: Icons.numbers),
                      _buildDetailItem("Reference ID", detail.refId, leadingIcon: Icons.bookmark),
                    ],
                  ),
                ),

                if (detail.qrImage.isNotEmpty) ...[
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Theme.of(context).primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.qr_code_2, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Text(
                              "QR Code",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _base64ToImage(_getQrImageString(detail.qrImage)),
                                  height: 220,
                                  width: 220,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 220,
                                      width: 220,
                                      color: Colors.grey.shade200,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey.shade400,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Scan with any QR code reader",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _downloadQRCode(_getModifiedQrUrl(detail.qrImage[0])),  // ✅ Download modified URL
                          icon: Icon(Icons.download),
                          label: Text(
                            "Download QR Code",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewQRCode(String base64Image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code_2, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          "QR Code",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(28),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _base64ToImage(_getQrImageString(base64Image)),
                        height: 220,
                        width: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            width: 220,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Close",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _downloadQRCode(base64Image);
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.download),
                            label: Text(
                              "Download",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor, IconData? leadingIcon, Color? leadingIconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: 18,
              color: leadingIconColor ?? Colors.grey.shade700,
            ),
            SizedBox(width: 12),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: valueColor ?? Colors.grey.shade800,
                fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Category Details",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddItemForm,
            tooltip: "Add New Item",
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadCategoryDetails,
            tooltip: "Refresh Data",
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingView()
          : hasError
          ? _buildErrorView()
          : categoryDetails.isEmpty
          ? _buildEmptyView()
          : _buildDataView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Loading category details...",
            style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please wait while we fetch the data",
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataView() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.category_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Category Items",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${categoryDetails.length}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search items...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade600),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredDetails.isEmpty
              ? _buildNoSearchResultsView()
              : _buildDataTableView(),
        ),
      ],
    );
  }

  Widget _buildNoSearchResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "No matching items found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try adjusting your search criteria",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 20),
          TextButton.icon(
            onPressed: () {
              searchController.clear();
            },
            icon: Icon(Icons.clear),
            label: Text(
              "Clear Search",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTableView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SingleChildScrollView(
    child: DataTable(
    columnSpacing: 24,
    horizontalMargin: 16,
    headingRowColor: MaterialStateProperty.all(
    Theme.of(context).primaryColor.withOpacity(0.05),
    ),
    headingRowHeight: 56,
    dataRowHeight: 64,
    dividerThickness: 0.5,
    showCheckboxColumn: false,
    decoration: BoxDecoration(
    border: Border(
    bottom: BorderSide(
    color: Colors.grey.shade200,
    width: 0.5,
    ),
    ),
    ),
    columns: [
    DataColumn(
    label: Row(
    children: [
    Icon(Icons.tag, size: 16, color: Theme.of(context).primaryColor),
    SizedBox(width: 8),
    Text(
    "ID",
    style: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade800,
    ),
    ),
    ],
    ),
    ),
    DataColumn(
    label: Row(
    children: [
    Icon(Icons.description, size: 16, color: Theme.of(context).primaryColor),
    SizedBox(width: 8),
    Text(
    "Description",
    style: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade800,
    ),
    ),
    ],
    ),
    ),
    DataColumn(
    label: Row(
    children: [
      Icon(Icons.circle, size: 16, color: Theme.of(context).primaryColor),
      SizedBox(width: 8),
      Text(
        "Status",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    ],
    ),
    ),
      DataColumn(
        label: Row(
          children: [
            Icon(Icons.qr_code, size: 16, color: Theme.of(context).primaryColor),
            SizedBox(width: 8),
            Text(
              "QR Code",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
      DataColumn(
        label: Row(
          children: [
            Icon(Icons.more_horiz, size: 16, color: Theme.of(context).primaryColor),
            SizedBox(width: 8),
            Text(
              "Actions",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    ],
      rows: List.generate(
        filteredDetails.length,
            (index) {
          final detail = filteredDetails[index];
          return DataRow(
            onSelectChanged: (_) => _viewFullDetails(detail),
            cells: [
              DataCell(
                Text(
                  detail.itemId.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              DataCell(
                Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    detail.description,
                    style: GoogleFonts.poppins(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: detail.activeFlag.toLowerCase() == "active"
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    detail.activeFlag,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: detail.activeFlag.toLowerCase() == "active"
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                detail.qrImage.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.qr_code_2),
                  onPressed: () => _viewQRCode(_getQrImageString(detail.qrImage)), // ✅ Pass single QR string
                  color: Theme.of(context).primaryColor,
                  tooltip: "View QR Code",
                )
                    : Text(
                  "No QR Code",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () => _viewFullDetails(detail),
                      color: Theme.of(context).primaryColor,
                      tooltip: "View Details",
                    ),
                    if (detail.qrImage.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () => _downloadQRCode(detail.qrImage[0]),
                        color: Colors.blue.shade700,
                        tooltip: "Download QR Code",
                      ),
                  ],
                ),
              ),
            ],
          );
        },
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

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.shade400,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Error Loading Data",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadCategoryDetails,
            icon: Icon(Icons.refresh),
            label: Text(
              "Try Again",
              style: GoogleFonts.poppins(),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "No Items Found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "There are no items in this category",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadCategoryDetails,
            icon: Icon(Icons.refresh),
            label: Text(
              "Refresh",
              style: GoogleFonts.poppins(),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

    class CategoryDetail {
  final String activeFlag;
  final String createdBy;
  final String description;
  final String? fromDate;
  final String issuanceStatus;
  final int itemId;
  final String locationId;
  final String qrId;
  final List<String> qrImage; // Changed from String to List<String>
  final String refId;
  final String requestNumber;
  final String? toDate;

  CategoryDetail({
    required this.activeFlag,
    required this.createdBy,
    required this.description,
    this.fromDate,
    required this.issuanceStatus,
    required this.itemId,
    required this.locationId,
    required this.qrId,
    required this.qrImage, // Changed from String to List<String>
    required this.refId,
    required this.requestNumber,
    this.toDate,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      activeFlag: json['active_flag'] ?? '',
      createdBy: json['created_by'] ?? '',
      description: json['description'] ?? '',
      fromDate: json['from_date'],
      issuanceStatus: json['issuance_status'] ?? '',
      itemId: json['item_id'] is int ? json['item_id'] : int.tryParse(json['item_id'].toString()) ?? 0,
      locationId: json['location_id'] ?? '',
      qrId: json['qr_id'] ?? '',
      qrImage: json['qr_image'] is List
          ? List<String>.from(json['qr_image'])
          : json['qr_image'] != null
          ? [json['qr_image'].toString()]
          : [], // Handle both list and single string values
      refId: json['ref_id'] ?? '',
      requestNumber: json['request_number'] ?? '',
      toDate: json['to_date'],
    );
  }
}



