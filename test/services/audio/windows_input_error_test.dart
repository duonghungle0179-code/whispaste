import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/services/audio_service.dart';

void main() {
  group('Windows recording device diagnostics', () {
    test('recognizes the exact platform failure seen in WhisPaste VN', () {
      final exception = PlatformException(
        code: 'Record',
        message: 'No audio recording device was found.',
      );
      expect(isMissingAudioInputDevice(exception), isTrue);
    });

    test('does not confuse missing input with microphone access', () {
      expect(isMissingAudioInputDevice(
        PlatformException(code: 'Record', message: 'Permission denied'),
      ), isFalse);
      expect(isMissingAudioInputDevice(
        PlatformException(code: 'Record', message: 'Device is in use'),
      ), isFalse);
      expect(isMissingAudioInputDevice(Exception('recording failed')), isFalse);
    });
  });
}
