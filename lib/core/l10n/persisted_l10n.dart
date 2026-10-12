import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart';

/// Secondary Flutter engines (overlay / floating button / side panel) have no
/// settings provider. The Vietnamese edition must use the same locale there.
Future<L10n> resolvePersistedL10n() async => lookupL10n(const Locale('vi'));
