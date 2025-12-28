
class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final List<String> imageUrls;
  final String description;
  final double rating;
  final String sellerId;
  final String storeName;

  // Compatibility getter for legacy code
  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrls,
    required this.description,
    this.rating = 4.5,
    this.sellerId = '',
    this.storeName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price': price,
      'imageUrls': imageUrls,
      'description': description,
      'rating': rating,
      'sellerId': sellerId,
      'storeName': storeName,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map, String documentId) {
    return Book(
      id: documentId,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      sellerId: map['sellerId'] ?? '',
      storeName: map['storeName'] ?? '',
    );
  }

  // Mock Data Factory
  static List<Book> get mockBooks => [
        Book(
          id: '1',
          title: 'The Great Gatsby',
          author: 'F. Scott Fitzgerald',
          price: 15.00,
          imageUrls: ['https://placehold.co/200x300/png?text=Gatsby'],
          description: 'The story of the fabulously wealthy Jay Gatsby and his new love for the beautiful Daisy Buchanan.',
          sellerId: 'mock_seller',
        ),
        Book(
          id: '2',
          title: '1984',
          author: 'George Orwell',
          price: 12.50,
          imageUrls: ['https://placehold.co/200x300/png?text=1984'],
          description: 'Among the seminal texts of the 20th century, Nineteen Eighty-Four is a rare work that grows more haunting as its futuristic purgatory becomes more real.',
          sellerId: 'mock_seller',
        ),
        Book(
          id: '3',
          title: 'Flutter Apprentice',
          author: 'Mike Katz',
          price: 45.00,
          imageUrls: ['https://placehold.co/200x300/png?text=Flutter'],
          description: 'Build for iOS and Android with Flutter!',
          sellerId: 'mock_seller',
        ),
        Book(
          id: '4',
          title: 'Clean Code',
          author: 'Robert C. Martin',
          price: 32.00,
          imageUrls: ['https://placehold.co/200x300/png?text=Clean+Code'],
          description: 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees.',
          sellerId: 'mock_seller',
        ),
         Book(
          id: '5',
          title: 'The Pragmatic Programmer',
          author: 'Andrew Hunt',
          price: 38.50,
          imageUrls: ['https://placehold.co/200x300/png?text=Pragmatic'],
          description: 'The Pragmatic Programmer cuts through the increasing specialization and technicalities of modern software development.',
          sellerId: 'mock_seller',
        ),
      ];
}
