import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:civar/app.dart';

void main() {
  testWidgets('App boots to onboarding welcome screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CivarApp()));
    await tester.pumpAndSettle();

    expect(find.text('Civar'), findsOneWidget);
    expect(find.text('Başla'), findsOneWidget);
  });
}
