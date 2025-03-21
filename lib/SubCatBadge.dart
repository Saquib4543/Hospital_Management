import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class SubcategoryBadge extends StatelessWidget {
  final int count;
  final Color color;
  final VoidCallback onTap;

  const SubcategoryBadge({
    Key? key,
    required this.count,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$count Subcategories",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
class Item {
  final String itemId;
  final String description;
  final String activeFlag;
  final String createdBy;
  final String? fromDate;
  final String? toDate;
  final String issuanceStatus;
  final String locationId;
  final String qrId;
  final List<String> qrImage;
  final String refId;
  final String requestNumber;

  Item({
    required this.itemId,
    required this.description,
    required this.activeFlag,
    required this.createdBy,
    this.fromDate,
    this.toDate,
    required this.issuanceStatus,
    required this.locationId,
    required this.qrId,
    required this.qrImage,
    required this.refId,
    required this.requestNumber,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      description: json['description'] ?? '',
      activeFlag: json['active_flag'] ?? 'inactive',
      createdBy: json['created_by'] ?? '',
      fromDate: json['from_date'],
      toDate: json['to_date'],
      issuanceStatus: json['issuance_status'] ?? 'Unavailable',
      locationId: json['location_id'] ?? '',
      qrId: json['qr_id'] ?? '',
      qrImage: json['qr_image'] != null
          ? List<String>.from(json['qr_image'])
          : [],
      refId: json['ref_id'] ?? '',
      requestNumber: json['request_number'] ?? '0',
    );
  }
}