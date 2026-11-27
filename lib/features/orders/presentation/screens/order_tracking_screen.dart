import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../cart/domain/entities/checkout_order.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../providers/order_providers.dart';

/// Displays real-time tracking for the most recently placed order.
///
/// On first render it registers the [CheckoutOrder] with [OrderNotifier]
/// so that status updates (e.g. from the staff dashboard) propagate here
/// reactively. When no order has been placed yet a prompt is shown instead.
class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Register the last checkout order with OrderNotifier (safe to call
    // multiple times — duplicates are silently ignored).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lastOrder = ref.read(cartProvider).lastPlacedOrder;
      if (lastOrder != null) {
        ref.read(orderProvider.notifier).trackFromCheckout(lastOrder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final latestOrder = ref.watch(latestOrderProvider);
    final lastCheckoutOrder = ref.watch(cartProvider).lastPlacedOrder;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Order Tracking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: latestOrder == null && lastCheckoutOrder == null
          ? _buildNoOrder(context)
          : _buildTrackingBody(context, latestOrder, lastCheckoutOrder),
    );
  }

  // ── No order view ──────────────────────────────────────────────────────

  Widget _buildNoOrder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          const Text(
            'No active order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Place an order from the menu to\ntrack it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Main tracking body ─────────────────────────────────────────────────

  Widget _buildTrackingBody(
    BuildContext context,
    Order? trackedOrder,
    CheckoutOrder? checkoutOrder,
  ) {
    // Use tracked order status if available, otherwise show 'placed'.
    final status = trackedOrder?.status ?? OrderStatus.placed;
    final orderId = trackedOrder?.id ?? checkoutOrder?.orderId ?? '';
    final customerName =
        trackedOrder?.customerName ?? checkoutOrder?.customerName ?? '';
    final totalPrice =
        trackedOrder?.totalPrice ?? checkoutOrder?.totalPrice ?? 0.0;
    final waitMinutes =
        trackedOrder?.estimatedWaitMinutes ??
        checkoutOrder?.estimatedWaitMinutes ??
        10;
    final items = trackedOrder?.items ?? checkoutOrder?.items ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OrderHeader(orderId: orderId, customerName: customerName),
          const SizedBox(height: 20),
          if (status == OrderStatus.cancelled)
            _CancelledBanner()
          else
            _StatusStepper(currentStatus: status),
          const SizedBox(height: 20),
          _WaitTimeCard(
            minutes: waitMinutes,
            status: status,
          ),
          const SizedBox(height: 20),
          _OrderSummaryCard(
            items: items,
            totalPrice: totalPrice,
          ),
          const SizedBox(height: 20),
          _QrPlaceholderCard(
            orderId: orderId,
            isReady: status == OrderStatus.ready,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Order header ───────────────────────────────────────────────────────────

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.orderId, required this.customerName});

  final String orderId;
  final String customerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                orderId,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'For $customerName',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status stepper ─────────────────────────────────────────────────────────

class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.currentStatus});

  final OrderStatus currentStatus;

  static const _steps = [
    OrderStatus.placed,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.completed,
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = currentStatus.stepIndex;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _steps.length; i++) ...[
            _StepRow(
              status: _steps[i],
              isCompleted: i < currentStep,
              isActive: i == currentStep,
            ),
            if (i < _steps.length - 1) _StepConnector(filled: i < currentStep),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.status,
    required this.isCompleted,
    required this.isActive,
  });

  final OrderStatus status;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color circleColor = isCompleted
        ? const Color(0xFF22C55E)
        : isActive
            ? const Color(0xFF6366F1)
            : const Color(0xFF334155);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : isActive
                    ? const _PulsingDot()
                    : Icon(
                        Icons.circle_outlined,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 14,
                      ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          status.label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : isCompleted
                    ? const Color(0xFF22C55E)
                    : Colors.white.withValues(alpha: 0.4),
            fontWeight:
                isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 24,
        color: filled ? const Color(0xFF22C55E) : const Color(0xFF334155),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Wait time card ─────────────────────────────────────────────────────────

class _WaitTimeCard extends StatelessWidget {
  const _WaitTimeCard({required this.minutes, required this.status});

  final int minutes;
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final bool done = !status.isActive;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              done ? Icons.check_circle_outline : Icons.access_time_rounded,
              color: done
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFF59E0B),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                done ? 'Order Complete' : 'Est. Wait Time',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                done ? 'Thank you!' : '$minutes min',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Order summary card ─────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.items, required this.totalPrice});

  final List<dynamic> items;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          ...items.map((item) {
            final name = item.menuItem.name as String;
            final qty = item.quantity as int;
            final lineTotal = item.lineTotal as double;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$qty×',
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'ETB ${lineTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Text(
                'ETB ${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── QR placeholder card ────────────────────────────────────────────────────

class _QrPlaceholderCard extends StatelessWidget {
  const _QrPlaceholderCard({required this.orderId, required this.isReady});

  final String orderId;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReady
              ? const Color(0xFF22C55E).withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code_2,
                color: isReady
                    ? const Color(0xFF22C55E)
                    : Colors.white.withValues(alpha: 0.4),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isReady ? 'Show QR to Staff' : 'QR Code (available when ready)',
                style: TextStyle(
                  color: isReady
                      ? const Color(0xFF22C55E)
                      : Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomPaint(
            size: const Size(140, 140),
            painter: _QrPatternPainter(
              active: isReady,
              seed: orderId.hashCode,
            ),
          ),
          if (!isReady) ...[
            const SizedBox(height: 12),
            Text(
              'Your QR code will appear here\nwhen your order is ready for pickup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Paints a simple deterministic grid pattern that mimics a QR code.
class _QrPatternPainter extends CustomPainter {
  const _QrPatternPainter({required this.active, required this.seed});

  final bool active;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final color = active
        ? const Color(0xFF22C55E)
        : const Color(0xFF334155);

    final paint = Paint()..color = color;
    const cells = 11;
    final cell = size.width / cells;

    int hash = seed.abs();
    for (int r = 0; r < cells; r++) {
      for (int c = 0; c < cells; c++) {
        hash = (hash * 1664525 + 1013904223) & 0xFFFFFFFF;
        // Always draw the three finder-pattern corners.
        final inCorner =
            (r < 3 && c < 3) ||
            (r < 3 && c >= cells - 3) ||
            (r >= cells - 3 && c < 3);
        final draw = inCorner || (hash & 1) == 1;
        if (draw) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(c * cell + 1, r * cell + 1, cell - 2, cell - 2),
              const Radius.circular(1.5),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPatternPainter old) =>
      old.active != active || old.seed != seed;
}

/// Cancelled banner shown instead of stepper when order is cancelled.
class _CancelledBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 28),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Order Cancelled\nPlease contact the cafeteria for assistance.',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
