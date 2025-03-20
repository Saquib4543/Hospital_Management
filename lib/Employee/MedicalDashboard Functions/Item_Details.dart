// item_details.dart
class Item_Details {
  final String id;               // We'll store qr_id in here
  final String name;
  final String description;
  final String issuanceStatus;
  final String locationId;
  final String requestNumber;

  Item_Details({
    required this.id,
    required this.name,
    required this.description,
    required this.issuanceStatus,
    required this.locationId,
    required this.requestNumber,
  });

  factory Item_Details.fromJson(Map<String, dynamic> json) {
    return Item_Details(
      id: json['qr_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      issuanceStatus: json['issuance_status'] ?? '',
      locationId: json['location_id'] ?? '',
      requestNumber: json['request_number'] ?? '',
    );
  }
}
