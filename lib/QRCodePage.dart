import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  String? scannedCode;

  // Animation controllers and animations
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 0.8).animate(_animationController);
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      // Fixing issue with camera on platform-specific reload
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Make sure camera is active
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && isScanning) {
        setState(() {
          isScanning = false;
          scannedCode = scanData.code;
        });

        // Show scan result in snackbar
        _showScannedDataSnackbar(scanData.code!);

        // Resume scanning after a short delay
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              isScanning = true;
            });
          }
        });
      }
    });
  }

  void _showScannedDataSnackbar(String data) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'QR Code Scanned: $data',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'COPY',
          textColor: Colors.white,
          onPressed: () {
            // Implement copy to clipboard functionality here
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () async {
              await controller?.toggleFlash();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // QR Scanner View
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),

          // Animated scan frame
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final size = MediaQuery.of(context).size.width * 0.75;

                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.withOpacity(_animation.value),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                );
              },
            ),
          ),

          // Animated scan line
          Center(
            child: AnimatedBuilder(
              animation: _scanLineAnimation,
              builder: (context, child) {
                final size = MediaQuery.of(context).size.width * 0.75;
                final position = _scanLineAnimation.value * size;

                return Positioned(
                  top: (MediaQuery.of(context).size.height - size) / 2 + position - 2,
                  left: (MediaQuery.of(context).size.width - size) / 2,
                  child: Container(
                    width: size,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.0),
                          Colors.blue.withOpacity(0.8),
                          Colors.blue.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom instruction panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Align QR code within the frame to scan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isScanning
                        ? 'Scanning...'
                        : 'Last scanned: ${scannedCode ?? "None"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.resumeCamera();
                      if (mounted) {
                        setState(() {
                          isScanning = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'SCAN AGAIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}