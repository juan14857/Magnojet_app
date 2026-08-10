import 'package:flutter_test/flutter_test.dart';
import 'package:magnojet_app/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MagnojetApp());
    expect(find.byType(MagnojetApp), findsOneWidget);
  });
}
