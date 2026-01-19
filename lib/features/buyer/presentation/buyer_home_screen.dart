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

  // Filter State
  RangeValues _selectedPriceRange = const RangeValues(0, 500); 
  double _minRating = 0;
  List<String> _selectedGenres = [];

  // Helper to process (Filter + Sort) books
  List<Book> _processBooks(List<Book> books) {
    if (books.isEmpty) return [];
    
    // 1. Filter
    var filteredBooks = books.where((book) {
      // Genre Filter
      if (_selectedGenres.isNotEmpty && !_selectedGenres.contains(book.genre)) {
        return false;
      }
      // Price Filter
      if (book.price < _selectedPriceRange.start || book.price > _selectedPriceRange.end) {
        return false;
      }
      // Rating Filter
      if (book.rating < _minRating) {
        return false;
      }
      return true;
    }).toList();

    // 2. Sort
    final sortedBooks = List<Book>.from(filteredBooks); // Create mutable copy
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
        // Keep original order
        break;
    }
    return sortedBooks;
  }

  void _showFilterModal(BuildContext context, List<Book> allBooks) {
    // Calculate dynamic values
    double maxPrice = 100;
    if (allBooks.isNotEmpty) {
      final maxBookPrice = allBooks.map((e) => e.price).reduce((a, b) => a > b ? a : b);
      maxPrice = (maxBookPrice / 10).ceil() * 10.0 + 10; // Round up to nearest 10 + buffer
    }
    
    final allGenres = allBooks.map((e) => e.genre).toSet().toList()..sort();

    // Temp state for the modal
    RangeValues tempPriceRange = _selectedPriceRange;
    // ensure temp range is within sensible bounds if maxPrice changed drastically
    if (tempPriceRange.end > maxPrice) {
      tempPriceRange = RangeValues(tempPriceRange.start, maxPrice);
    }
    
    double tempMinRating = _minRating;
    List<String> tempSelectedGenres = List.from(_selectedGenres);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempPriceRange = RangeValues(0, maxPrice);
                                tempMinRating = 0;
                                tempSelectedGenres = [];
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // Price Range
                            const Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            RangeSlider(
                              values: tempPriceRange,
                              min: 0,
                              max: maxPrice,
                              divisions: 20,
                              labels: RangeLabels(
                                '\$${tempPriceRange.start.round()}',
                                '\$${tempPriceRange.end.round()}',
                              ),
                              onChanged: (RangeValues values) {
                                setModalState(() {
                                  tempPriceRange = values;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$${tempPriceRange.start.toStringAsFixed(0)}'),
                                Text('\$${tempPriceRange.end.toStringAsFixed(0)}'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Rating
                            const Text('Minimum Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Slider(
                              value: tempMinRating,
                              min: 0,
                              max: 5,
                              divisions: 5,
                              label: tempMinRating.toString(),
                              onChanged: (value) {
                                setModalState(() {
                                  tempMinRating = value;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Any'),
                                Text('${tempMinRating.toInt()}+ Stars'),
                                const Text('5 Stars'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Genres
                            const Text('Genres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: allGenres.map((genre) {
                                final isSelected = tempSelectedGenres.contains(genre);
                                return FilterChip(
                                  label: Text(genre),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    setModalState(() {
                                      if (selected) {
                                        tempSelectedGenres.add(genre);
                                      } else {
                                        tempSelectedGenres.remove(genre);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedPriceRange = tempPriceRange;
                              _minRating = tempMinRating;
                              _selectedGenres = tempSelectedGenres;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filter',
            onPressed: () {
               final books = booksAsync.asData?.value ?? [];
              _showFilterModal(context, books);
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

          final processedBooks = _processBooks(books);
          
          if (processedBooks.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.filter_list_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No books match your filters.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                   TextButton(
                    onPressed: () {
                       setState(() {
                         _selectedPriceRange = const RangeValues(0, 500);
                         _minRating = 0;
                         _selectedGenres = [];
                       });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: processedBooks.length,
            itemBuilder: (context, index) {
              final book = processedBooks[index];
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
                                    color: Colors.deepPurple[50], // Light background for genre
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    book.genre,
                                    style: const TextStyle(
                                      color: Colors.deepPurple, // Distinct color for genre text
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
                                color: Colors.grey[600], // Light grey for price
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
