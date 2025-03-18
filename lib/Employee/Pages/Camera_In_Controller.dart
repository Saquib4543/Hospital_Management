import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../MedicalDashboard Functions/EquipmentDisplay.dart';

class CameraInController extends StatefulWidget {
  const CameraInController({Key? key}) : super(key: key);

  @override
  State<CameraInController> createState() => _CameraInControllerState();
}

class _CameraInControllerState extends State<CameraInController> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = true;
  bool _isScanning = true;
  bool _isFlashOn = false;
  final List<String> scannedBarcodes = [];
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Immediate permission check on app start
    _checkAndRequestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check permission again when app resumes (user might have granted permission in settings)
    if (state == AppLifecycleState.resumed && !_isPermissionGranted) {
      _checkAndRequestCameraPermission();
    }
  }

  /// Check current permission status and request if needed
  Future<void> _checkAndRequestCameraPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    try {
      // First check current status
      final status = await Permission.camera.status;

      if (status.isGranted) {
        // Already have permission
        setState(() {
          _isPermissionGranted = true;
          _isCheckingPermission = false;
        });
        return;
      }

      // Request permission
      final result = await Permission.camera.request();

      setState(() {
        _isPermissionGranted = result.isGranted;
        _isCheckingPermission = false;
      });

      // Show guidance if permission denied
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

  /// Show appropriate guidance based on permission state
  void _showPermissionGuidance(bool isPermanentlyDenied) {
    final title = isPermanentlyDenied
        ? 'Camera Permission Required'
        : 'Camera Access Needed';

    final message = isPermanentlyDenied
        ? 'Camera permission was denied. Please enable it in app settings to scan barcodes.'
        : 'This app needs camera access to scan barcodes. Please grant permission when prompted.';

    final buttonText = isPermanentlyDenied
        ? 'Open Settings'
        : 'Try Again';

    final buttonAction = isPermanentlyDenied
        ? openAppSettings
        : _checkAndRequestCameraPermission;

    // Delay showing dialog to prevent build errors
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
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
            );
          },
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
      return; // Skip empty codes
    }

    final scannedCode = scanData.code!;

    // Add unique scans only
    if (_isScanning && !scannedBarcodes.contains(scannedCode)) {
      setState(() {
        scannedBarcodes.add(scannedCode);
      });

      // Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned: $scannedCode'),
          duration: const Duration(seconds: 1),
        ),
      );

      // Brief pause to prevent duplicates
      controller?.pauseCamera();
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          controller?.resumeCamera();
        }
      });
    }
  }

  void _toggleFlash() async {
    if (controller != null) {
      try {
        await controller!.toggleFlash();
        final isFlashOn = await controller!.getFlashStatus() ?? false;
        setState(() {
          _isFlashOn = isFlashOn;
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
      appBar: AppBar(
        title: const Text("Scan Equipment"),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          if (_isPermissionGranted && _isScanning)
            IconButton(
              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleFlash,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isCheckingPermission) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text("Checking camera permission..."),
          ],
        ),
      );
    }

    if (!_isPermissionGranted) {
      return _buildPermissionDeniedScreen();
    }

    return _isScanning ? _buildCameraPreview() : _buildReviewScreen();
  }

  /// Screen when permission is denied
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
              backgroundColor: Colors.green.shade700,
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

  /// Main camera scanner
  Widget _buildCameraPreview() {
    // Calculate scan area size
    final scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: (qrViewController) {
            setState(() {
              controller = qrViewController;
            });

            // Check flash status
            controller!.getFlashStatus().then((value) {
              if (mounted && value != null) {
                setState(() {
                  _isFlashOn = value;
                });
              }
            });

            // Start listening for barcodes
            controller!.scannedDataStream.listen((scanData) {
              _onBarcodeScanned(scanData);
            });
          },
          overlay: QrScannerOverlayShape(
            borderColor: Colors.green,
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

        // Review button
        Positioned(
          bottom: 40,
          left: 40,
          right: 40,
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
            child: Text(
              "Review (${scannedBarcodes.length})",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// Review screen
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
              child: scannedBarcodes.isEmpty
                  ? const Center(
                child: Text('No items scanned yet'),
              )
                  : ListView.builder(
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          scannedBarcodes.removeAt(index);
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
                onPressed: scannedBarcodes.isEmpty
                    ? null
                    : () {
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