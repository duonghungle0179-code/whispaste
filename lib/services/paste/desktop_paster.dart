import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../clipboard_history/app_clipboard.dart';
import '../desktop_paste/desktop_paste_controller.dart';
import 'paster.dart';

final _log = AppLogger('DesktopPaster');

/// [Paster] implementation for Windows and macOS using [DesktopPasteController].
///
/// Implements the full paste lifecycle:
/// - Blocklist check via bundle ID
/// - Classic clipboard save → set transcript → native paste → wait →
///   clipboard restore sequence, on every platform — this is the default,
///   not a fallback. If the native paste shortcut doesn't land (e.g. an app
///   that only reacts to direct keystrokes), macOS/Windows retry once via
///   direct Unicode typing (see [typeText]) — skipped for multi-line text
///   (see [requiresRealPaste]), since typing delivers "\n" as a literal
///   Return keydown some apps read as "submit". Linux stays on the classic
///   sequence only; it has no native typeText handler to fall back to.
///
/// The choice of native mechanism is an implementation detail: from the
/// user's perspective there is one "paste" action, regardless of which of
/// the two channels actually delivered the text.
class DesktopPaster implements Paster {
  const DesktopPaster(
    this._controller, {
    this.restoreInBackground = false,
    @visibleForTesting this.restoreDelayOverride,
  });

  final DesktopPasteController _controller;

  /// Windows VN: report paste completion as soon as native Ctrl+V succeeds,
  /// then restore the old clipboard after the original safety delay.
  /// Other platforms and existing callers retain the synchronous contract.
  final bool restoreInBackground;

  @visibleForTesting
  final Duration? restoreDelayOverride;

  // Prevent a previous paste's delayed restore from clobbering the current
  // paste. A clipboard change by the user is checked separately below.
  static int _clipboardPasteGeneration = 0;
  static String? _pendingTransientText;
  static String? _originalClipboardBeforePendingPaste;

  @override
  Future<void> prime() async {
    try {
      await _controller.capturePasteTarget();
    } on MissingPluginException catch (e) {
      // Not available in test environments — silently degrade.
      _log.debug('capturePasteTarget unavailable (MissingPlugin)', e);
    }
  }

  @override
  Future<PasteCapability> checkCapability({
    bool promptIfMissing = false,
  }) async {
    try {
      final raw = await _controller.checkCapability(
        promptIfMissing: promptIfMissing,
      );
      return PasteCapability(
        status: switch (raw.status) {
          NativeCapabilityStatus.ready => PasteCapabilityStatus.ready,
          NativeCapabilityStatus.permissionMissing =>
            PasteCapabilityStatus.permissionMissing,
          NativeCapabilityStatus.unsupported =>
            PasteCapabilityStatus.unsupported,
        },
        canPrompt: raw.canPrompt,
        detail: raw.detail,
      );
    } on MissingPluginException {
      return const PasteCapability(status: PasteCapabilityStatus.unsupported);
    } on Exception {
      return const PasteCapability(status: PasteCapabilityStatus.unsupported);
    }
  }

  @override
  Future<String?> getTargetBundleId() async {
    try {
      final id = await _controller.getTargetBundleId();
      return (id == null || id.isEmpty) ? null : id;
    } on MissingPluginException catch (e) {
      _log.debug('getTargetBundleId unavailable (MissingPlugin)', e);
      return null;
    }
  }

  /// Returns [PasteOutcome.blocked] when the captured target's bundle ID is
  /// on [blocklist]; `null` otherwise (including when the lookup is
  /// unsupported or the target ID is unavailable). Shared by [paste] and
  /// [typeText] — both gate on the same blocklist.
  Future<PasteOutcome?> _checkBlocklist(String blocklist) async {
    final trimmed = blocklist.trim();
    if (trimmed.isEmpty) return null;
    try {
      final targetId = await _controller.getTargetBundleId();
      if (targetId == null || targetId.isEmpty) return null;
      final blocked = trimmed
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toSet();
      if (blocked.contains(targetId.toLowerCase())) {
        return PasteOutcome.blocked;
      }
      return null;
    } on MissingPluginException catch (e) {
      // Bundle ID lookup unsupported — skip blocklist.
      _log.debug(
        'getTargetBundleId unavailable (MissingPlugin) — blocklist skipped',
        e,
      );
      return null;
    }
  }

