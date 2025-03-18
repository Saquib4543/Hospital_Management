// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/EquipmentDisplay.dart'; // Adjust the path as needed
//
// class CameraInController extends StatefulWidget {
//   const CameraInController({Key? key}) : super(key: key);
//
//   @override
//   State<CameraInController> createState() => _CameraInControllerState();
// }
//
// class _CameraInControllerState extends State<CameraInController> {
//   bool _isPermissionGranted = false;
//   bool _isScanning = true;
//   final List<String> scannedBarcodes = [];
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Required for QR scanner
//   QRViewController? controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestCameraPermission();
//   }
//
//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     setState(() {
//       _isPermissionGranted = status.isGranted;
//     });
//   }
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.resumeCamera();
//     }
//   }
//
//   /// Function to handle scanned barcode
//   // void _onBarcodeScanned(Barcode scanData) {
//   //   if (!scannedBarcodes.contains(scanData.code)) {
//   //     setState(() {
//   //       scannedBarcodes.add(scanData.code ?? "Unknown");
//   //     });
//   //   }
//   // }
//
//   void _onBarcodeScanned(Barcode scanData) {
//     if (!scannedBarcodes.contains(scanData.code)) {
//       setState(() {
//         scannedBarcodes.add(scanData.code ?? "Unknown");
//         controller?.pauseCamera();
//       });
//     }
//   }
//
//   void _scanMore() {
//     setState(() {
//       _isScanning = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan Equipment"),
//         backgroundColor: const Color(0xFF2E7D32),
//         elevation: 0,
//       ),
//       body: _isPermissionGranted
//           ? (_isScanning ? _buildCameraPreview() : _buildReviewScreen())
//           : _buildPermissionDeniedScreen(),
//     );
//   }
//
//   Widget _buildPermissionDeniedScreen() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.camera_alt, size: 60, color: Colors.redAccent),
//           const SizedBox(height: 16),
//           const Text("Camera permission not granted.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   /// 1) Camera Preview for Scanning
//   Widget _buildCameraPreview() {
//     return Stack(
//       children: [
//         QRView(
//           key: qrKey,
//           overlay: QrScannerOverlayShape(
//             borderColor: Colors.green,
//             borderRadius: 10,
//             borderLength: 30,
//             borderWidth: 10,
//             cutOutSize: 250, // Scanner area size
//           ),
//           onQRViewCreated: (QRViewController qrController) {
//             controller = qrController;
//             controller!.scannedDataStream.listen((scanData) {
//               _onBarcodeScanned(scanData);
//             });
//           },
//         ),
//         Positioned(
//           bottom: 40,
//           left: 0,
//           right: 0,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.shade700,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             onPressed: () {
//               setState(() {
//                 _isScanning = false;
//               });
//             },
//             child: const Text("Review Scanned Items"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// 2) Review Scanned Items
//   Widget _buildReviewScreen() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text(
//             "Scanned ${scannedBarcodes.length} item(s).",
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListView.builder(
//                 itemCount: scannedBarcodes.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: const Icon(Icons.qr_code_2, color: Color(0xFF2E7D32)),
//                     title: Text(scannedBarcodes[index], style: const TextStyle(fontWeight: FontWeight.w500)),
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade700,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: _scanMore,
//                 child: const Text("Scan More"),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(color: Colors.green.shade700),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => EquipmentDisplay(scannedItems: scannedBarcodes),
//                     ),
//                   );
//                 },
//                 child: const Text("Next"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/EquipmentDisplay.dart';

class CameraInController extends StatefulWidget {
  const CameraInController({Key? key}) : super(key: key);

  @override
  State<CameraInController> createState() => _CameraInControllerState();
}

class _CameraInControllerState extends State<CameraInController> {
  bool _isPermissionGranted = false;
  bool _isScanning = true;
  final List<String> scannedBarcodes = [];
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  /// Request the camera permission using the permission_handler package
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    debugPrint('Camera permission status: $status');
    setState(() {
      _isPermissionGranted = status.isGranted;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    // Resume the camera if it was paused (e.g., after hot reload).
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  /// Called every time a new QR or barcode is scanned
  void _onBarcodeScanned(Barcode scanData) {
    final scannedCode = scanData.code ?? "Unknown";

    // Only add unique scans
    if (!scannedBarcodes.contains(scannedCode)) {
      setState(() {
        scannedBarcodes.add(scannedCode);
      });
      // Pause so you don't re‐scan the same code repeatedly
      controller?.pauseCamera();
    }
  }

  /// Resume camera to scan more items
  void _scanMore() {
    controller?.resumeCamera();
    setState(() {
      _isScanning = true;
    });
  }

  @override
  void dispose() {
    // Dispose camera resources
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Equipment"),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      // If permission granted => show camera or review screen
      // Else, show the "permission denied" screen
      body: _isPermissionGranted
          ? (_isScanning ? _buildCameraPreview() : _buildReviewScreen())
          : _buildPermissionDeniedScreen(),
    );
  }

  /// Displayed if the user denies camera permission
  Widget _buildPermissionDeniedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.camera_alt, size: 60, color: Colors.redAccent),
          SizedBox(height: 16),
          Text(
            "Camera permission not granted.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// The main camera scanner view with NO overlay shape or color
  Widget _buildCameraPreview() {
    return Stack(
      children: [
        // Simply pass the key and onQRViewCreated; no overlay parameter
        QRView(
          key: qrKey,
          onQRViewCreated: (qrController) {
            controller = qrController;
            controller!.scannedDataStream.listen((scanData) {
              _onBarcodeScanned(scanData);
            });
          },
        ),

        // Button to switch to the "Review" screen (yes, it overlaps visually,
        // but there is no tinted overlay on the camera feed itself)
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                _isScanning = false;
              });
            },
            child: const Text("Review Scanned Items"),
          ),
        ),
      ],
    );
  }

  /// Shows the list of scanned QR (or bar) codes and two buttons
  Widget _buildReviewScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Scanned ${scannedBarcodes.length} item(s).",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: scannedBarcodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.qr_code_2,
                      color: Color(0xFF2E7D32),
                    ),
                    title: Text(
                      scannedBarcodes[index],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _scanMore,
                child: const Text("Scan More"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EquipmentDisplay(
                        scannedItems: scannedBarcodes,
                      ),
                    ),
                  );
                },
                child: const Text("Next"),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
