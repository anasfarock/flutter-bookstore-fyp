
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
}
