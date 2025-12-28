
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/inventory_list.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Manage your inventory',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/add-product'),
              icon: const Icon(Icons.add),
              label: const Text('Add New Book'),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'My Inventory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: InventoryList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
