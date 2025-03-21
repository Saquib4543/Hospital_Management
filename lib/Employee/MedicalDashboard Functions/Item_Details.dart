class Item_Details {
  final String id;
  final String name;
  final String description;
  final String issuanceStatus;
  final String locationId;
  final String requestNumber;

  // Add these fields
  final String activeFlag;
  final String userLocation;

  Item_Details({
    required this.id,
    required this.name,
    required this.description,
    required this.issuanceStatus,
    required this.locationId,
    required this.requestNumber,
    required this.activeFlag,
    required this.userLocation,
  });

  factory Item_Details.fromJson(Map<String, dynamic> json) {
    return Item_Details(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      issuanceStatus: json['issuance_status'] ?? '',
      locationId: json['location_id'] ?? '',
      requestNumber: json['request_number'] ?? '',
      activeFlag: json['active_flag']?.toString() ?? '',
      userLocation: json['user_location']?.toString() ?? '',
    );
  }
}
