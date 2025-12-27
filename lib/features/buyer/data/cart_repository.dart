
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/cart_item.dart';
import '../../../core/models/book.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CartItem>> getCartKey(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
    });
  }

  Future<void> addToCart(String userId, Book book) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart').doc(book.id);
    final doc = await cartRef.get();

    if (doc.exists) {
      final currentQuantity = doc.data()?['quantity'] ?? 0;
      await cartRef.update({'quantity': currentQuantity + 1});
    } else {
      await cartRef.set(CartItem(book: book, quantity: 1).toMap());
    }
  }

  Future<void> removeFromCart(String userId, String bookId) async {
    await _firestore.collection('users').doc(userId).collection('cart').doc(bookId).delete();
  }

  Future<void> updateQuantity(String userId, String bookId, int change) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart').doc(bookId);
    final doc = await cartRef.get();

    if (doc.exists) {
      final currentQuantity = doc.data()?['quantity'] ?? 0;
      final newQuantity = currentQuantity + change;

      if (newQuantity <= 0) {
        await cartRef.delete();
      } else {
        await cartRef.update({'quantity': newQuantity});
      }
    }
  }

  Future<void> clearCart(String userId) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart');
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});
