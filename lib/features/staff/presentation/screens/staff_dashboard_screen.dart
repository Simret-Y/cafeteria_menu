import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../providers/staff_providers.dart';

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(cartProvider).placedOrders;
    final statuses = ref.watch(staffOrderStatusProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Scan Pickup QR',
            onPressed: () => context.go(AppRoutes.qrScanner),
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${orders.length} incoming order${orders.length == 1 ? '' : 's'}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (orders.isEmpty)
            const _EmptyOrders()
          else
            for (final order in orders) ...[
              _StaffOrderCard(
                orderId: order.orderId,
                customerName: order.customerName,
                status:
                    statuses[order.orderId] ?? OrderPreparationStatus.received,
                items: order.items
                    .map((item) => '${item.menuItem.name} x${item.quantity}')
                    .join(', '),
                waitMinutes: order.estimatedWaitMinutes,
                onStatusChanged: (status) => ref
                    .read(staffOrderStatusProvider.notifier)
                    .updateStatus(order.orderId, status),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48),
            SizedBox(height: 8),
            Text('No incoming orders'),
          ],
        ),
      ),
    );
  }
}

class _StaffOrderCard extends StatelessWidget {
  const _StaffOrderCard({
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.items,
    required this.waitMinutes,
    required this.onStatusChanged,
  });

  final String orderId;
  final String customerName;
  final OrderPreparationStatus status;
  final String items;
  final int waitMinutes;
  final ValueChanged<OrderPreparationStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    orderId,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(status.label),
                  avatar: const Icon(Icons.timelapse, size: 18),
                ),
              ],
            ),
            Text(customerName, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(items),
            const SizedBox(height: 8),
            Text(
              'Estimated wait: $waitMinutes min',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (status == OrderPreparationStatus.received)
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          onStatusChanged(OrderPreparationStatus.preparing),
                      child: const Text('Start Preparing'),
                    ),
                  ),
                if (status == OrderPreparationStatus.preparing)
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          onStatusChanged(OrderPreparationStatus.ready),
                      child: const Text('Mark Ready'),
                    ),
                  ),
                if (status == OrderPreparationStatus.ready)
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () =>
                          onStatusChanged(OrderPreparationStatus.collected),
                      child: const Text('Collected'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
