import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beyond_admin/main.dart';

void main() {
  testWidgets('abre o painel', (tester) async {
    await tester.pumpWidget(const BeyondAdmin());
    expect(find.text('Tudo no ar.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
