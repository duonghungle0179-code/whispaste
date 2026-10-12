import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/core/l10n/locale_native_name.dart';
import 'package:whispaste/widgets/language_selector.dart';

import '../fixtures/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vietnamese-only picker shows Vietnamese on existing installs', (
    tester,
  ) async {
    await tester.pumpWidget(
      makeTestable(
        WpLanguageSelector(currentLocale: 'en', onChanged: (_) {}),
        locale: const Locale('vi'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('English'), findsNothing);
    expect(find.text('Deutsch'), findsNothing);
  });

  test('Vietnamese locale has its native name', () {
    expect(localeNativeName(const Locale('vi')), 'Tiếng Việt');
  });
}
