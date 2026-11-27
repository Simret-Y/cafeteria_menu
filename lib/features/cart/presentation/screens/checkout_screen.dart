import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../auth/presentation/providers/auth_form_providers.dart';
import '../../../menu/presentation/widgets/meal_visual.dart';
import '../../domain/entities/checkout_order.dart';
import '../providers/cart_providers.dart';

/// Checkout screen with customer pickup validation, payment selection, and
/// prototype order submission.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentName = ref.read(customerDisplayNameProvider) ?? '';
    _nameController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No items to check out',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text('Back to Menu'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pickup Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('checkout_name_field'),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: FormValidators.fullName,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('checkout_phone_field'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '0911223344',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: FormValidators.phone,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('checkout_note_field'),
                      controller: _noteController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Pickup Note (Optional)',
                        hintText: 'e.g., Extra napkins or mild spice',
                        prefixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payment Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<PaymentMethod>(
                      groupValue: cart.selectedPaymentMethod,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(cartProvider.notifier)
                              .selectPaymentMethod(value);
                        }
                      },
                      child: Column(
                        children: [
                          for (final method in PaymentMethod.values)
                            RadioListTile<PaymentMethod>(
                              contentPadding: EdgeInsets.zero,
                              title: Text(method.label),
                              value: method,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final entry in cart.items)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${entry.menuItem.name} x${entry.quantity}',
                                      ),
                                    ),
                                    Text(
                                      MealVisual.formatPrice(entry.lineTotal),
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Estimated Wait'),
                                Text('~${cart.estimatedWaitMinutes} minutes'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  MealVisual.formatPrice(cart.totalPrice),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const ValueKey('place_order_button'),
                      onPressed: _placeOrder,
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _placeOrder() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final order = ref
        .read(cartProvider.notifier)
        .submitOrder(
          customerName: _nameController.text,
          phoneNumber: _phoneController.text,
          pickupNote: _noteController.text,
        );

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order Placed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}'),
            const SizedBox(height: 6),
            Text('Total: ${MealVisual.formatPrice(order.totalPrice)}'),
            const SizedBox(height: 6),
            Text('Estimated Wait: ~${order.estimatedWaitMinutes} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRoutes.home);
            },
            child: const Text('Back to Home'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRoutes.orderTracking);
            },
            child: const Text('Track Order'),
          ),
        ],
      ),
    );
  }
}
