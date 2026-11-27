import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder AI recommendations screen.
///
/// Owned by Yared (AI recommendations). Replace with the real
/// Recommendations screen when ready — keep the file path and class name.
class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Recommendations',
        icon: Icons.recommend,
        owner: 'Yared',
      ),
    );
  }
}
