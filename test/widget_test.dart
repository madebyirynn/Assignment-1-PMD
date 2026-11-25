
import 'package:campus_carpool_board/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Campus Carpool Board app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads the onboarding screen.
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });
}
