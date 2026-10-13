import 'package:flutter/material.dart';

/// WhisPaste brand wordmark — the full logo + "Whispaste" text as a PNG image.
///
/// Use the dark-ink logo asset on WhisPaste VN's light Neumorphic frame.
/// Dark variant: light bars + white "Whis" + cyan "paste" (for dark backgrounds).
/// Light variant: dark bars + navy "Whis" + cyan "paste" (for light backgrounds).
class WpBrandWordmark extends StatelessWidget {
  const WpBrandWordmark({super.key, this.height = 28});

  /// Logical height of the wordmark image.
  final double height;

  @override
  Widget build(BuildContext context) {
    const asset = 'assets/icons/wordmark-light.png';

    return Image.asset(
      asset,
      height: height,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      excludeFromSemantics: true,
    );
  }
}
