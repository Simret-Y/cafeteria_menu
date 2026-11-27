import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../staff/presentation/providers/staff_providers.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final _codeController = TextEditingController();
  final _scannerController = MobileScannerController();
  bool _cameraActive = false;
  bool _hasVerified = false;
  String? _resultMessage;
  bool _resultValid = false;

  @override
  void dispose() {
    _codeController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _verifyCode(String rawCode) {
    final code = rawCode.trim();
    if (code.isEmpty) return;
    final validIds = ref
        .read(cartProvider)
        .placedOrders
        .map((order) => order.orderId)
        .toSet();

    if (!validIds.contains(code)) {
      setState(() {
        _hasVerified = true;
        _resultValid = false;
        _resultMessage = 'Order $code was not found';
      });
      return;
    }

    ref
        .read(staffOrderStatusProvider.notifier)
        .updateStatus(code, OrderPreparationStatus.collected);
    _scannerController.stop();
    setState(() {
      _cameraActive = false;
      _hasVerified = true;
      _resultValid = true;
      _resultMessage = '$code verified. Pickup completed.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 1,
              child: _cameraActive
                  ? MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        if (_hasVerified) return;
                        final code = capture.barcodes
                            .where(
                              (barcode) =>
                                  barcode.rawValue != null &&
                                  barcode.rawValue!.isNotEmpty,
                            )
                            .map((barcode) => barcode.rawValue!)
                            .firstOrNull;
                        if (code != null) _verifyCode(code);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 72,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _cameraActive = true;
                                _hasVerified = false;
                                _resultMessage = null;
                              });
                              _scannerController.start();
                            },
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Start Camera'),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Or enter pickup code', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('qr_code_field'),
                  controller: _codeController,
                  decoration: const InputDecoration(
                    hintText: 'ORD-104',
                    prefixIcon: Icon(Icons.confirmation_number_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: _verifyCode,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(92, 56)),
                onPressed: () => _verifyCode(_codeController.text),
                child: const Text('Verify'),
              ),
            ],
          ),
          if (_hasVerified) ...[
            const SizedBox(height: 16),
            Card(
              color: _resultValid
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  _resultValid ? Icons.check_circle : Icons.error_outline,
                  color: _resultValid
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                title: Text(_resultMessage ?? ''),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
