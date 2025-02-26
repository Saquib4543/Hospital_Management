import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraInController extends StatefulWidget {
  const CameraInController({Key? key}) : super(key: key);

  @override
  State<CameraInController> createState() => _CameraInControllerState();
}

class _CameraInControllerState extends State<CameraInController> {
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
      _isScanning = false; // Stop scanning, show the result
    });
  }

  void _onScanAgain() {
    setState(() {
      _scannedBarcodeData = null;
      _isScanning = true;
    });
  }

  void _onContinue() {
    // Return the scanned barcode data to ReturnMedicalEquipmentPage
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

  /// This is where you integrate your real barcode scanner widget.
  Widget _buildCameraPreview() {
    return Stack(
      children: [
        // Replace with actual scanner widget or package
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
                // Simulate scanning a barcode
                _onBarcodeScanned("IN-1234-FAKE-BARCODE");
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
