import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';

/// Manager Dashboard — shows menu management controls and prototype actions.
///
/// Owned by Yared Gebre (Member 4).
/// Full CRUD and Firestore sync are deferred to Milestone 2.
class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Dashboard')),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Menu Management', theme: theme),
          const SizedBox(height: 8),
          _ActionTile(
            icon: Icons.add_circle_outline,
            title: 'Add Menu Item',
            subtitle: 'Create a new cafeteria item (Milestone 2)',
            onTap: () => _showPrototypeSnackbar(context, 'Add Menu Item'),
          ),
          _ActionTile(
            icon: Icons.edit_outlined,
            title: 'Edit Menu Item',
            subtitle: 'Update name, price, or availability (Milestone 2)',
            onTap: () => _showPrototypeSnackbar(context, 'Edit Menu Item'),
          ),
          _ActionTile(
            icon: Icons.delete_outline,
            title: 'Remove Menu Item',
            subtitle: 'Delete an item from the menu (Milestone 2)',
            onTap: () => _showPrototypeSnackbar(context, 'Remove Menu Item'),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: 'Reports', theme: theme),
          const SizedBox(height: 8),
          _ActionTile(
            icon: Icons.bar_chart,
            title: 'Daily Orders Summary',
            subtitle: 'View order counts and revenue (Milestone 2)',
            onTap: () =>
                _showPrototypeSnackbar(context, 'Daily Orders Summary'),
          ),
          _ActionTile(
            icon: Icons.people_outline,
            title: 'Staff Activity',
            subtitle: 'Monitor staff order handling (Milestone 2)',
            onTap: () => _showPrototypeSnackbar(context, 'Staff Activity'),
          ),
          const SizedBox(height: 20),
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Full menu CRUD and reporting are planned for Milestone 2 '
                      'with Firebase Firestore integration.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
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

  void _showPrototypeSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature: available in Milestone 2'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.theme});
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
