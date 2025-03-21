import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_inventory_management/updateItem.dart';
import 'package:http/http.dart' as http;
import 'AddEditItemPage.dart';
import 'ItemDetailsPage.dart';
import 'ItemSearchDelegate.dart';
import 'SubCategory.dart';

class Item {
  final int id;
  final String name;
  final String category;
  final String manufacturer;
  final String batchNumber;
  final String usage;
  final String price;
  final String remainingLife;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.manufacturer,
    required this.batchNumber,
    required this.usage,
    required this.price,
    required this.remainingLife,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['item_id'],
      name: json['item_name'],
      category: json['category'],
      manufacturer: json['manufacturer'],
      batchNumber: json['batch_number'],
      usage: json['usage'],
      price: json['price'],
      remainingLife: json['remaining_life'],
    );
  }
}

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> with SingleTickerProviderStateMixin {
  final String apiUrl = "https://uat.goclaims.in/inventory_hub/items";

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  List<Item> allItems = [];
  List<Item> filteredItems = [];

  // Filter-related properties
  List<String> categories = [];
  List<String> manufacturers = [];
  List<String> batches = [];
  Map<String, bool> selectedFilters = {};
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  Future<void> _refreshItems() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        allItems = jsonData.map((item) => Item.fromJson(item)).toList();

        // Extract unique filter values - ensure they're strings
        categories = allItems.map((e) => e.category).toSet().toList();
        manufacturers = allItems.map((e) => e.manufacturer.toString()).toSet().toList();
        batches = allItems.map((e) => e.batchNumber.toString()).toSet().toList();

        filteredItems = List.from(allItems);

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load items (status: ${response.statusCode})");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  void _applyFilters() {
    filteredItems = allItems.where((item) {
      bool matchesCategory = selectedCategory == null || item.category == selectedCategory;
      bool matchesFilters = true;

      selectedFilters.forEach((filter, _) {
        if (manufacturers.contains(filter) && item.manufacturer.toString() != filter) {
          matchesFilters = false;
        }
        if (batches.contains(filter) && item.batchNumber.toString() != filter) {
          matchesFilters = false;
        }
      });

      return matchesCategory && matchesFilters;
    }).toList();

    setState(() {});
  }

  void _removeFilter(String filter) {
    setState(() {
      selectedFilters.remove(filter);
      _applyFilters();
    });
  }

  void _selectCategory(String? category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  bool get isWebPlatform => kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
            "Inventory Items",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white
            )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshItems,
          ),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Loading inventory...",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : hasError
          ? _buildErrorView()
          : filteredItems.isEmpty
          ? _buildEmptyView()
          : _buildContentView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          ).then((_) => _refreshItems());
        },
        icon: Icon(Icons.add),
        label: Text(
          "Add Item",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
    );
  }

  Widget _buildContentView() {
    return Column(
      children: [
        _buildFilterSection(),
        _buildActiveFiltersSection(),
        Expanded(
          child: isWebPlatform ? _buildWebItemTable() : _buildItemList(),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 18, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text(
                "Filters",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown(
                  "Category",
                  categories,
                      (value) {
                    _selectCategory(value);
                  },
                  selectedValue: selectedCategory,
                ),
                SizedBox(width: 10),
                _buildFilterDropdown(
                  "Manufacturer",
                  manufacturers,
                      (value) {
                    setState(() {
                      selectedFilters[value] = true;
                      _applyFilters();
                    });
                  },
                ),
                SizedBox(width: 10),
                _buildFilterDropdown(
                  "Batch",
                  batches,
                      (value) {
                    setState(() {
                      selectedFilters[value] = true;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
      String label,
      List<String> items,
      Function(String) onSelected,
      {String? selectedValue}
      ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).primaryColor),
        items: [
          if (label == "Category")
            DropdownMenuItem(
              value: null,
              child: Text(
                "All Categories",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ...items
              .where((item) => label != "Category" ? !selectedFilters.containsKey(item) : true)
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ))
        ],
        onChanged: (value) {
          if (value != null || label == "Category") {
            onSelected(value ?? "");
          }
        },
      ),
    );
  }

  Widget _buildActiveFiltersSection() {
    List<Widget> chips = [];

    if (selectedCategory != null) {
      chips.add(
        Chip(
          label: Text(
            "Category: $selectedCategory",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          deleteIcon: Icon(Icons.close, size: 16),
          onDeleted: () => _selectCategory(null),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          deleteIconColor: Theme.of(context).primaryColor,
          labelPadding: EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
      );
    }

    chips.addAll(selectedFilters.keys.map((filter) {
      return Chip(
        label: Text(
          filter,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        deleteIcon: Icon(Icons.close, size: 16),
        onDeleted: () => _removeFilter(filter),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        deleteIconColor: Theme.of(context).primaryColor,
        labelPadding: EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      );
    }));

    if (chips.isEmpty) {
      return SizedBox(height: 4);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Applied Filters",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  // Web view for items - Table format
  Widget _buildWebItemTable() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing ${filteredItems.length} items",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddItemPage()),
                  ).then((_) => _refreshItems());
                },
                icon: Icon(Icons.add, size: 18),
                label: Text(
                  "Add Item",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 80,
                  columnSpacing: 16,
                  horizontalMargin: 8,
                  headingTextStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                  columns: [
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      label: Text('Price'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Manufacturer'),
                    ),
                    DataColumn(
                      label: Text('Batch'),
                    ),
                    DataColumn(
                      label: Text('Usage'),
                    ),
                    DataColumn(
                      label: Text('Remaining Life'),
                    ),
                    DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: filteredItems.map((item) {
                    // Generate a unique but consistent color for each category
                    final categoryHash = item.category.hashCode;
                    final categoryColor = HSLColor.fromAHSL(
                      1.0,
                      (categoryHash % 360).toDouble(),
                      0.6,
                      0.8,
                    ).toColor();

                    return DataRow(
                      cells: [
                        DataCell(Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        )),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.category,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "₹${item.price}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(
                          item.manufacturer.toString(),
                          style: GoogleFonts.poppins(fontSize: 13),
                        )),
                        DataCell(Text(
                          item.batchNumber.toString(),
                          style: GoogleFonts.poppins(fontSize: 13),
                        )),
                        DataCell(Text(
                          item.usage,
                          style: GoogleFonts.poppins(fontSize: 13),
                        )),
                        DataCell(Text(
                          item.remainingLife,
                          style: GoogleFonts.poppins(fontSize: 13),
                        )),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.category),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CategoryDetailsPage(categoryId: item.id)),
                                  );
                                },
                                tooltip: 'View Category Details',
                                iconSize: 20,
                                color: Colors.blue,
                                splashRadius: 24,
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ItemDetailsPage(itemId: item.id)),
                                  ).then((_) => _refreshItems());
                                },
                                tooltip: 'View Details',
                                iconSize: 20,
                                color: Theme.of(context).primaryColor,
                                splashRadius: 24,
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditItemPage(itemId: item.id),
                                    ),
                                  ).then((_) => _refreshItems());
                                },
                                tooltip: 'Edit Item',
                                iconSize: 20,
                                color: Colors.orange,
                                splashRadius: 24,
                              ),
                            ],
                          ),
                        ),

                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile view for items - Card format (original)
  Widget _buildItemList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          // Generate a unique but consistent color for each category
          final categoryHash = item.category.hashCode;
          final categoryColor = HSLColor.fromAHSL(
            1.0,
            (categoryHash % 360).toDouble(),
            0.6,
            0.8,
          ).toColor();

          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemDetailsPage(itemId: item.id)),
                    ).then((_) => _refreshItems());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category indicator strip
                      Container(
                        height: 6,
                        color: categoryColor,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: categoryColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: categoryColor.withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "₹${item.price}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildItemInfoGrid(item),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Remaining Life: ${item.remainingLife}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditItemPage(itemId: item.id),
                                          ),
                                        ).then((_) => _refreshItems());
                                      },
                                      tooltip: 'Edit Item',
                                      iconSize: 20,
                                      color: Colors.orange,
                                      splashRadius: 24,
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ItemDetailsPage(itemId: item.id)),
                                        ).then((_) => _refreshItems());
                                      },
                                      child: Text(
                                        "View Details",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemInfoGrid(Item item) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildInfoItem(Icons.factory_outlined, "Manufacturer", item.manufacturer.toString()),
              SizedBox(width: 16),
              _buildInfoItem(Icons.confirmation_number_outlined, "Batch", item.batchNumber.toString()),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildInfoItem(Icons.category_outlined, "Usage", item.usage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red.shade300,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Something went wrong",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _refreshItems,
            icon: Icon(Icons.refresh),
            label: Text(
              "Try Again",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
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
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Colors.blue.shade300,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "No items available",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            (selectedCategory != null || selectedFilters.isNotEmpty)
                ? "Try removing some filters"
                : "Add your first inventory item",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
          if (selectedCategory != null || selectedFilters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                    selectedFilters.clear();
                    _applyFilters();
                  });
                },
                icon: Icon(Icons.filter_list_off),
                label: Text(
                  "Clear All Filters",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}