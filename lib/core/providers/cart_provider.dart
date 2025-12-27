
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/book.dart';
import '../../features/buyer/data/cart_repository.dart';
import '../../features/auth/data/auth_repository.dart';

class CartNotifier extends StreamNotifier<List<CartItem>> {
  @override
  Stream<List<CartItem>> build() {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return ref.watch(cartRepositoryProvider).getCartKey(user.uid);
  }

  Future<void> addToCart(Book book) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(cartRepositoryProvider).addToCart(user.uid, book);
    }
  }

  Future<void> removeFromCart(String bookId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(cartRepositoryProvider).removeFromCart(user.uid, bookId);
    }
  }

  Future<void> incrementQuantity(String bookId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(cartRepositoryProvider).updateQuantity(user.uid, bookId, 1);
    }
  }

  Future<void> decrementQuantity(String bookId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(cartRepositoryProvider).updateQuantity(user.uid, bookId, -1);
    }
  }

  Future<void> clearCart() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(cartRepositoryProvider).clearCart(user.uid);
    }
  }
}

final cartProvider = StreamNotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

// Helper for total amount to keep UI clean
final cartTotalProvider = Provider<double>((ref) {
  final cartAsync = ref.watch(cartProvider);
  return cartAsync.maybeWhen(
    data: (items) => items.fold(0.0, (sum, item) => sum + item.totalPrice),
    orElse: () => 0.0,
  );
});
