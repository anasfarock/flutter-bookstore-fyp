import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/book.dart';
import 'product_repository.dart';

final allBooksProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(productRepositoryProvider).getAllBooks();
});
