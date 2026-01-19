import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/book.dart';
import '../../seller/data/all_books_provider.dart';
import 'widgets/book_search_delegate.dart';

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingLowToHigh,
  ratingHighToLow,
}

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  SortOption _currentSortOption = SortOption.relevance;

  List<Book> _sortBooks(List<Book> books) {
    if (books.isEmpty) return [];
    
    // Create a copy to avoid modifying the original list
    final sortedBooks = List<Book>.from(books);

    switch (_currentSortOption) {
      case SortOption.priceLowToHigh:
        sortedBooks.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        sortedBooks.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingLowToHigh:
        sortedBooks.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortOption.ratingHighToLow:
        sortedBooks.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.relevance:
      default:
        // Keep original order (or random/default from DB)
        break;
    }
    return sortedBooks;
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(allBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookstore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final books = booksAsync.asData?.value ?? [];
              showSearch(
                context: context,
                delegate: BookSearchDelegate(books),
              );
            },
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: (SortOption result) {
              setState(() {
                _currentSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.relevance,
                child: Text('Relevance'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.priceLowToHigh,
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.priceHighToLow,
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.ratingHighToLow,
                child: Text('Rating: High to Low'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.ratingLowToHigh,
                child: Text('Rating: Low to High'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/buyer-profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(child: Text('No books available for sale.'));
          }

          final sortedBooks = _sortBooks(books);

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: sortedBooks.length,
            itemBuilder: (context, index) {
              final book = sortedBooks[index];
              return GestureDetector(
                onTap: () {
                  context.push('/product-details/${book.id}', extra: book);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: book.imageUrls.isNotEmpty
                            ? Image.network(
                                book.imageUrls.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.grey[800],
                                  child: const Center(child: Icon(Icons.book, size: 50)),
                                ),
                              )
                            : Container(
                                color: Colors.grey[800],
                                child: const Center(child: Icon(Icons.book, size: 50)),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    book.genre,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.star, size: 14, color: Colors.amber[700]),
                                const SizedBox(width: 2),
                                Text(
                                  book.rating.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                             if (book.storeName.isNotEmpty)
                               Padding(
                                 padding: const EdgeInsets.only(top: 4),
                                 child: Text(
                                   book.storeName,
                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                     color: Colors.blueGrey,
                                     fontStyle: FontStyle.italic,
                                   ),
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                               ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${book.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
