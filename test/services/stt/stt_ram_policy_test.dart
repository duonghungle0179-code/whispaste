import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/services/stt/stt_ram_policy.dart';

void main() {
  int bytesFromFraction(double fraction, int totalMb) =>
      (fraction * totalMb * 1024 * 1024).round();

  group('optimizedSttIdleMinutes', () {
    test('does not allocate memory or modify unknown-RAM policy', () {
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 10,
          totalRamMb: null,
          processResidentBytes: 1024 * 1024 * 1024,
        ),
        10,
      );
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 10,
          totalRamMb: 16384,
          processResidentBytes: 0,
        ),
        10,
      );
    });

    test('retains warm model for 60 min when RSS is within 14%', () {
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 5,
          totalRamMb: 16384,
          processResidentBytes: bytesFromFraction(0.10, 16384),
        ),
        60,
      );
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 90,
          totalRamMb: 16384,
          processResidentBytes: bytesFromFraction(0.14, 16384),
        ),
        90,
      );
    });

    test('keeps a warm model for 25 min between 14% and 20%', () {
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 5,
          totalRamMb: 8192,
          processResidentBytes: bytesFromFraction(0.17, 8192),
        ),
        25,
      );
    });

    test('falls back to short idle when process exceeds 20%', () {
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 40,
          totalRamMb: 8192,
          processResidentBytes: bytesFromFraction(0.25, 8192),
        ),
        5,
      );
    });

    test('respects an explicit user keep-alive override', () {
      expect(
        optimizedSttIdleMinutes(
          configuredMinutes: 0,
          totalRamMb: 8192,
          processResidentBytes: bytesFromFraction(0.25, 8192),
        ),
        0,
      );
    });
  });
}
