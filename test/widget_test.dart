import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:usual_demo/controller/makeup_repository.dart';
import 'package:usual_demo/model/makeup_product.dart';
import 'package:usual_demo/view/makeup_products_page.dart';

class FakeMakeupRepository implements MakeupProductDataSource {
  @override
  Future<List<MakeupProduct>> fetchProducts() async {
    return [
      const MakeupProduct(
        id: 1048,
        brand: 'colourpop',
        name: 'Lippie Pencil',
        price: '5.0',
        imageLink: 'https://example.com/product.png',
      ),
    ];
  }
}

void main() {
  testWidgets('shows makeup products from the repository', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MakeupProductsPage(repository: FakeMakeupRepository())),
    );

    await tester.pumpAndSettle();

    expect(find.text('Makeup Products'), findsOneWidget);
    expect(find.text('Lippie Pencil'), findsOneWidget);
    expect(find.text('colourpop'), findsOneWidget);
  });
}
