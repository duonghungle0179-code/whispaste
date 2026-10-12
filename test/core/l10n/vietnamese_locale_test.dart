import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/core/l10n/generated/app_localizations.dart';
import 'package:whispaste/features/settings/search/settings_search_entry.dart';
import 'package:whispaste/features/settings/search/settings_search_provider.dart';

void main() {
  testWidgets('Vietnamese is supported and Settings renders in Vietnamese', (
    tester,
  ) async {
    expect(
      L10n.supportedLocales.any((locale) => locale.languageCode == 'vi'),
      isTrue,
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: L10n.supportedLocales,
        localizationsDelegates: L10n.localizationsDelegates,
        home: Builder(
          builder: (context) => Text(L10n.of(context).pageSettingsTitle),
        ),
      ),
    );
    expect(find.text('Cài đặt'), findsOneWidget);
  });

  test('dynamic placeholders and plural counts are localized', () {
    final vi = lookupL10n(const Locale('vi'));
    expect(vi.settingsSearchHint, 'Tìm cài đặt…');
    expect(vi.historyItemsSelected(3), 'Đã chọn 3 mục');
    expect(vi.historyTrashEmptied(1), contains('xóa 1 mục'));
    expect(vi.historyTrashEmptied(3), contains('xóa 3 mục'));
    expect(vi.settingsHistoryAutoTrashDaysLabel(2), '2 ngày');
  });

  test('settings chips and their search accept Vietnamese without accents', () {
    final stt = kSettingsSearchTable.firstWhere(
      (entry) => entry.sectionKey == 'stt',
    );
    expect(stt.title('vi'), 'Nhận diện tiếng Việt');
    final matched = matchSettingsEntries(
      kSettingsSearchTable,
      'tieng viet',
      'vi',
    );
    expect(matched.map((entry) => entry.sectionKey), contains('stt'));
  });
}
