import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/core/theme/tokens.dart';

/// WhisPaste VN Soft UI depth contract.
///
/// The dark-only "no in-plane shadow" rule was replaced by soft raised
/// material. The surface shadow has two opposing light directions, while
/// semantic recording/status colors are handled by the palette.
void main() {
  const surfaces = <String>[
    'lib/widgets/sidebar.dart',
    'lib/widgets/wp_button.dart',
    'lib/widgets/wp_list_tile_surface.dart',
    'lib/widgets/wp_filter_chip.dart',
    'lib/features/history/widgets/history_card_view.dart',
    'lib/features/settings/settings_page.dart',
    'lib/features/analytics/analytics_page.dart',
    'lib/features/about/about_page.dart',
    'lib/features/snippets/snippets_page.dart',
    'lib/features/replacements/replacements_page.dart',
  ];

  test('every intentional raised surface uses the shared shadow tokens', () {
    for (final path in surfaces) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path must exist');
      final code = file
          .readAsStringSync()
          .replaceAll(RegExp(r'//.*$', multiLine: true), '');
      expect(
        code.contains('WpShadows.softRaised') ||
            code.contains('WpShadows.softRaisedSmall') ||
            code.contains('WpShadows.softRaisedHover'),
        isTrue,
        reason: '$path must use shared soft relief, not ad-hoc black shadows',
      );
    }
  });

  test('soft-raised shadows have opposing light and shade directions', () {
    for (final shadows in <List<BoxShadow>>[
      WpShadows.softRaised,
      WpShadows.softRaisedSmall,
      WpShadows.softRaisedHover,
    ]) {
      expect(shadows, hasLength(2));
      expect(shadows.first.offset.dx, greaterThan(0));
      expect(shadows.first.offset.dy, greaterThan(0));
      expect(shadows.last.offset.dx, lessThan(0));
      expect(shadows.last.offset.dy, lessThan(0));
      expect(shadows.first.blurRadius, greaterThan(0));
      expect(shadows.last.blurRadius, greaterThan(0));
      // Avoid expensive diffuse full-window glows.
      expect(shadows.first.spreadRadius, 0);
      expect(shadows.last.spreadRadius, 0);
    }
  });

  test('shared list keeps the quiet panel variant', () {
    final source = File('lib/widgets/wp_list_tile_surface.dart')
        .readAsStringSync();
    expect(source, contains('WpListTileVariant.panel'));
    expect(source, contains('isSelected'));
    expect(source, contains('WpShadows.softRaisedSmall'));
  });
}
