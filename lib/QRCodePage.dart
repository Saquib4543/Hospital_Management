import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QRScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              "QR Scanner",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Scan QR code to view item details",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Start Scanning"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Implement QR scanning logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
