class Item_Details {
  final String id;
  final String name;
  final String description;
  final String location;
  final String issuanceStatus;  // <-- new
  final String locationId;      // <-- new
  final String requestNumber;   // <-- new

  Item_Details({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.issuanceStatus,
    required this.locationId,
    required this.requestNumber,
  });

  factory Item_Details.fromJson(Map<String, dynamic> json) {
    return Item_Details(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      issuanceStatus: json['issuance_status'] ?? '',
      locationId: json['location_id'] ?? '',
      requestNumber: json['request_number'] ?? '',
    );
  }
}
