/// Interface settings section (theme, language, startup, etc.).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/config/settings_enums.dart';
import '../../../core/config/settings_provider.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../services/autostart_service.dart';
import '../../../widgets/section.dart';
import '../settings_widgets.dart';

class InterfaceSection extends ConsumerWidget {
  const InterfaceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final settings = ref.watch(settingsProvider).value ?? AppSettings.defaults;
    final autostartSyncError = ref.watch(autostartSyncFailureProvider);

    return WpSection(
      title: l10n.settingsInterface,
      subtitle: l10n.settingsInterfaceSubtitle,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingRow(
            icon: LucideIcons.languages,
            label: l10n.settingsAppLanguage,
            trailing: const Text('Tiếng Việt'),
          ),
          SettingRow(
            icon: LucideIcons.power,
            label: l10n.settingsLaunchAtStartup,
            trailing: settingsDropdown(
              context: context,
              value: !settings.launchAtStartup
                  ? 'never'
                  : settings.startMinimized
                  ? 'minimized'
                  : 'normal',
              items: const ['never', 'normal', 'minimized'],
              labels: [
                l10n.settingsAutostartNever,
                l10n.settingsAutostartNormal,
                l10n.settingsAutostartMinimized,
              ],
              onChanged: (v) {
                final (launch, minimized) = switch (v) {
                  'normal' => (true, false),
                  'minimized' => (true, true),
                  _ => (false, false),
                };
                ref
                    .read(settingsProvider.notifier)
                    .updateSettings(
                      // Compatibility write until legacy autostart fields are
                      // removed from AppSettings.copyWith.
                      // ignore: deprecated_member_use
                      (s) => s.copyWith(
                        launchAtStartup: launch,
                        startMinimized: minimized,
                      ),
                    );
              },
            ),
          ),
          if (autostartSyncError != null)
            _AutostartSyncFailureNotice(
              message: l10n.settingsAutostartSyncFailed,
            ),
          SettingRow(
            icon: LucideIcons.bell,
            label: l10n.settingsShowNotifications,
            semanticToggledValue: settings.showNotifications,
            trailing: settingsToggle(
              value: settings.showNotifications,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .updateSettings((s) => s.copyWith(showNotifications: v)),
            ),
          ),
          SettingRow(
            icon: LucideIcons.cpu,
            label: l10n.settingsShowBackendUtilization,
            subtitle: l10n.settingsShowBackendUtilizationSubtitle,
            semanticToggledValue: settings.interface_.showBackendUtilization,
            trailing: settingsToggle(
              value: settings.interface_.showBackendUtilization,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .updateSettings(
                    (s) => s.copyWithSections(
                      interface_: s.interface_.copyWith(
                        showBackendUtilization: v,
                      ),
                    ),
                  ),
            ),
          ),
          SettingRow(
            icon: LucideIcons.panelLeft,
            label: l10n.settingsSidePanelEnabled,
            subtitle: l10n.settingsSidePanelEnabledSubtitle,
            semanticToggledValue: settings.interface_.sidePanelEnabled,
            trailing: settingsToggle(
              value: settings.interface_.sidePanelEnabled,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .updateSettings(
                    (s) => s.copyWithSections(
                      interface_: s.interface_.copyWith(sidePanelEnabled: v),
                    ),
                  ),
            ),
          ),
          if (settings.interface_.sidePanelEnabled)
            SettingRow(
              icon: LucideIcons.panelRight,
              label: l10n.settingsSidePanelEdge,
              subtitle: l10n.settingsSidePanelEdgeSubtitle,
              trailing: settingsDropdown(
                context: context,
                value: settings.interface_.sidePanelEdge.value,
                items: const ['left', 'right'],
                labels: [
                  l10n.settingsSidePanelEdgeLeft,
                  l10n.settingsSidePanelEdgeRight,
                ],
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .updateSettings(
                      (s) => s.copyWithSections(
                        interface_: s.interface_.copyWith(
                          sidePanelEdge: SidePanelEdge.fromValue(v),
                        ),
                      ),
                    ),
              ),
            ),
          SettingRow(
            icon: LucideIcons.panelBottomClose,
            label: l10n.settingsCloseToTray,
            subtitle: l10n.settingsCloseToTraySubtitle,
            semanticToggledValue: settings.closeToTray,
            trailing: settingsToggle(
              value: settings.closeToTray,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .updateSettings((s) => s.copyWith(closeToTray: v)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline warning shown when [AutostartService] failed to register the
/// "Launch at Startup" setting with the OS.
///
/// This comment used to claim it reused the pattern of the stable-revert hint
/// in `updates_section.dart`; the two were in fact laid out differently, and a
/// third notice differed again. They now genuinely share one implementation
/// ([settingsInlineNotice]), so the claim is finally true by construction.
///
/// No dismiss action: this reflects the live sync outcome, not a one-time tip,
/// so it clears itself once a later sync succeeds.
class _AutostartSyncFailureNotice extends StatelessWidget {
  const _AutostartSyncFailureNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) =>
      settingsInlineNotice(context: context, message: message);
}
