/// Memory-aware Whisper model retention for the VN Windows build.
///
/// Keeping the GGML model resident avoids repeated native load/warmup work.
/// The 14%-20% thresholds are a *process working-set budget*, not a target
/// allocation: allocating unused RAM cannot speed up inference.
/// GPU VRAM is separate and is not counted by ProcessInfo.currentRss.
library;

import 'dart:math' as math;

/// Effective number of minutes to retain a loaded model while idle.
///
/// - Up to 14% of system RAM: keep the model warm for up to an hour.
/// - 14%-20%: keep it warm for at least 25 minutes.
/// - Above 20%: release sooner (within five minutes).
/// - Unknown RAM reading: preserve the user's original setting.
/// - A configured zero means "never unload" and remains a user override.
///
/// This policy never pre-allocates memory and never blocks an inference.
int optimizedSttIdleMinutes({
  required int configuredMinutes,
  required int? totalRamMb,
  required int processResidentBytes,
}) {
  if (configuredMinutes <= 0 || totalRamMb == null || totalRamMb <= 0) {
    return configuredMinutes;
  }
  if (processResidentBytes <= 0) return configuredMinutes;

  final usedFraction = processResidentBytes / (totalRamMb * 1024 * 1024);
  if (usedFraction <= 0.14) return math.max(configuredMinutes, 60);
  if (usedFraction <= 0.20) return math.max(configuredMinutes, 25);
  return math.min(configuredMinutes, 5);
}
