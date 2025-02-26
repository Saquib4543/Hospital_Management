import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// If you are using a real barcode scanning package, import it here.
// e.g. import 'package:mobile_scanner/mobile_scanner.dart';
// or  import 'package:barcode_scan2/barcode_scan2.dart';

class CameraOutController extends StatefulWidget {
  const CameraOutController({super.key});

  @override
  State<CameraOutController> createState() => _CameraOutControllerState();
}

class _CameraOutControllerState extends State<CameraOutController> {
  bool _isPermissionGranted = false;
  bool _isScanning = true;
  String? _scannedBarcodeData;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  void _onBarcodeScanned(String barcodeData) {
    setState(() {
      _scannedBarcodeData = barcodeData;
      _isScanning = false;
    });
  }

  void _onScanAgain() {
    setState(() {
      _scannedBarcodeData = null;
      _isScanning = true;
    });
  }

  void _onContinue() {
    // Pass the barcode data back to the previous screen:
    Navigator.pop(context, _scannedBarcodeData);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return Scaffold(
        appBar: AppBar(title: const Text("Scan Barcode")),
        body: const Center(
          child: Text("Camera permission not granted."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: _isScanning ? _buildCameraPreview() : _buildScannedResult(),
    );
  }

  /// This is where you'd integrate your real camera scanner widget.
  Widget _buildCameraPreview() {
    return Stack(
      children: [
        // Replace with actual scanner widget, e.g. MobileScanner
        Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: const Text(
            "Camera Preview Here",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                // Simulate scanning
                _onBarcodeScanned("1234-5678-FAKE-BARCODE");
              },
              child: const Text("Simulate Barcode Scan"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannedResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Scanned Data:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _scannedBarcodeData ?? "Unknown",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _onScanAgain,
                      child: const Text("Scan Again"),
                    ),
                    ElevatedButton(
                      onPressed: _onContinue,
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
