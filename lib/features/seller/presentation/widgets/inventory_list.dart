
import 'package:flutter/material.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final books = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'price': '\$15.00',
        'stock': '12',
        'image': 'https://placehold.co/100x150/png?text=Gatsby'
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'price': '\$12.50',
        'stock': '8',
        'image': 'https://placehold.co/100x150/png?text=1984'
      },
      {
        'title': 'Flutter Apprentice',
        'author': 'Mike Katz',
        'price': '\$45.00',
        'stock': '5',
        'image': 'https://placehold.co/100x150/png?text=Flutter'
      },
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: books.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          leading: Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: NetworkImage(book['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            book['title']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book['author']!),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Stock: ${book['stock']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    book['price']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
