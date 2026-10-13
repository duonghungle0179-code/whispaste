import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/core/theme/colors.dart';
import 'package:whispaste/core/theme/theme.dart';
import 'package:whispaste/core/theme/tokens.dart';

void main() {
  double contrastRatio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final high = la > lb ? la : lb;
    final low = la > lb ? lb : la;
    return (high + 0.05) / (low + 0.05);
  }

  test('the runtime skin is a light, low-glare lavender palette', () {
    expect(wpNeumorphicTheme().brightness, Brightness.light);
    expect(WpColors.background, const Color(0xFFF0F0FA));
    expect(WpColors.cardFill.computeLuminance(),
        greaterThan(WpColors.background.computeLuminance()));
    expect(WpColors.textPrimary.computeLuminance(),
        lessThan(WpColors.background.computeLuminance()));
    expect(WpColors.frameGradient.colors, hasLength(4));
    expect(WpColors.warmSurfaceGradient.colors, hasLength(3));
  });

  test('filled buttons remain legible on the lavender interaction accent', () {
    expect(
      contrastRatio(const Color(0xFFFFFFFF), WpColors.accent),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(WpColors.textPrimary, WpColors.cardFill),
      greaterThanOrEqualTo(7.0),
    );
  });

  test('dark palette remains available as a reference (no data migration)', () {
    expect(WpColorsDark.background, const Color(0xFF0B122A));
    expect(WpShadows.softRaised, hasLength(2));
  });
}
