import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/inventory_provider.dart'; 
import '../../auth/data/auth_repository.dart';
import '../../buyer/data/order_repository.dart';
import '../../../core/models/cart_item.dart';

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view orders')),
      );
    }

    final ordersStream = ref.watch(orderRepositoryProvider).getSellerOrders(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
      ),
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              // Filter items to show only this seller's products
              final sellerItems = order.items.where((item) => item.book.sellerId == user.uid).toList();
              
              // Calculate total for this seller
              final sellerTotal = sellerItems.fold(0.0, (sum, item) => sum + item.totalPrice);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    '${order.timestamp.toString().split('.')[0]} • \$${sellerTotal.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sellerItems.length,
                      itemBuilder: (context, itemIndex) {
                        final item = sellerItems[itemIndex];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 60,
                            color: Colors.grey[200],
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(item.imageUrl, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.book))
                                : const Icon(Icons.book),
                          ),
                          title: Text(item.title),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
