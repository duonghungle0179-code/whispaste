import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// WhisPaste VN is a Vietnamese-only edition. Respect this setting even when
/// upgrading an existing WhisPaste database with a saved English locale.
final localeProvider = Provider<Locale>((ref) => const Locale('vi'));
