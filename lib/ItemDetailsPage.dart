import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ItemDetailsPage extends StatefulWidget {
  final String itemId;

  const ItemDetailsPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  Map<String, dynamic>? item;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
    });

    final url = Uri.parse("https://uat.goclaims.in/inventory_hub/items/${widget.itemId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          final decodedData = json.decode(response.body);
          print("API Response: $decodedData");

          setState(() {
            item = decodedData;
            isLoading = false;
          });
        } catch (e) {
          print("JSON decode error: $e");
          setState(() {
            hasError = true;
            errorMessage = "Invalid response format";
            isLoading = false;
          });
        }
      } else {
        print("Error status code: ${response.statusCode}");
        print("Error response: ${response.body}");
        setState(() {
          hasError = true;
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Network exception: $e");
      setState(() {
        hasError = true;
        errorMessage = "Network error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  String getSafeValue(dynamic value) {
    if (value == null) return "N/A";
    return value.toString();
  }

  String getStatusText(dynamic value) {
    if (value == null) return "Unknown";
    if (value is bool) {
      return value ? "Active" : "Inactive";
    }
    if (value.toString().toLowerCase() == "true") return "Active";
    if (value.toString().toLowerCase() == "false") return "Inactive";
    return value.toString();
  }

  Color getStatusColor(dynamic value) {
    String status = getStatusText(value).toLowerCase();
    if (status == "active") return Colors.green;
    if (status == "inactive") return Colors.red;
    return Colors.orange;
  }

  String formatPrice(dynamic price) {
    if (price == null) return "N/A";
    try {
      double numPrice = double.parse(price.toString());
      return currencyFormat.format(numPrice);
    } catch (e) {
      return "₹${price.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          item?["item_name"]?.toString() ?? "Item Details",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {
              // Share functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share functionality not implemented yet")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              // More options menu would go here
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_outlined, color: Colors.blue),
                        title: Text('Edit Item', style: GoogleFonts.poppins()),
                        onTap: () {
                          Navigator.pop(context);
                          // Edit logic would go here
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('Delete Item', style: GoogleFonts.poppins()),
                        onTap: () {
                          Navigator.pop(context);
                          // Delete logic would go here
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history, color: Colors.purple),
                        title: Text('View History', style: GoogleFonts.poppins()),
                        onTap: () {
                          Navigator.pop(context);
                          // History logic would go here
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      )
          : hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage ?? "Failed to load item details",
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text("Retry", style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: fetchItemDetails,
            )
          ],
        ),
      )
          : item == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No item data found",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : buildItemDetails(),
      floatingActionButton: !isLoading && !hasError && item != null
          ? FloatingActionButton.extended(
        onPressed: () {
          // Action for updating item status
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Status update functionality not implemented yet")),
          );
        },
        icon: const Icon(Icons.update),
        label: Text("Update Status", style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue,
      )
          : null,
    );
  }

  Widget buildItemDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with QR Code and basic info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSafeValue(item!["item_name"]),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getStatusColor(item!["active_flag"]).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: getStatusColor(item!["active_flag"]),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: getStatusColor(item!["active_flag"]),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      getStatusText(item!["active_flag"]),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: getStatusColor(item!["active_flag"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "ID: ${getSafeValue(item!["item_id"])}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            formatPrice(item!["price"]),
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: jsonEncode(item),
                              width: 100,
                              height: 100,
                              color: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Scan QR",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ITEM SUMMARY",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        "Category",
                        getSafeValue(item!["category"]),
                        Icons.category_outlined,
                        Colors.blue[700]!,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        "Batch",
                        getSafeValue(item!["batch_number"]),
                        Icons.production_quantity_limits_outlined,
                        Colors.purple[700]!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        "Remaining Life",
                        getSafeValue(item!["remaining_life"]),
                        Icons.timer_outlined,
                        Colors.orange[700]!,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        "Usage",
                        getSafeValue(item!["usage"]),
                        Icons.analytics_outlined,
                        Colors.green[700]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Detailed Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DETAILED INFORMATION",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                buildInfoCard("Manufacturer", getSafeValue(item!["manufacturer"]), Icons.factory_outlined),
                const SizedBox(height: 12),
                buildInfoCard("Item ID", getSafeValue(item!["item_id"]), Icons.tag_outlined),
                const SizedBox(height: 12),
                buildInfoCard("Batch Number", getSafeValue(item!["batch_number"]), Icons.numbers_outlined),
                const SizedBox(height: 12),
                buildInfoCard("Category", getSafeValue(item!["category"]), Icons.category_outlined),
                const SizedBox(height: 12),
                buildInfoCard("Price", formatPrice(item!["price"]), Icons.attach_money_outlined),
                const SizedBox(height: 12),
                buildInfoCard("Status", getStatusText(item!["active_flag"]), Icons.flag_outlined),

                // Add any additional fields from the API here
                if (item!.containsKey("purchase_date"))
                  const SizedBox(height: 12),
                if (item!.containsKey("purchase_date"))
                  buildInfoCard("Purchase Date", getSafeValue(item!["purchase_date"]), Icons.calendar_today_outlined),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // QR Code for all data
          Center(
            child: Column(
              children: [
                Text(
                  "COMPLETE ITEM DATA",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: jsonEncode(item),
                    width: 180,
                    height: 180,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                    drawText: false,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Scan to export all item data",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
