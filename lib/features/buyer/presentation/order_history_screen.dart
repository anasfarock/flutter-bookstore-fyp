import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/features/buyer/data/order_repository.dart';
import 'package:my_app/features/auth/data/auth_repository.dart';
import 'package:my_app/core/models/order_model.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login to view orders')));
    }

    final ordersStream = ref.watch(orderRepositoryProvider).getUserOrders(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: StreamBuilder<List<OrderModel>>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              final isProcessing = order.status == 'Processing';
              return Container(
                padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.id.substring(0, 8).toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isProcessing ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: isProcessing ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Date: ${order.timestamp.toString().split(' ')[0]}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('${order.items.length} items'),
                         Text(
                           '\$${order.totalAmount.toStringAsFixed(2)}',
                           style: TextStyle(
                             color: Theme.of(context).primaryColor,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}
