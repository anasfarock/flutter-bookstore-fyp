
import 'package:flutter/material.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookstore')),
      body: const Center(
        child: Text('Welcome to the Bookstore!'),
      ),
    );
  }
}
