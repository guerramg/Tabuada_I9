import 'package:flutter_test/flutter_test.dart';
import 'package:tabuadai9/app.dart';

void main() {
  testWidgets('Mathi9 splash smoke test', (tester) async {
    await tester.pumpWidget(const Mathi9App());
    expect(find.textContaining('Mathi9'), findsWidgets);
  });
}
