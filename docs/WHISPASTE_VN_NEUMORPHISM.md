# WhisPaste VN — Light Neumorphism / Soft Lilac UI

> A code-based Flutter skin inspired by the lavender-white Soft UI reference.
> No screenshot is used as the app background. The original transcription,
> microphone, clipboard, hotkeys, history and data services are unchanged.

## Coverage

- Main window: window frame, page background, text styles, top bar and
  navigation rail.
- Shared widgets: filled/outline buttons, dropdowns, search inputs, edit
  fields, filter chips, segmented selectors, row actions and list surfaces.
- Pages: History (list/grid), Settings, Analytics, About, Notes (shared list),
  Snippets and Text Replacements.
- Floating windows: dictation capsule and floating microphone palette.
- Status colors: recording, processing, success and error remain distinct.

## Palette

| Material | Hex |
| --- | --- |
| Ambient light lavender | `#F0F0FA` |
| Primary floating card | `#F9F9FE` |
| Elevated card | `#FFFFFF` |
| Recessed field | `#E6E8F5 → #FAFAFF` |
| Primary ink | `#30364E` |
| Secondary ink | `#656B88` |
| Interactive lavender (AA white label) | `#6268C9` |
| Selected nav pill | `#E8EAFD → #D7DCF6` |

Soft UI depth uses paired shadows (lower-right lavender-grey, upper-left white).
Active controls retain visible focus strokes; only visual surfaces change.

## Where to edit

- `lib/core/theme/colors.dart` — `WpColorsNeumorphic` and `WpColors` alias.
  `WpColorsDark` remains untouched as a reference / regression baseline.
- `lib/core/theme/theme.dart` — `wpNeumorphicTheme()`, Material 3 light mode.
- `lib/core/theme/tokens.dart` — radii, `WpShadows.softRaised*` tokens.
- `lib/widgets/` — reusable buttons, input fields, list tiles, chips, rail.
- `lib/core/theme/overlay_design_spec.dart` — floating mic / overlay colors.
- `test/core/theme/neumorphism_vn_test.dart` — contrast and palette checks.

## Functionality and safety

- No STT / Whisper / Vulkan / recordings / history database code was changed.
- No GitHub Actions workflow was run. Workflow dispatch remains manual.
- Current EXE is unchanged. This branch must be tested and built before
  installing a Windows package.
- Existing dark-only golden images and palette-specific upstream design gates
  may require updated expected values. The new Light Neumorphism contract is
  covered by dedicated tests, but those tests have not been executed yet.
- The static screenshot provides no exact spacing/shadow engineering values.
  Pixel parity needs a real Flutter render and screenshot comparison later.

## Local verification (not executed on GitHub)

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test test/core/theme/neumorphism_vn_test.dart
flutter test test/widgets/list_tile_surface_consistency_test.dart
flutter test test/core/design/depth_source_test.dart
flutter test test/core/theme/overlay_design_spec_test.dart
flutter build windows --release
```

The build is deliberately **not** part of these source edits.
