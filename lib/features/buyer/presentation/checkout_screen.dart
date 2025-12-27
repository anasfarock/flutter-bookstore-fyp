import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:my_app/core/providers/cart_provider.dart';
import 'package:my_app/core/models/order_model.dart';
import 'package:my_app/features/buyer/data/order_repository.dart';
import 'package:my_app/features/auth/data/auth_repository.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final totalAmount = ref.watch(cartTotalProvider);
    final cartItemsAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                 color: Theme.of(context).cardColor,
                 borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total to Pay'),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                final user = ref.read(authRepositoryProvider).currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to checkout')));
                  return;
                }

                // Get current cart items
                final cartItems = cartItemsAsync.value ?? [];
                if (cartItems.isEmpty) return;

                setState(() => _isLoading = true);
                
                try {
                  final orderId = const Uuid().v4();
                  final order = OrderModel(
                    id: orderId,
                    userId: user.uid,
                    items: cartItems,
                    totalAmount: totalAmount,
                    status: 'Processing',
                    timestamp: DateTime.now(),
                  );

                  // Create Order
                  await ref.read(orderRepositoryProvider).createOrder(order);
                  
                  // Clear Cart
                  await ref.read(cartProvider.notifier).clearCart();

                  if (mounted) {
                     setState(() => _isLoading = false);
                     
                     showDialog(
                       context: context, 
                       barrierDismissible: false,
                       builder: (context) => AlertDialog(
                         title: const Text('Order Placed!'),
                         content: const Text('Your order has been successfully placed.'),
                         actions: [
                           TextButton(
                             onPressed: () {
                               context.go('/buyer-home');
                             }, 
                             child: const Text('Continue Shopping'),
                           ),
                         ],
                       ),
                     );
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
                  }
                }
              },
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
