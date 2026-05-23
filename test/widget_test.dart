import 'package:flutter_test/flutter_test.dart';
import 'package:transbdg_app/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const TransBdgApp());
    expect(find.byType(TransBdgApp), findsOneWidget);
  });
}
