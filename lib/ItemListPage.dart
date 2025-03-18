// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'AddEditItemPage.dart';
// import 'ItemDetailsPage.dart';
// import 'ItemSearchDelegate.dart';
//
// class Item {
//   final String id;
//   final String name;
//   final String category;
//   final String manufacturer;
//   final String batchNumber;
//   final String usage;
//   final String price;
//   final String remainingLife;
//
//   Item({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.manufacturer,
//     required this.batchNumber,
//     required this.usage,
//     required this.price,
//     required this.remainingLife,
//   });
//
//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       id: json['item_id'],
//       name: json['item_name'],
//       category: json['category'],
//       manufacturer: json['manufacturer'],
//       batchNumber: json['batch_number'],
//       usage: json['usage'],
//       price: json['price'],
//       remainingLife: json['remaining_life'],
//     );
//   }
// }
//
// class ItemListPage extends StatefulWidget {
//   @override
//   _ItemListPageState createState() => _ItemListPageState();
// }
//
// class _ItemListPageState extends State<ItemListPage> {
//   List<Item> items = [];
//   bool isLoading = true;
//   bool hasError = false;
//   String errorMessage = "";
//   final String apiUrl = "https://uat.goclaims.in/inventory_hub/items";
//
//   Future<List<Item>> fetchItems() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.map((item) => Item.fromJson(item)).toList();
//       } else {
//         throw Exception("Failed to load items: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Failed to load items: $e");
//     }
//   }
//
//   void _refreshItems() {
//     setState(() {
//       isLoading = true;
//       hasError = false;
//     });
//
//     fetchItems().then((data) {
//       setState(() {
//         items = data;
//         isLoading = false;
//       });
//     }).catchError((error) {
//       setState(() {
//         hasError = true;
//         errorMessage = error.toString();
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $error")),
//       );
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshItems();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Inventory", style: GoogleFonts.poppins()),
//         actions: [
//           // IconButton(
//           //   icon: Icon(Icons.search),
//           //   onPressed: () {
//           //     if (items.isNotEmpty) {
//           //       showSearch(context: context, delegate: ItemSearchDelegate(items));
//           //     } else {
//           //       ScaffoldMessenger.of(context).showSnackBar(
//           //         SnackBar(content: Text("No items available to search")),
//           //       );
//           //     }
//           //   },
//           // ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _refreshItems,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : hasError
//           ? _buildErrorView()
//           : items.isEmpty
//           ? _buildEmptyView()
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return _buildItemCard(context, item);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AddItemPage(),
//           ),
//         ).then((_) => _refreshItems()),
//         icon: Icon(Icons.add),
//         label: Text("Add Item"),
//       ),
//     );
//   }
//
//   Widget _buildEmptyView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inventory_2_outlined,
//             size: 72,
//             color: Colors.grey,
//           ),
//           SizedBox(height: 16),
//           Text(
//             "No items found",
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Add your first inventory item",
//             style: GoogleFonts.poppins(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _refreshItems,
//             icon: Icon(Icons.refresh),
//             label: Text("Refresh"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 72,
//             color: Colors.red.shade300,
//           ),
//           SizedBox(height: 16),
//           Text(
//             "Something went wrong",
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               errorMessage,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _refreshItems,
//             icon: Icon(Icons.refresh),
//             label: Text("Try Again"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildItemCard(BuildContext context, Item item) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(
//           item.name,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         subtitle: Text("Category: ${item.category} | Price: ${item.price}"),
//         trailing: Icon(Icons.chevron_right),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ItemDetailsPage(itemId: item.id),
//           ),
//         ).then((_) => _refreshItems()),
//       ),
//     );
//   }
// }


