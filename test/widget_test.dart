import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrotrilho_app/main.dart';

void main() {
  testWidgets('App renders the animal list screen', (WidgetTester tester) async {
    await tester.pumpWidget(AgrotrilhoApp());

    // Verify the app bar title is displayed.
    expect(find.text('Agrotrilho 🚜'), findsOneWidget);

    // Verify the empty state message.
    expect(find.text('Nenhum animal cadastrado'), findsOneWidget);

    // Verify the FAB is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
