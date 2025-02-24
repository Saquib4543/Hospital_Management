import 'package:flutter/material.dart';

import 'ItemDetailsPage.dart';
import 'main.dart';

class ItemSearchDelegate extends SearchDelegate<Item> {
  final List<Item> items;

  ItemSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, items[0]),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          leading: Icon(Icons.inventory),
          title: Text(item.name),
          subtitle: Text("Qty: ${item.quantity}"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsPage(item: item),
            ),
          ),
        );
      },
    );
  }
}
