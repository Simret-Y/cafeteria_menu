import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder QR scanner screen.
///
/// Owned by Yared (QR scanner). Replace with the real QR Scanner when
/// ready — keep the file path and class name.
class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'QR Scanner',
        icon: Icons.qr_code_scanner,
        owner: 'Yared',
      ),
    );
  }
}
