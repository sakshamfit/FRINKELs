import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frinkels/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays FRINKELs title and tagline', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SplashScreen()));

    // Initial render check
    expect(find.text('FRINKELs'), findsOneWidget);
    expect(find.text('Everyone is a Professional'), findsOneWidget);
  });
}
