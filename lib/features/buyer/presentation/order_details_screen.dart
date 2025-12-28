
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Calculate Expected Delivery (Order Date + 7 Days)
    final deliveryDate = order.timestamp.add(const Duration(days: 7));
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status & ID Card
            Card(
              elevation: 0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Order #${order.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.status == 'Processing' 
                                ? Colors.orange.withOpacity(0.1) 
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: order.status == 'Processing' ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline / Dates
            Text(
              'Delivery Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDateRow(
              context, 
              icon: Icons.shopping_bag_outlined, 
              title: 'Ordered On', 
              date: dateFormat.format(order.timestamp),
              isPast: true,
            ),
            _buildConnector(context, isActive: true),
            _buildDateRow(
              context, 
              icon: Icons.local_shipping_outlined, 
              title: 'Expected Delivery', 
              date: dateFormat.format(deliveryDate),
              isPast: false,
              isHighlight: true,
            ),

             const SizedBox(height: 32),
            Text(
              'Items Ordered (${order.items.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 70,
                    color: Colors.grey[200],
                    child: item.imageUrl.isNotEmpty
                      ? Image.network(item.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.book),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Qty: ${item.quantity}'),
                  trailing: Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const Divider(height: 32),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, {
    required IconData icon, 
    required String title, 
    required String date, 
    bool isPast = false,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHighlight ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            color: isHighlight ? Theme.of(context).primaryColor : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            Text(
              date, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: isHighlight ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context, {required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(left: 22),
      height: 30,
      width: 2,
      color: isActive ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.grey[300],
    );
  }
}
