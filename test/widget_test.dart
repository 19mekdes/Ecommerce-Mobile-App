import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/widgets/product_card.dart';

/// Builds the exact same badge wiring used by HomeScreen's AppBar
/// (a Consumer<CartProvider> reading totalItems) above a real ProductCard.
Widget buildHomeLikeUi(List<Product> products) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartProvider.totalItems > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          key: const Key('cart_badge'),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartProvider.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            for (final product in products)
              ProductCard(product: product, onTap: () {}),
          ],
        ),
      ),
    ),
  );
}

Product makeProduct(int id) {
  return Product(
    id: id,
    title: 'Test Product $id',
    price: 9.99,
    description: 'A test product',
    category: 'electronics',
    image: 'https://example.com/image$id.png',
    rating: Rating(rate: 4.5, count: 10),
  );
}

void main() {
  testWidgets('Add to Cart on home card increments the cart badge',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final products = [makeProduct(1), makeProduct(2)];
    await tester.pumpWidget(buildHomeLikeUi(products));
    await tester.pumpAndSettle();

    // No badge before adding anything.
    expect(find.byKey(const Key('cart_badge')), findsNothing);
    expect(find.text('Add to Cart'), findsNWidgets(2));

    // Tap Add to Cart on the first product.
    await tester.tap(find.text('Add to Cart').first);
    await tester.pump();

    // Badge appears with 1 and the button becomes "In Cart".
    expect(find.byKey(const Key('cart_badge')), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('In Cart'), findsOneWidget);

    // Tap Add to Cart on the second product.
    await tester.tap(find.text('Add to Cart').first);
    await tester.pump();

    // Badge increments to 2.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('In Cart'), findsNWidgets(2));
  });
}
