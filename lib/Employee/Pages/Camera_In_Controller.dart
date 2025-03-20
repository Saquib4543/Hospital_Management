import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/item_details.dart';
import 'package:hospital_inventory_management/Employee/MedicalDashboard%20Functions/EquipmentDisplay.dart';

class CameraInController extends StatefulWidget {
  const CameraInController({Key? key}) : super(key: key);

  @override
  State<CameraInController> createState() => _CameraInControllerState();
}

class _CameraInControllerState extends State<CameraInController>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = true;
  bool _isScanning = true;
  bool _isFlashOn = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  /// The raw QR codes scanned
  final List<String> scannedBarcodes = [];

  /// Map from scanned QR code -> fetched Item_Details
  Map<String, Item_Details?> scannedItemsDetails = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndRequestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isPermissionGranted) {
      _checkAndRequestCameraPermission();
    }
  }

  Future<void> _checkAndRequestCameraPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        setState(() {
          _isPermissionGranted = true;
          _isCheckingPermission = false;
        });
        return;
      }

      final result = await Permission.camera.request();
      setState(() {
        _isPermissionGranted = result.isGranted;
        _isCheckingPermission = false;
      });

      if (!result.isGranted) {
        _showPermissionGuidance(result.isPermanentlyDenied);
      }
    } catch (e) {
      debugPrint('Error checking camera permission: $e');
      setState(() {
        _isCheckingPermission = false;
      });
    }
  }

  void _showPermissionGuidance(bool isPermanentlyDenied) {
    final title = isPermanentlyDenied
        ? 'Camera Permission Required'
        : 'Camera Access Needed';

    final message = isPermanentlyDenied
        ? 'Camera permission was denied. Please enable it in settings.'
        : 'This app needs camera access to scan barcodes. Please grant permission when prompted.';

    final buttonText = isPermanentlyDenied ? 'Open Settings' : 'Try Again';
    final buttonAction =
    isPermanentlyDenied ? openAppSettings : _checkAndRequestCameraPermission;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  buttonAction();
                },
                child: Text(buttonText),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  /// Called when a barcode is detected
  void _onBarcodeScanned(Barcode scanData) {
    if (scanData.code == null || scanData.code!.isEmpty) {
      return;
    }
    final scannedCode = scanData.code!.trim();

    // Only add unique scans
    if (_isScanning && !scannedBarcodes.contains(scannedCode)) {
      setState(() {
        scannedBarcodes.add(scannedCode);
      });

      // Fetch from API
      _fetchItemDetails(scannedCode);

      // Quick feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned: $scannedCode'),
          duration: const Duration(seconds: 1),
        ),
      );

      // Pause scanning & instantly go to Review screen
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _fetchItemDetails(String qrId) async {
    final url = 'https://uat.goclaims.in/inventory_hub/itemdetails/qr/$qrId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final itemDetails = Item_Details.fromJson(jsonBody);
        setState(() {
          scannedItemsDetails[qrId] = itemDetails;
        });
      } else {
        debugPrint('Error fetching item details: ${response.statusCode}');
        setState(() {
          scannedItemsDetails[qrId] = null;
        });
      }
    } catch (e) {
      debugPrint('Exception fetching item details: $e');
      setState(() {
        scannedItemsDetails[qrId] = null;
      });
    }
  }

  void _toggleFlash() async {
    if (controller != null) {
      try {
        await controller!.toggleFlash();
        final flashStatus = await controller!.getFlashStatus() ?? false;
        setState(() {
          _isFlashOn = flashStatus;
        });
      } catch (e) {
        debugPrint('Error toggling flash: $e');
      }
    }
  }

  void _scanMore() {
    controller?.resumeCamera();
    setState(() {
      _isScanning = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the same brand color or gradient top color
      appBar: AppBar(
        title: const Text("Scan Equipment"),
        backgroundColor: const Color(0xFF3B7AF5),
        elevation: 0,
        actions: [
          if (_isPermissionGranted && _isScanning)
            IconButton(
              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleFlash,
            ),
        ],
      ),
      body: Stack(
        children: [
          // 1) Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B7AF5), Color(0xFF1E4EC7)],
              ),
            ),
          ),

          // 2) Optional pattern overlay
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),

          // 3) Main content:
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isCheckingPermission) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF3B7AF5)),
            SizedBox(height: 16),
            Text("Checking camera permission..."),
          ],
        ),
      );
    }

    if (!_isPermissionGranted) {
      return _buildPermissionDeniedScreen();
    }

    // If scanning is true, show camera
    // If scanning is false, show review
    return _isScanning ? _buildCameraPreview() : _buildReviewScreen();
  }

  Widget _buildPermissionDeniedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            "Camera permission required",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "This app needs camera access to scan barcodes",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkAndRequestCameraPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B7AF5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text("Grant Permission"),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: openAppSettings,
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    final scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        // The camera feed covers the entire area, so the background gradient
        // might not be visible behind it. That’s expected, unless you want
        // partial transparency. But we keep it consistent with the rest of your UI.
        QRView(
          key: qrKey,
          onQRViewCreated: (qrViewController) {
            setState(() {
              controller = qrViewController;
            });
            controller!.getFlashStatus().then((value) {
              if (mounted && value != null) {
                setState(() {
                  _isFlashOn = value;
                });
              }
            });
            controller!.scannedDataStream.listen((scanData) {
              _onBarcodeScanned(scanData);
            });
          },
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanAreaSize,
          ),
          formatsAllowed: const [
            BarcodeFormat.qrcode,
            BarcodeFormat.code128,
            BarcodeFormat.code39,
            BarcodeFormat.ean13,
            BarcodeFormat.ean8,
          ],
        ),

        // Guide text
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: 0,
          right: 0,
          child: const Center(
            child: Text(
              "Position barcode in square",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows the "Review" screen with scanned items
  Widget _buildReviewScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Scanned ${scannedBarcodes.length} item(s)",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B7AF5),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: scannedBarcodes.isEmpty
                  ? const Center(child: Text('No items scanned yet'))
                  : ListView.builder(
                itemCount: scannedBarcodes.length,
                itemBuilder: (context, index) {
                  final code = scannedBarcodes[index];
                  final itemDetails = scannedItemsDetails[code];

                  return ListTile(
                    leading: const Icon(
                      Icons.qr_code_2,
                      color: Color(0xFF3B7AF5),
                    ),
                    title: Text(
                      itemDetails != null
                          ? '${itemDetails.name} (${itemDetails.id})'
                          : 'Loading details for $code...',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: itemDetails != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Description: ${itemDetails.description}'),
                        Text(
                            'Issuance: ${itemDetails.issuanceStatus}'),
                        Text(
                            'Location ID: ${itemDetails.locationId}'),
                        Text(
                            'Request #: ${itemDetails.requestNumber}'),
                      ],
                    )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red),
                      onPressed: () {
                        setState(() {
                          scannedBarcodes.removeAt(index);
                          scannedItemsDetails.remove(code);
                        });
                      },
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
              // "Scan More" button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B7AF5),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _scanMore,
                child: const Text("Scan More"),
              ),

              // "Next" button -> pass final list to EquipmentDisplay
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3B7AF5),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFF3B7AF5)),
                  ),
                ),
                onPressed: scannedBarcodes.isEmpty
                    ? null
                    : () {
                  final detailsList = scannedBarcodes
                      .map((code) => scannedItemsDetails[code])
                      .where((item) => item != null)
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EquipmentDisplay(
                        scannedItems: detailsList.cast<Item_Details>(),
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

// ---------------------------------------------------------------------------
// Optional grid pattern painter (like in your other pages)
// ---------------------------------------------------------------------------
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const double gridSize = 30.0;

    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
