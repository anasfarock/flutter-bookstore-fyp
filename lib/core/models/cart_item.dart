
import 'book.dart';

class CartItem {
  final Book book;
  final int quantity;

  CartItem({
    required this.book,
    required this.quantity,
  });

  // Forwarding getters for compatibility
  String get id => book.id;
  String get title => book.title;
  double get price => book.price;
  String get imageUrl => book.imageUrl;

  CartItem copyWith({
    Book? book,
    int? quantity,
  }) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => book.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'book': book.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // Handle nested book map
    final bookMap = map['book'] as Map<String, dynamic>? ?? {};
    // If book is missing (e.g. migration issue), we might crash or need a fallback.
    // For now assume valid data or empty book.
    return CartItem(
      book: Book.fromMap(bookMap, bookMap['id'] ?? ''),
      quantity: map['quantity'] ?? 1,
    );
  }
}