  /// Maps a non-success [NativePasteResult] to the matching [PasteOutcome].
  /// Shared by [paste] and [typeText] — both native bridges report the same
  /// status vocabulary.
  PasteOutcome _mapFailure(NativePasteResult result) => switch (result.status) {
    NativePasteStatus.noTarget => PasteOutcome.noTarget,
    NativePasteStatus.permissionMissing => PasteOutcome.permissionMissing,
    NativePasteStatus.foregroundBlocked => PasteOutcome.elevationBlocked,
    _ => PasteOutcome.failed,
  };

  @override
  Future<PasteOutcome> paste(String text, PasteOptions options) async {
    final thisPaste = ++_clipboardPasteGeneration;

    // 1. Blocklist check
    final blocked = await _checkBlocklist(options.blocklist);
    if (blocked != null) return blocked;

    // 2. Save current clipboard contents so we can restore after paste.
    String? previousClipboard;
    try {
      final data = await Clipboard.getData(
        Clipboard.kTextPlain,
      ).timeout(const Duration(seconds: 2));
      previousClipboard = data?.text;
    } on Exception catch (e) {
      // Best-effort snapshot; failure here is non-fatal.
      _log.debug(
        'Clipboard read before paste failed — proceeding without restore',
        e,
      );
    }

    // Rapid dictations should restore the clipboard from *before the first*
    // temporary paste, not the previous dictated sentence.
    final restoreOriginal =
        restoreInBackground && previousClipboard == _pendingTransientText
        ? (_originalClipboardBeforePendingPaste ?? '')
        : (previousClipboard ?? '');

    // 3. Write transcript to clipboard — history-excluded on platforms that
    // support it (Windows), so this transient write never becomes a new
    // Win+V/cloud-clipboard entry (issue #146).
    try {
      await _writeTransientClipboardText(
        text,
      ).timeout(const Duration(seconds: 5));
    } on Exception {
      return PasteOutcome.failed;
    }

    // 4. Trigger native paste shortcut.
    final delayMs = options.autoPasteDelayMs.clamp(0, 30000);
    final delay = Duration(milliseconds: delayMs);
    NativePasteResult pasteResult = const NativePasteResult(
      status: NativePasteStatus.unknown,
    );
    try {
      pasteResult = await _controller.pasteClipboard(delay: delay);
    } on MissingPluginException {
      return PasteOutcome.platformUnavailable;
    } on Exception {
      return PasteOutcome.failed;
    }

    // Always log the native detail string so we can diagnose silent-drop
    // scenarios where Swift reports success (CGEvent post returned, no
    // error) but the keystroke didn't actually land in the target app.
    _log.info(
      'Native paste result: status=${pasteResult.status.name} '
      'detail=${pasteResult.detail ?? "<none>"}',
    );

    if (!pasteResult.isSuccess) {
      // The native paste shortcut didn't land — retry once via direct
      // Unicode typing on macOS/Windows (some apps don't react to a
      // synthetic paste shortcut at all). Multi-line text skips this
      // retry regardless of platform: CGEvent Unicode-typing delivers
      // "\n"/"\r" as a literal Return keydown, which chat UIs (ChatGPT,
      // Slack, ...) read as "submit" — better to report the paste failure
      // than risk an unwanted send. Linux's typeText routes through the
      // exact same clipboard+uinput-Ctrl+V path as pasteClipboard (no
      // layout-independent direct-typing primitive exists there either —
      // see desktop_paste_host.cc), so retrying it after a failed paste
      // would just reproduce the same failure; a failed paste there is
      // reported as-is.
      if ((Platform.isMacOS || Platform.isWindows) &&
          !requiresRealPaste(text)) {
        final typeOutcome = await _typeTextCore(text, options);
        if (typeOutcome == PasteOutcome.success) return typeOutcome;
        _log.info(
          'Fallback typing also did not land ($typeOutcome) — reporting '
          'the original paste failure',
        );
      }
      return _mapFailure(pasteResult);
    }

    // 5. Preserve the original >=500ms safety window: some target apps
    // only read the clipboard after Ctrl+V has been posted.
    final restoreWait =
        restoreDelayOverride ??
        Duration(milliseconds: math.max(500, delayMs + 350));
    if (restoreInBackground) {
      _pendingTransientText = text;
      _originalClipboardBeforePendingPaste = restoreOriginal;
      // The transcript is already inserted. Post-paste housekeeping does not
      // need to keep the "Transcribing" overlay visible for another 500ms.
      // Never restore if the user has since copied different text.
      unawaited(
        _restoreClipboardLater(
          thisPaste,
          expectedText: text,
          oldText: restoreOriginal,
          delay: restoreWait,
        ),
      );
      return PasteOutcome.success;
    }

    // Original blocking behaviour remains available for other platforms
    // and legacy API consumers.
    await Future<void>.delayed(restoreWait);
    try {
      await _writeTransientClipboardText(
        previousClipboard ?? '',
      ).timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      _log.debug('Clipboard restore after paste failed', e);
    }
    return PasteOutcome.success;
  }