// Current Card Display

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// // Adjust these imports to match your actual file names
// import 'AddEditItemPage.dart';
// import 'ItemDetailsPage.dart';
//
// class Item {
//   final String id;
//   final String name;
//   final String category;
//   final String manufacturer;
//   final String batchNumber;
//   final String usage;
//   final String price;
//   final String remainingLife;
//
//   Item({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.manufacturer,
//     required this.batchNumber,
//     required this.usage,
//     required this.price,
//     required this.remainingLife,
//   });
//
//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       id: json['item_id'],
//       name: json['item_name'],
//       category: json['category'],
//       manufacturer: json['manufacturer'],
//       batchNumber: json['batch_number'],
//       usage: json['usage'],
//       price: json['price'],
//       remainingLife: json['remaining_life'],
//     );
//   }
// }
//
// class ItemListPage extends StatefulWidget {
//   const ItemListPage({Key? key}) : super(key: key);
//
//   @override
//   _ItemListPageState createState() => _ItemListPageState();
// }
//
// class _ItemListPageState extends State<ItemListPage> {
//   final String apiUrl = "https://uat.goclaims.in/inventory_hub/items";
//
//   bool isLoading = false;
//   bool hasError = false;
//   String errorMessage = "";
//
//   // The full list of items we fetch
//   List<Item> allItems = [];
//   // Map of category -> items in that category
//   Map<String, List<Item>> itemsByCategory = {};
//
//   // Whether we’re currently viewing the category list or an individual category
//   bool showCategoryView = true;
//   String? selectedCategory;
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshItems();
//   }
//
//   Future<void> _refreshItems() async {
//     setState(() {
//       isLoading = true;
//       hasError = false;
//       errorMessage = "";
//     });
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//
//         // Convert JSON to List<Item>
//         allItems = jsonData.map((item) => Item.fromJson(item)).toList();
//
//         // Group items by category
//         itemsByCategory = {};
//         for (var item in allItems) {
//           itemsByCategory.putIfAbsent(item.category, () => []);
//           itemsByCategory[item.category]!.add(item);
//         }
//
//         // Once refreshed, go back to the category view
//         showCategoryView = true;
//         selectedCategory = null;
//
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load items (status: ${response.statusCode})");
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//         errorMessage = e.toString();
//       });
//     }
//   }
//
//   // Helper: build the entire screen
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           showCategoryView
//               ? "Categories" // Title when showing categories
//               : (selectedCategory ?? "Items"),
//           style: GoogleFonts.poppins(),
//         ),
//         leading: showCategoryView
//             ? null
//             : IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             setState(() {
//               showCategoryView = true;
//               selectedCategory = null;
//             });
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _refreshItems,
//           ),
//         ],
//       ),
//       body: _buildBody(),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Go to Add item page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddItemPage(),
//             ),
//           ).then((_) => _refreshItems());
//         },
//         icon: Icon(Icons.add),
//         label: Text("Add Item"),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//     if (hasError) {
//       return _buildErrorView();
//     }
//     // If we’re showing category view:
//     if (showCategoryView) {
//       return _buildCategoryView();
//     } else {
//       // Show items in the selected category
//       return _buildItemsInCategory();
//     }
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 72,
//             color: Colors.red.shade300,
//           ),
//           SizedBox(height: 16),
//           Text(
//             "Something went wrong",
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               errorMessage,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _refreshItems,
//             icon: Icon(Icons.refresh),
//             label: Text("Try Again"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryView() {
//     // If there are no items at all:
//     if (allItems.isEmpty) {
//       return _buildEmptyItemsView();
//     }
//     // If we have items but no categories for some reason:
//     if (itemsByCategory.isEmpty) {
//       return Center(
//         child: Text(
//           "No categories found",
//           style: GoogleFonts.poppins(fontSize: 16),
//         ),
//       );
//     }
//
//     // Build a list of categories
//     final categoryNames = itemsByCategory.keys.toList();
//
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: categoryNames.length,
//       itemBuilder: (context, index) {
//         final category = categoryNames[index];
//         final itemCount = itemsByCategory[category]?.length ?? 0;
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 8),
//           child: ListTile(
//             title: Text(
//               category,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             subtitle: Text("Items: $itemCount"),
//             trailing: Icon(Icons.chevron_right),
//             onTap: () {
//               setState(() {
//                 showCategoryView = false;
//                 selectedCategory = category;
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildItemsInCategory() {
//     if (selectedCategory == null) {
//       return Center(child: Text("No category selected"));
//     }
//
//     final items = itemsByCategory[selectedCategory] ?? [];
//     // If for some reason there are no items in this category
//     if (items.isEmpty) {
//       return Center(
//         child: Text(
//           "No items in $selectedCategory",
//           style: GoogleFonts.poppins(fontSize: 16),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 8),
//           child: ListTile(
//             title: Text(
//               item.name,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             subtitle: Text("Price: ${item.price}"),
//             trailing: Icon(Icons.chevron_right),
//             onTap: () {
//               // Open item details if needed
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ItemDetailsPage(itemId: item.id),
//                 ),
//               ).then((_) => _refreshItems());
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyItemsView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inventory_2_outlined,
//             size: 72,
//             color: Colors.grey,
//           ),
//           SizedBox(height: 16),
//           Text(
//             "No items found",
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Add your first inventory item",
//             style: GoogleFonts.poppins(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _refreshItems,
//             icon: Icon(Icons.refresh),
//             label: Text("Refresh"),
//           ),
//         ],
//       ),
//     );
//   }
// }


// Flutter table Look

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'ItemDetailsPage.dart';
import 'AddEditItemPage.dart';

class Item {
  final String id;
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
  const ItemListPage({Key? key}) : super(key: key);

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> with SingleTickerProviderStateMixin {
  final String apiUrl = "https://uat.goclaims.in/inventory_hub/items";

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  List<Item> allItems = [];
  Map<String, List<Item>> itemsByCategory = {};
  TabController? _tabController;

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

        itemsByCategory = {};
        for (var item in allItems) {
          itemsByCategory.putIfAbsent(item.category, () => []);
          itemsByCategory[item.category]!.add(item);
        }

        _tabController = TabController(length: itemsByCategory.keys.length, vsync: this);

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

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Items", style: GoogleFonts.poppins()),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshItems),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? _buildErrorView()
          : itemsByCategory.isEmpty
          ? _buildEmptyView()
          : _buildTabView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          ).then((_) => _refreshItems());
        },
        icon: Icon(Icons.add),
        label: Text("Add Item"),
      ),
    );
  }

  Widget _buildTabView() {
    final categories = itemsByCategory.keys.toList();

    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                return _buildItemTable(itemsByCategory[category]!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTable(List<Item> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          border: TableBorder.all(width: 1, color: Colors.grey.shade300),
          columns: [
            DataColumn(label: Text("Item Name", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Category", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Manufacturer", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Batch", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Usage", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Price", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Remaining Life", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Actions", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.name, style: GoogleFonts.poppins())),
              DataCell(Text(item.category, style: GoogleFonts.poppins())),
              DataCell(Text(item.manufacturer, style: GoogleFonts.poppins())),
              DataCell(Text(item.batchNumber, style: GoogleFonts.poppins())),
              DataCell(Text(item.usage, style: GoogleFonts.poppins())),
              DataCell(Text("₹${item.price}", style: GoogleFonts.poppins())),
              DataCell(Text(item.remainingLife, style: GoogleFonts.poppins())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemDetailsPage(itemId: item.id)),
                        ).then((_) => _refreshItems());
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 72, color: Colors.red.shade300),
          SizedBox(height: 16),
          Text("Something went wrong", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(errorMessage, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshItems,
            icon: Icon(Icons.refresh),
            label: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Text("No items available", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
    );
  }
}
