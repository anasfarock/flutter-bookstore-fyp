
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockOrders = List.generate(5, (index) => {
      'id': 'ORD-${1000 + index}',
      'date': '2025-12-${20 - index}',
      'total': (index + 1) * 25.50,
      'status': index == 0 ? 'Processing' : 'Delivered',
      'items': '${index + 1} items',
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          final isProcessing = order['status'] == 'Processing';
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
                      '${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isProcessing ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${order['status']}',
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
                Text('Date: ${order['date']}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('${order['items']}'),
                     Text(
                       '\$${(order['total'] as double).toStringAsFixed(2)}',
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
      ),
    );
  }
}
