
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/main.dart'; // Ensure this points to where BookstoreApp is defined

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Buyer flow: Login -> Browse -> Add to Cart -> Checkout',
      (WidgetTester tester) async {
    // 1. Load the app
    await tester.pumpWidget(const ProviderScope(child: BookstoreApp()));
    await tester.pumpAndSettle();

    // 1.5 Navigate to Register
    final signUpLink = find.text('Don\'t have an account? Sign Up');
    expect(signUpLink, findsOneWidget);
    await tester.tap(signUpLink);
    await tester.pumpAndSettle();

    // 2. Mock Login as Buyer
    // Find the 'Sign Up as Buyer (Test)' button
    final buyerLink = find.text('Sign Up as Buyer (Test)');
    expect(buyerLink, findsOneWidget);
    await tester.tap(buyerLink);
    await tester.pumpAndSettle();

    // 3. Verify Home Screen
    expect(find.text('Discover Books'), findsOneWidget);
    
    // 4. Click on the first book (assuming grid view)
    // We'll find the first InkWell or GestureDetector or just text of a known mock book
    final firstBook = find.text('Flutter Apprentice'); // From Mock Data
    expect(firstBook, findsOneWidget);
    await tester.tap(firstBook);
    await tester.pumpAndSettle();

    // 5. Verify Product Details
    expect(find.text('Overview'), findsOneWidget);

    // 6. Add to Cart
    final addToCartBtn = find.text('Add to Cart');
    expect(addToCartBtn, findsOneWidget);
    await tester.tap(addToCartBtn);
    await tester.pump(); // SnackBar animation
    
    // 7. Go to Cart
    final cartIcon = find.byIcon(Icons.shopping_cart_outlined);
    expect(cartIcon, findsOneWidget);
    await tester.tap(cartIcon);
    await tester.pumpAndSettle();

    // 8. Verify Cart Screen
    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Flutter Apprentice'), findsOneWidget); // Item is in cart

    // 9. Proceed to Checkout=
    // Wait for SnackBar to dismiss (it might block the bottom button)
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    final checkoutBtn = find.text('Proceed to Checkout');
    // await tester.scrollUntilVisible(checkoutBtn, 100); // Button is fixed at bottom
    await tester.tap(checkoutBtn);
    await tester.pumpAndSettle();

    // 10. Checkout Screen
    expect(find.text('Checkout'), findsOneWidget);
    final placeOrderBtn = find.text('Place Order');
    await tester.tap(placeOrderBtn);
    
    // Wait for the simulated network delay (2 seconds)
    await tester.pump(const Duration(seconds: 2)); 
    await tester.pumpAndSettle();

    // 11. Verify Success Dialog
    expect(find.text('Order Placed!'), findsOneWidget);
    
    // 12. Close Dialog
    await tester.tap(find.text('Continue Shopping'));
    await tester.pumpAndSettle();

    // 13. Back at Home
    expect(find.text('Discover Books'), findsOneWidget);
  });
}
