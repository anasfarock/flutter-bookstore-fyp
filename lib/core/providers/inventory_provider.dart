
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';

class InventoryNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    // Initial Mock Data
    return [
      Book(
        id: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        price: 15.00,
        imageUrl: 'https://placehold.co/100x150/png?text=Gatsby',
        description: 'Classic novel.',
      ),
      Book(
        id: '2',
        title: '1984',
        author: 'George Orwell',
        price: 12.50,
        imageUrl: 'https://placehold.co/100x150/png?text=1984',
        description: 'Dystopian fiction.',
      ),
      Book(
        id: '3',
        title: 'Flutter Apprentice',
        author: 'Mike Katz',
        price: 45.00,
        imageUrl: 'https://placehold.co/100x150/png?text=Flutter',
        description: 'Learn Flutter.',
      ),
    ];
  }

  void addBook(Book book) {
    state = [...state, book];
  }

  void updateBook(Book updatedBook) {
    state = [
      for (final book in state)
        if (book.id == updatedBook.id) updatedBook else book
    ];
  }

  void deleteBook(String bookId) {
    state = state.where((book) => book.id != bookId).toList();
  }
}

final inventoryProvider = NotifierProvider<InventoryNotifier, List<Book>>(InventoryNotifier.new);
