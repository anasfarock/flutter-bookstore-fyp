
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());
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
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});
