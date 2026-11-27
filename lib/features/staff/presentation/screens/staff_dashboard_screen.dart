import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/presentation/providers/order_providers.dart';

/// Staff Dashboard — displays incoming orders and allows prototype
/// status updates (placed → preparing → ready → completed).
///
/// Owned by Yared Gebre (Member 4).
/// Real-time Firestore sync is deferred to Milestone 2.
class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: orders.isEmpty
          ? _buildEmpty(theme)
          : _buildOrderList(context, ref, orders, theme),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 72,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('No orders yet', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'New customer orders will appear here.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ── Order list ───────────────────────────────────────────────────────────

  Widget _buildOrderList(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> orders,
    ThemeData theme,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(
          order: order,
          onStatusChange: (newStatus) {
            ref
                .read(orderProvider.notifier)
                .updateStatus(order.id as String, newStatus);
          },
        );
      },
    );
  }
}

// ── Order Card ─────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onStatusChange});

  final dynamic order;
  final void Function(OrderStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = order.status as OrderStatus;
    final orderId = order.id as String;
    final customerName = order.customerName as String;
    final totalPrice = order.totalPrice as double;
    final waitMinutes = order.estimatedWaitMinutes as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
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
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              customerName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '~$waitMinutes min',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  'ETB ${totalPrice.toStringAsFixed(0)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Status action buttons
            if (status.isActive) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildActions(context, status),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, OrderStatus status) {
    final next = _nextStatus(status);
    if (next == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            key: ValueKey('action_${next.name}'),
            onPressed: () => onStatusChange(next),
            icon: Icon(_iconFor(next), size: 18),
            label: Text('Mark as ${next.label}'),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => onStatusChange(OrderStatus.cancelled),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  OrderStatus? _nextStatus(OrderStatus current) {
    switch (current) {
      case OrderStatus.placed:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return OrderStatus.completed;
      default:
        return null;
    }
  }

  IconData _iconFor(OrderStatus status) {
    switch (status) {
      case OrderStatus.preparing:
        return Icons.kitchen;
      case OrderStatus.ready:
        return Icons.check_circle_outline;
      case OrderStatus.completed:
        return Icons.done_all;
      default:
        return Icons.arrow_forward;
    }
  }
}

// ── Status Chip ────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  Color _color(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case OrderStatus.placed:
        return cs.primary;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return cs.onSurfaceVariant;
      case OrderStatus.cancelled:
        return cs.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
