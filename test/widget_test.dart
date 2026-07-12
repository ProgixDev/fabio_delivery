// Basic smoke test for the Fabio home screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fabio/main.dart';

void main() {
  testWidgets('Fabio home screen renders the header and search bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FabioApp());
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.textContaining('Bonjour'), findsOneWidget);
    expect(find.text('Rechercher un restaurant ou un plat'), findsOneWidget);

    final scrollable = find.byType(ListView).first;

    await tester.dragUntilVisible(
      find.text('Restaurants populaires'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Restaurants populaires'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Près de chez vous'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Près de chez vous'), findsOneWidget);
  });
}
