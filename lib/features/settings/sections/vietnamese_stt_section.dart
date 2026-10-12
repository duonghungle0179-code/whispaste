/// The small STT settings surface for WhisPaste VN.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/config/settings_provider.dart';
import '../../../services/model_download_service.dart';
import '../../../widgets/section.dart';

class VietnameseSpeechRecognitionSection extends ConsumerWidget {
  const VietnameseSpeechRecognitionSection({super.key});
  static const _modelId = 'whisper-small';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value ?? AppSettings.defaults;
    final downloads = ref.watch(modelDownloadProvider);
    final installed = downloads.downloadedModels.contains(_modelId);
    final selected = settings.effectiveModelId == _modelId;
    final downloading = downloads.isBusy && downloads.activeModelId == _modelId;

    return WpSection(
      title: 'Nhận diện tiếng Việt',
      subtitle: 'Whisper chạy offline. Không cần API key hay chọn 99 ngôn ngữ.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.languages, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('Ngôn ngữ nhận diện: Tiếng Việt (vi)')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Mô hình ưu tiên: Whisper Small (nhanh, phù hợp nhập liệu)'),
          const SizedBox(height: 8),
          if (downloading) ...[
            LinearProgressIndicator(
              value: downloads.progressPercent > 0
                  ? downloads.progressPercent / 100.0
                  : null,
            ),
            const SizedBox(height: 8),
            Text('Đang tải mô hình: ' +
                downloads.progressPercent.round().toString() + '%'),
          ] else if (installed && selected)
            const Text('Whisper Small đã sẵn sàng. Nhấn F8 để ghi âm.')
          else if (installed)
            FilledButton(
              onPressed: () => ref.read(settingsProvider.notifier)
                  .updateSettings((s) => s.copyWith(sttModel: _modelId)),
              child: const Text('Dùng Whisper Small'),
            )
          else
            FilledButton.icon(
              onPressed: downloads.isBusy
                  ? null
                  : () => ref.read(modelDownloadProvider.notifier)
                      .downloadModel(_modelId),
              icon: const Icon(LucideIcons.download, size: 18),
              label: const Text('Tải mô hình Whisper Small'),
            ),
          if (downloads.isError && downloads.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              'Không tải được mô hình: ' + downloads.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Đọc: "Số sáu mươi mốt kết luận Trung ương, '
            'ngày ba tháng mười hai năm hai nghìn lẻ chín" '
            'để được: "Số 61-KL/TW, ngày 3/12/2009".',
          ),
        ],
      ),
    );
  }
}
