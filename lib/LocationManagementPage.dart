import 'package:flutter/material.dart';

class Location {
  final String name;
  final String id;

  Location({required this.name, required this.id});
}

class LocationManagementPage extends StatelessWidget {
  final List<Location> locations = [
    Location(name: "Main Warehouse", id: "LOC001"),
    Location(name: "Pharmacy A", id: "LOC002"),
    Location(name: "Pharmacy B", id: "LOC003"),
    Location(name: "Hospital Storage", id: "LOC004"),
    Location(name: "Medical Supplies Room", id: "LOC005"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Locations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  locations[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Location ID: ${locations[index].id}"),
                leading: Icon(Icons.location_on, color: Colors.blue),
              ),
            );
          },
        ),
      ),
    );
  }
}
