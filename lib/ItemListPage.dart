import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'AddEditItemPage.dart';
import 'ItemDetailsPage.dart';
import 'ItemSearchDelegate.dart';

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
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> items = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  final String apiUrl = "https://uat.goclaims.in/inventory_hub/items";

  Future<List<Item>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load items: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load items: $e");
    }
  }

  void _refreshItems() {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    fetchItems().then((data) {
      setState(() {
        items = data;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        hasError = true;
        errorMessage = error.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory", style: GoogleFonts.poppins()),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     if (items.isNotEmpty) {
          //       showSearch(context: context, delegate: ItemSearchDelegate(items));
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text("No items available to search")),
          //       );
          //     }
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshItems,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? _buildErrorView()
          : items.isEmpty
          ? _buildEmptyView()
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(context, item);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemPage(),
          ),
        ).then((_) => _refreshItems()),
        icon: Icon(Icons.add),
        label: Text("Add Item"),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 72,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "No items found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add your first inventory item",
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshItems,
            icon: Icon(Icons.refresh),
            label: Text("Refresh"),
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
          Icon(
            Icons.error_outline,
            size: 72,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
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

  Widget _buildItemCard(BuildContext context, Item item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          item.name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text("Category: ${item.category} | Price: ${item.price}"),
        trailing: Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsPage(itemId: item.id),
          ),
        ).then((_) => _refreshItems()),
      ),
    );
  }
}