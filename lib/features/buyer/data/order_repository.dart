
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    print('DEBUG: Starting transaction for order ${order.id}');
    return _firestore.runTransaction((transaction) async {
      try {
        // 1. Read all book documents first (Firestore requires all reads before any writes)
        final Map<String, DocumentSnapshot> bookSnapshots = {};
        
        for (final item in order.items) {
          print('DEBUG: Reading book ${item.id}');
          final bookRef = _firestore.collection('books').doc(item.id);
          final snapshot = await transaction.get(bookRef);
          bookSnapshots[item.id] = snapshot;
        }

        // 2. Validate stock for all items
        for (final item in order.items) {
          final snapshot = bookSnapshots[item.id];
          
          if (snapshot == null || !snapshot.exists) {
            throw Exception('Book "${item.title}" is no longer available.');
          }

          final data = snapshot.data() as Map<String, dynamic>?;
          final currentQuantity = data?['quantity'] as int? ?? 1;
          print('DEBUG: Checking stock for ${item.title} (${item.id}). Request: ${item.quantity}, Available: $currentQuantity');
          
          if (currentQuantity < item.quantity) {
            throw Exception('Insufficient stock for "${item.title}". Only $currentQuantity left.');
          }
        }

        // 3. Decrement stock (All writes happen after reads)
        for (final item in order.items) {
          final snapshot = bookSnapshots[item.id]!;
          final data = snapshot.data() as Map<String, dynamic>?;
          final currentQuantity = data?['quantity'] as int? ?? 1;
          final bookRef = _firestore.collection('books').doc(item.id);
          
          final newQuantity = currentQuantity - item.quantity;
          print('DEBUG: Updating stock for ${item.id}. New: $newQuantity');
          transaction.update(bookRef, {'quantity': newQuantity});
        }

        // 4. Create Order
        final orderRef = _firestore.collection('orders').doc(order.id);
        transaction.set(orderRef, order.toMap());
        print('DEBUG: Transaction actions queued.');
      } catch (e, stack) {
        print('DEBUG: Transaction Error: $e');
        print(stack);
        rethrow;
      }
    });
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<OrderModel>> getSellerOrders(String sellerId) {
    return _firestore
        .collection('orders')
        .where('sellerIds', arrayContains: sellerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});
