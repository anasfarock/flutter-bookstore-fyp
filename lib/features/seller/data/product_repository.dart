
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/models/book.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository(this._firestore);
  
  String generateId() => _firestore.collection('books').doc().id;

  // Add Product
  Future<void> addBook(Book book) async {
    // If id is empty or new, we might want to let Firestore generate it,
    // but our Book model requires an ID. 
    // Usually we generate ID first or let Firestore do it then update object.
    // Here we assume ID is provided or we use the one passed.
    await _firestore.collection('books').doc(book.id).set(book.toMap());
  }

  // Update Product
  Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update(book.toMap());
  }

  // Delete Product
  Future<void> deleteBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).delete();
  }

  // Get Seller's Products
  Stream<List<Book>> getSellerBooks(String sellerId) {
    return _firestore
        .collection('books')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
    });
  }
  
  // Get All Products (for Buyer)
  Stream<List<Book>> getAllBooks() {
    return _firestore.collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get Single Book
  Stream<Book?> getBook(String bookId) {
    return _firestore.collection('books').doc(bookId).snapshots().map((doc) {
      if (doc.exists) {
        return Book.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(FirebaseFirestore.instance);
});
