
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/inventory_list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/inventory_provider.dart';

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'All';

  final List<String> _genreOptions = [
    'All',
    'Fiction',
    'Non-fiction',
    'Mystery',
    'Fantasy',
    'Science Fiction',
    'Biography',
    'History',
    'Romance',
    'Thriller',
    'Technology',
    'Children',
  ];

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);
    final int lowStockCount = inventoryAsync.maybeWhen(
      data: (books) => books.where((b) => b.quantity < 5).length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/store-profile'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1, // Header and controls takes less space
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (lowStockCount > 0)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            const SizedBox(width: 12),
                            Text(
                              '$lowStockCount items are low on stock!',
                              style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Icon(Icons.storefront, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Manage your inventory',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.push('/add-product'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Book'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/seller-orders'),
                          icon: const Icon(Icons.inbox),
                          label: const Text('Incoming Orders'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Inventory',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGenre,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  items: _genreOptions.map((String genre) {
                                    return DropdownMenuItem<String>(
                                      value: genre,
                                      child: Text(
                                        genre,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedGenre = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2, // Inventory list takes more space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InventoryList(
                  searchQuery: _searchQuery,
                  selectedGenre: _selectedGenre,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
