
import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Dashboard')),
      body: const Center(
        child: Text('Welcome, Seller!'),
      ),
    );
  }
}
