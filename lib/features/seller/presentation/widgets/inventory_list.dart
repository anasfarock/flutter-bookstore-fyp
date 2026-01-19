
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/providers/inventory_provider.dart';
import 'package:my_app/core/models/book.dart';

class InventoryList extends ConsumerWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsyncValue = ref.watch(inventoryProvider);

    return inventoryAsyncValue.when(
      data: (books) {
        if (books.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No products added yet.\nTap "+" to add your first book.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                onTap: () {
                   context.push('/product-details/${book.id}', extra: book);
                },
                contentPadding: const EdgeInsets.all(8),
                leading: Container(
                  width: 50,
                  height: 80,
                  color: Colors.grey[800],
                  child: book.imageUrls.isNotEmpty
                      ? Image.network(
                          book.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.book),
                        )
                      : const Icon(Icons.book),
                ),
                title: Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (book.quantity < 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Low Stock: Only ${book.quantity} left',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${book.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push('/add-product', extra: book);
                    } else if (value == 'delete') {
                      ref.read(inventoryProvider.notifier).deleteBook(book.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book Deleted')),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading inventory: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
