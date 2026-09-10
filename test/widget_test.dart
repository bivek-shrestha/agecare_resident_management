import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agecare_resident_management/app.dart';

Future<void> signIn(WidgetTester tester) async {
  await tester.pumpWidget(const AgeCareApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Sign in'));
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AgeCare starts on login and opens dashboard after sign in', (tester) async {
    await signIn(tester);

    expect(find.text('Resident Overview'), findsOneWidget);
    expect(find.text('Today’s Tasks'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
  });

  testWidgets('Dashboard search opens filtered resident results', (tester) async {
    await signIn(tester);

    final searchField = find.byType(TextField).first;
    await tester.enterText(searchField, 'Laxmi');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Residents'), findsWidgets);
    expect(find.text('Laxmi Shrestha'), findsOneWidget);
  });

  testWidgets('Resident can be discharged from active care', (tester) async {
    await signIn(tester);

    await tester.tap(find.text('Residents').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laxmi Shrestha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discharge'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discharge').last);
    await tester.pumpAndSettle();

    expect(find.text('Laxmi Shrestha'), findsNothing);
  });

  testWidgets('Logout returns to login screen', (tester) async {
    await signIn(tester);

    await tester.tap(find.text('Menu').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();

    expect(find.text('Staff sign in'), findsOneWidget);
  });
}
