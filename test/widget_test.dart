import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_law_zoo/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TreeLawZooApp());

    // Verify that the app loads with the home page
    expect(find.text('TREE LAW ZOO'), findsOneWidget);
    expect(find.text('ช่องทางธรรมชาติ'), findsOneWidget);
  });
}
