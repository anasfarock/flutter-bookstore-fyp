
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/book.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(Book book) {
    // Check if book already exists
    final existingIndex = state.indexWhere((item) => item.book.id == book.id);
    if (existingIndex >= 0) {
      // Increment quantity
      final oldItem = state[existingIndex];
      // Create new list to trigger notify (immutability)
      state = [
        ...state.sublist(0, existingIndex),
        oldItem.copyWith(quantity: oldItem.quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [...state, CartItem(book: book)];
    }
  }

  void removeFromCart(String bookId) {
    state = state.where((item) => item.book.id != bookId).toList();
  }

  void incrementQuantity(String bookId) {
     final existingIndex = state.indexWhere((item) => item.book.id == bookId);
     if (existingIndex >= 0) {
       final oldItem = state[existingIndex];
       state = [
        ...state.sublist(0, existingIndex),
        oldItem.copyWith(quantity: oldItem.quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
     }
  }

  void decrementQuantity(String bookId) {
    final existingIndex = state.indexWhere((item) => item.book.id == bookId);
    if (existingIndex >= 0) {
      final oldItem = state[existingIndex];
      if (oldItem.quantity > 1) {
         state = [
        ...state.sublist(0, existingIndex),
        oldItem.copyWith(quantity: oldItem.quantity - 1),
        ...state.sublist(existingIndex + 1),
      ];
      } else {
        removeFromCart(bookId);
      }
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
