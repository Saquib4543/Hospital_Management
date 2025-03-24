class Item_Details {
  // Make these fields non-final so we can assign them after creation
  String id;
  String name;
  String description;
  String issuanceStatus;
  String locationId;
  String requestNumber;
  String activeFlag;
  String userLocation;

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

  /// IMPORTANT: Read 'qr_id' from JSON, not 'id'.
  factory Item_Details.fromJson(Map<String, dynamic> json) {
    return Item_Details(
      id: json['qr_id'] ?? '',
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