  Future<void> _restoreClipboardLater(
    int generation, {
    required String expectedText,
    required String oldText,
    required Duration delay,
  }) async {
    await Future<void>.delayed(delay);
    if (generation != _clipboardPasteGeneration) return;
    try {
      final current = await Clipboard.getData(Clipboard.kTextPlain)
          .timeout(const Duration(seconds: 2));
      // Do not overwrite a fresh copy made by the user or another app.
      if (generation != _clipboardPasteGeneration ||
          current?.text != expectedText) {
        _log.debug('Skipping clipboard restore: contents changed');
        if (generation == _clipboardPasteGeneration) {
          _pendingTransientText = null;
          _originalClipboardBeforePendingPaste = null;
        }
        return;
      }
      // Clear the pending state before restoring, so a new paste after this
      // point sees its own true previous clipboard snapshot.
      _pendingTransientText = null;
      _originalClipboardBeforePendingPaste = null;
      await _writeTransientClipboardText(oldText)
          .timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      // OS history exclusion and restoration are still best effort.
      _log.debug('Deferred clipboard restore skipped: $e');
    }
  }

  /// Writes [text] to the clipboard for a transient purpose (the paste
  /// source, or restoring the user's prior clipboard right after) rather
  /// than a real user-facing copy action. Always marks WhisPaste's own
  /// self-write-suppression fingerprint first (so the app's internal
  /// clipboard-history panel doesn't record it), then prefers the native,
  /// OS-history-excluded write where the platform supports one — falling
  /// back to the plain clipboard write everywhere else.
  Future<void> _writeTransientClipboardText(String text) async {
    AppClipboard.markSelfWrite(text);
    final excluded = await _controller.writeClipboardTextExcludingHistory(text);
    if (!excluded) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  Future<PasteOutcome> typeText(String text, PasteOptions options) async {
    // 1. Blocklist check — same policy as paste().
    final blocked = await _checkBlocklist(options.blocklist);
    if (blocked != null) return blocked;
    return _typeTextCore(text, options);
  }

  /// The actual native Unicode-type call, without a blocklist check — reused
  /// by both [typeText] (which does its own check first) and [paste]'s
  /// macOS-preferred-mechanism attempt (which already checked the blocklist
  /// before calling this, so re-checking would be a redundant native round
  /// trip). No clipboard involved, so there is nothing to save/restore.
  Future<PasteOutcome> _typeTextCore(String text, PasteOptions options) async {
    final delayMs = options.autoPasteDelayMs.clamp(0, 30000);
    NativePasteResult typeResult = const NativePasteResult(
      status: NativePasteStatus.unknown,
    );
    try {
      typeResult = await _controller.typeText(
        text,
        delay: Duration(milliseconds: delayMs),
      );
    } on MissingPluginException {
      return PasteOutcome.platformUnavailable;
    } on Exception {
      return PasteOutcome.failed;
    }

    _log.info(
      'Native type result: status=${typeResult.status.name} '
      'detail=${typeResult.detail ?? "<none>"}',
    );

    if (!typeResult.isSuccess) {
      return _mapFailure(typeResult);
    }

    return PasteOutcome.success;
  }
}

final pasterProvider = Provider<Paster?>((ref) {
  final controller = ref.watch(desktopPasteControllerProvider);
  if (controller == null) return null;
  return DesktopPaster(
    controller,
    restoreInBackground: Platform.isWindows,
  );
});
