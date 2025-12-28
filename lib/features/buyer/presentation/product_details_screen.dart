import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/book.dart';
import '../../../core/providers/cart_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../seller/data/product_repository.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String bookId;
  final Book? book;

  const ProductDetailsScreen({
    super.key, 
    required this.bookId, 
    this.book,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookStream = ref.watch(productRepositoryProvider).getBook(bookId);

    return Scaffold(
      body: StreamBuilder<Book?>(
        stream: bookStream,
        initialData: book,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final currentBook = snapshot.data;

          if (currentBook == null) {
            return const Center(child: Text('Book not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: currentBook.imageUrl.isNotEmpty 
                    ? Image.network(
                        currentBook.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => Container(color: Colors.grey),
                      )
                    : Container(color: Colors.grey),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                currentBook.title,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '\$${currentBook.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            print('DEBUG: ProductDetails - StoreName: "${currentBook.storeName}" for book: ${currentBook.title}');
                            return const SizedBox.shrink(); 
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentBook.author, 
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        if (currentBook.storeName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.store, size: 16, color: Colors.blueGrey),
                                const SizedBox(width: 4),
                                Text(
                                  currentBook.storeName,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Overview',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentBook.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 100), 
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
      bottomSheet: StreamBuilder<Book?>(
        stream: bookStream, 
        initialData: book,
        builder: (context, snapshot) {
           final currentBook = snapshot.data;
           if (currentBook == null) return const SizedBox.shrink();

           // Check if current user is the seller
           final currentUser = ref.watch(authRepositoryProvider).currentUser;
           final isSeller = currentUser != null && currentUser.uid == currentBook.sellerId;

           if (isSeller) {
             return Container(
               padding: const EdgeInsets.all(16),
               color: Theme.of(context).scaffoldBackgroundColor, // Match background
               child: const Text(
                 'You are the seller of this item',
                 textAlign: TextAlign.center,
                 style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
               ),
             );
           }

           return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addToCart(currentBook);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${currentBook.title} to cart')),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
