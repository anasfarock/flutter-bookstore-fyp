
class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.rating = 4.5,
  });

  // Mock Data Factory
  static List<Book> get mockBooks => [
        Book(
          id: '1',
          title: 'The Great Gatsby',
          author: 'F. Scott Fitzgerald',
          price: 15.00,
          imageUrl: 'https://placehold.co/200x300/png?text=Gatsby',
          description: 'The story of the fabulously wealthy Jay Gatsby and his new love for the beautiful Daisy Buchanan.',
        ),
        Book(
          id: '2',
          title: '1984',
          author: 'George Orwell',
          price: 12.50,
          imageUrl: 'https://placehold.co/200x300/png?text=1984',
          description: 'Among the seminal texts of the 20th century, Nineteen Eighty-Four is a rare work that grows more haunting as its futuristic purgatory becomes more real.',
        ),
        Book(
          id: '3',
          title: 'Flutter Apprentice',
          author: 'Mike Katz',
          price: 45.00,
          imageUrl: 'https://placehold.co/200x300/png?text=Flutter',
          description: 'Build for iOS and Android with Flutter!',
        ),
        Book(
          id: '4',
          title: 'Clean Code',
          author: 'Robert C. Martin',
          price: 32.00,
          imageUrl: 'https://placehold.co/200x300/png?text=Clean+Code',
          description: 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees.',
        ),
         Book(
          id: '5',
          title: 'The Pragmatic Programmer',
          author: 'Andrew Hunt',
          price: 38.50,
          imageUrl: 'https://placehold.co/200x300/png?text=Pragmatic',
          description: 'The Pragmatic Programmer cuts through the increasing specialization and technicalities of modern software development.',
        ),
      ];
}
