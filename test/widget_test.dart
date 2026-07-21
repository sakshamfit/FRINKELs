import 'package:flutter_test/flutter_test.dart';
import 'package:frinkels/main.dart';

void main() {
  testWidgets('FrinkelsApp smoke test renders splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FrinkelsApp());
    expect(find.text('FRINKELs'), findsOneWidget);
  });
}
