import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/inventory_provider.dart'; 
import '../../auth/data/auth_repository.dart';
import '../../buyer/data/order_repository.dart';
import '../../../core/models/cart_item.dart';

final sellerOrdersProvider = StreamProvider.family<List<OrderModel>, String>((ref, sellerId) {
  return ref.watch(orderRepositoryProvider).getSellerOrders(sellerId);
});

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  Future<void> _exportToCsv(BuildContext context, List<OrderModel> orders, String sellerId) async {
    if (orders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No orders to export')),
      );
      return;
    }

    try {
      List<List<dynamic>> rows = [];
      // Headers
      rows.add([
        'Order ID',
        'Date',
        'Book Title',
        'Quantity',
        'Unit Price',
        'Total Price',
        'Buyer ID'
      ]);

      // Data
      for (final order in orders) {
        final sellerItems = order.items.where((item) => item.book.sellerId == sellerId).toList();
        
        for (final item in sellerItems) {
          rows.add([
            order.id,
            order.timestamp.toString(),
            item.title,
            item.quantity,
            item.price.toStringAsFixed(2),
            item.totalPrice.toStringAsFixed(2),
            order.userId,
          ]);
        }
      }

      final csvData = const ListToCsvConverter().convert(rows);
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/seller_orders.csv';
      final file = File(path);
      await file.writeAsString(csvData);

      if (context.mounted) {
        await Share.shareXFiles([XFile(path)], text: 'Here are your orders.');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting CSV: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view orders')),
      );
    }

    final ordersAsync = ref.watch(sellerOrdersProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export CSV',
            onPressed: () {
              final orders = ordersAsync.asData?.value ?? [];
              _exportToCsv(context, orders, user.uid);
            },
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
