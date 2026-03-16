import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Controlador para manejar el flash y la cámara
  final MobileScannerController controller = MobileScannerController();
  final ValueNotifier<bool> torchEnabled = ValueNotifier(false);
  bool isScanCompleted = false;

  @override
  void dispose() {
    controller.dispose(); // IMPORTANTE: Apaga la cámara al salir para ahorrar batería
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Escanear Producto"),
        actions: [
          // Botón para el Flash
          IconButton(
            icon: ValueListenableBuilder<bool>(
              valueListenable: torchEnabled,
              builder: (context, enabled, child) {
                return enabled
                  ? const Icon(Icons.flash_on, color: Colors.yellow)
                  : const Icon(Icons.flash_off, color: Colors.grey);
              },
            ),
            onPressed: () {
              controller.toggleTorch();
              torchEnabled.value = !torchEnabled.value;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !isScanCompleted) {
                isScanCompleted = true; // Evita múltiples detecciones
                final String code = barcodes.first.rawValue ?? "";
                
                // Devuelve el código a VentaPOS
                Navigator.pop(context, code);
              }
            },
          ),
          // Guía visual (el cuadrito en el centro)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}