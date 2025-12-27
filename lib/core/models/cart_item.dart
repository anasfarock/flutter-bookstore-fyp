
import 'book.dart';

class CartItem {
  final Book book;
  final int quantity;

  CartItem({required this.book, this.quantity = 1});

  CartItem copyWith({Book? book, int? quantity}) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => book.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'book': book.toMap(), // Store full book snapshot or just ID? Snapshot is safer for price changes.
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      book: Book.fromMap(map['book'] ?? {}, map['book']['id'] ?? ''),
      quantity: map['quantity'] ?? 1,
    );
  }
}
