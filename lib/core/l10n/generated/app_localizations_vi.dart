// Vietnamese locale for the WhisPaste VN fork.
// Source: app_vi.arb. flutter gen-l10n refreshes this file during builds.
import 'app_localizations_en.dart';

String _renderVietnamese(String message, Map<String, Object?> arguments) {
  final output = StringBuffer();
  var index = 0;
  while (index < message.length) {
    if (message[index] != '{') {
      output.write(message[index]);
      index++;
      continue;
    }
    var last = index + 1;
    var depth = 1;
    while (last < message.length && depth > 0) {
      if (message[last] == '{') depth++;
      if (message[last] == '}') depth--;
      last++;
    }
    if (depth != 0) {
      output.write(message.substring(index));
      break;
    }
    final expression = message.substring(index + 1, last - 1);
    final pluralAt = expression.indexOf(', plural,');
    if (pluralAt >= 0) {
      final name = expression.substring(0, pluralAt).trim();
      final cases = expression.substring(pluralAt + ', plural,'.length);
      final options = <String, String>{};
      var position = 0;
      while (position < cases.length) {
        while (position < cases.length &&
            cases[position].trim().isEmpty) {
          position++;
        }
        if (position >= cases.length) break;
        final brace = cases.indexOf('{', position);
        if (brace < 0) break;
        final selector = cases.substring(position, brace).trim();
        var cursor = brace + 1;
        var caseDepth = 1;
        while (cursor < cases.length && caseDepth > 0) {
          if (cases[cursor] == '{') caseDepth++;
          if (cases[cursor] == '}') caseDepth--;
          cursor++;
        }
        if (caseDepth != 0) break;
        options[selector] = cases.substring(brace + 1, cursor - 1);
        position = cursor;
      }
      final value = arguments[name];
      final chosen = options['=' + value.toString()] ??
          ((value == 1) ? options['one'] : null) ??
          ((value == 0) ? options['zero'] : null) ??
          options['other'] ??
          '';
      output.write(_renderVietnamese(chosen, arguments));
    } else {
      final name = expression.trim();
      if (arguments.containsKey(name)) {
        output.write(arguments[name]?.toString() ?? '');
      } else {
        output.write(message.substring(index, last));
      }
    }
    index = last;
  }
  return output.toString();
}

class L10nVi extends L10nEn {
  L10nVi([String locale = 'vi']) : super(locale);
  @override
  String get appName => 'WhisPaste VN';

  @override
  String get navHistory => 'Lịch sử';

  @override
  String get navNotes => 'Ghi chú';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get navReplacements => 'Thay thế văn bản';

  @override
  String get navSnippets => 'Mẫu văn bản';

  @override
  String get navAnalytics => 'Thống kê';

  @override
  String get navAbout => 'Giới thiệu';

  @override
  String get navFeedback => 'Góp ý';

  @override
  String get pageHistoryTitle => 'Lịch sử';

  @override
  String get pageSettingsTitle => 'Cài đặt';

  @override
  String get pageReplacementsTitle => 'Thay thế văn bản';

  @override
  String get pageAnalyticsTitle => 'Thống kê';

  @override
  String get pageAboutTitle => 'Giới thiệu';

  @override
  String get pageFeedbackTitle => 'Góp ý';

  @override
  String get historyEmpty => 'Chưa có bản ghi';

  @override
  String get historyEmptyHint => 'Nhấn nút ghi âm hoặc phím tắt để bắt đầu.';

  @override
  String get historyPrivacyGateTitle => 'Đang ẩn lịch sử';

  @override
  String get historyPrivacyGateHint => 'Các bản nhận diện trước đây sẽ được ẩn cho đến khi bạn chọn hiển thị.';

  @override
  String get historyPrivacyGateShow => 'Hiện lịch sử';

  @override
  String get historySearch => 'Tìm kiếm…';

  @override
  String get historyPinned => 'Yêu thích';

  @override
  String get historyToday => 'Hôm nay';

  @override
  String get historyYesterday => 'Hôm qua';

  @override
  String get historyThisWeek => 'Tuần này';

  @override
  String get historyOlder => 'Cũ hơn';

  @override
  String get historyAll => 'Tất cả';

  @override
  String get historyTrash => 'Thùng rác';

  @override
  String get historyArchive => 'Lưu trữ';

  @override
  String get historyArchived => 'Đã lưu trữ';

  @override
  String get historyList => 'Danh sách';

  @override
  String get historyCards => 'Thẻ';

  @override
  String get historyCompact => 'Thu gọn';

  @override
  String get historyMerge => 'Gộp';

  @override
  String get historyRestore => 'Khôi phục';

  @override
  String get historyDeleteForever => 'Xóa vĩnh viễn';

  @override
  String get historyDeletePermanently => 'Xóa vĩnh viễn';

  @override
  String get historyUnarchive => 'Bỏ lưu trữ';

  @override
  String get historyExport => 'Xuất';

  @override
  String get historyExportAction => 'Xuất…';

  @override
  String get historyCopyAsMarkdown => 'Sao chép dạng Markdown';

  @override
  String get historyDetail => 'Chi tiết';

  @override
  String get historyTags => 'Nhãn';

  @override
  String get historyDuration => 'Thời lượng';

  @override
  String get historyModel => 'Mô hình';

  @override
  String get historyWords => 'Số từ';

  @override
  String get historyCharacters => 'Ký tự';

  @override
  String get historyReadingTimeUnder1 => 'Đọc chưa đến 1 phút';

  @override
  String get historyEditing => 'Đang chỉnh sửa';

  @override
  String get historySearchTranscriptions => 'Tìm bản nhận diện…';

  @override
  String get historySearchFieldLabel => 'Tìm bản nhận diện';

  @override
  String get historyNewRecording => 'Ghi âm mới';

  @override
  String get historyStopRecording => 'Dừng ghi âm';

  @override
  String get historyNoResults => 'Không tìm thấy kết quả';

  @override
  String get historyTrashEmpty => 'Thùng rác đang trống';

  @override
  String get historyTrashEmptyHint => 'Các bản ghi bị xóa sẽ xuất hiện ở đây.\nChúng sẽ bị xóa vĩnh viễn sau 30 ngày.';

  @override
  String get historyEmptyTrash => 'Dọn sạch thùng rác';

  @override
  String get historyEmptyTrashConfirm => 'Dọn sạch thùng rác?';

  @override
  String get historyEmptyTrashConfirmMessage => 'Toàn bộ mục trong thùng rác sẽ bị xóa vĩnh viễn. Không thể hoàn tác.';

  @override
  String get historyNoArchivedItems => 'Chưa có mục lưu trữ';

  @override
  String get historyNoArchivedItemsHint => 'Lưu trữ các bản nhận diện cần giữ nhưng không muốn hiện trong danh sách chính.';

  @override
  String get historyNoRecordingsHint => 'Nhấn nút ghi âm hoặc phím tắt để bắt đầu. Văn bản nhận diện sẽ xuất hiện ở đây.';

  @override
  String get historyNoPinned => 'Chưa có mục yêu thích';

  @override
  String get historyNoPinnedHint => 'Đánh dấu yêu thích để tìm bản nhận diện nhanh hơn.';

  @override
  String get historyNoToday => 'Hôm nay chưa ghi âm';

  @override
  String get historyNoTodayHint => 'Các bản nhận diện trong ngày sẽ xuất hiện ở đây.';

  @override
  String get historyNoThisWeek => 'Tuần này chưa ghi âm';

  @override
  String get historyNoThisWeekHint => 'Các bản nhận diện trong tuần sẽ xuất hiện ở đây.';

  @override
  String get historyCopiedToClipboard => 'Đã sao chép vào bộ nhớ tạm';

  @override
  String get historyMovedToTrash => 'Đã chuyển vào thùng rác';

  @override
  String get historyUndo => 'Hoàn tác';

  @override
  String get historyEntriesMerged => 'Đã gộp các mục';

  @override
  String get historyMergeConfirmMessage => 'Các mục được chọn sẽ gộp thành một. Không thể hoàn tác.';

  @override
  String get historyExitSelection => 'Thoát chế độ chọn';

  @override
  String get historySelectMultiple => 'Chọn nhiều mục';

  @override
  String get historyProcessed => 'Đã xử lý';

  @override
  String get historyOnDevice => 'Trên máy';

  @override
  String get historyUntitledRecording => 'Bản ghi chưa có tên';

  @override
  String get historyUntitled => 'Chưa đặt tên';

  @override
  String get historyPinToTop => 'Thêm vào yêu thích';

  @override
  String get historyUnpin => 'Bỏ yêu thích';

  @override
  String get historyCopyText => 'Sao chép văn bản';

  @override
  String get historyClose => 'Đóng';

  @override
  String get historyLanguageLabel => 'Ngôn ngữ';

  @override
  String get historySelectAll => 'Chọn tất cả';

  @override
  String get historyDeselectAll => 'Bỏ chọn tất cả';

  @override
  String get settingsInterface => 'Giao diện';

  @override
  String get settingsInterfaceSubtitle => 'Giao diện và cách hoạt động';

  @override
  String get settingsLaunchAtStartup => 'Khởi động cùng Windows';

  @override
  String get settingsStartMinimized => 'Khởi động thu nhỏ';

  @override
  String get settingsStartMinimizedSubtitle => 'Chạy nền khi khởi động hệ thống';

  @override
  String get settingsAutostartNever => 'Không bao giờ';

  @override
  String get settingsAutostartNormal => 'Bình thường';

  @override
  String get settingsAutostartMinimized => 'Thu nhỏ';

  @override
  String get settingsAutostartSyncFailed => 'Không thể đăng ký tự khởi động với hệ điều hành. Hãy kiểm tra quyền truy cập hoặc phiên bản Windows.';

  @override
  String get settingsShowNotifications => 'Hiển thị thông báo';

  @override
  String get settingsShowBackendUtilization => 'Hiển thị CPU/GPU trên thanh trạng thái';

  @override
  String get settingsShowBackendUtilizationSubtitle => 'Cho biết quá trình nhận diện đang chạy bằng CPU hay GPU và mức sử dụng';

  @override
  String get settingsAudio => 'Âm thanh';

  @override
  String get settingsAudioSubtitle => 'Micro và ghi âm';

  @override
  String get settingsMicrophone => 'Micro';

  @override
  String get settingsGain => 'Âm lượng micro';

  @override
  String get settingsClippingBanner => 'Bản ghi trước có hiện tượng vỡ tiếng. Giảm âm lượng thu?';

  @override
  String get settingsClippingDismiss => 'Bỏ qua';

  @override
  String get settingsHoldToRecord => 'Giữ để ghi âm';

  @override
  String get pushToTalkUnavailableTooltip => 'Chế độ này chưa hỗ trợ trên hệ thống';

  @override
  String get settingsHoldOrTap => 'Nhấn hoặc giữ';

  @override
  String get settingsHoldOrTapHint => 'Nhấn nhanh để bắt đầu hoặc kết thúc; giữ phím để ghi âm cho tới khi thả.';

  @override
  String get settingsSpeechRecognition => 'Nhận diện giọng nói';

  @override
  String get settingsSpeechRecognitionSubtitle => 'Chất lượng và dịch vụ nhận diện tiếng nói';

  @override
  String get settingsService => 'Dịch vụ';

  @override
  String get settingsQuality => 'Chất lượng';

  @override
  String get settingsRecordingSafety => 'An toàn ghi âm';

  @override
  String get settingsRecordingSafetySubtitle => 'Tự động kiểm tra và bảo vệ';

  @override
  String get settingsDeadMicTimeout => 'Phát hiện micro im lặng';

  @override
  String get settingsDeadMicTimeoutHint => 'Dừng ghi âm nếu không có âm thanh trong khoảng thời gian này (giây). 0 = tắt.';

  @override
  String get settingsAutoStopSilence => 'Tự dừng khi im lặng';

  @override
  String get settingsAutoStopSilenceHint => 'Tự dừng sau số giây im lặng này (kể từ khi đã nói). 0 = tắt.';

  @override
  String get settingsEnabled => 'Đã bật';

  @override
  String get settingsStyle => 'Kiểu hiển thị';

  @override
  String get settingsMicSystemDefault => 'Theo hệ thống';

  @override
  String get settingsMicSystemHint => 'Thiết bị đầu vào được quản lý trong cài đặt hệ thống';

  @override
  String get settingsServiceOnDevicePrivate => 'Xử lý ngay trên máy';

  @override
  String get settingsLanguageAutoDetect => 'Tự phát hiện';

  @override
  String get settingsLanguageEnglish => 'Tiếng Anh';

  @override
  String get settingsLanguageGerman => 'Tiếng Đức';

  @override
  String get settingsLanguageFrench => 'Tiếng Pháp';

  @override
  String get settingsLanguageSpanish => 'Tiếng Tây Ban Nha';

  @override
  String get settingsLanguageHebrew => 'Tiếng Hebrew';

  @override
  String get settingsSoundFeedback => 'Âm thanh và phản hồi';

  @override
  String get settingsSoundFeedbackSubtitle => 'Âm báo khi ghi âm';

  @override
  String get settingsSoundsEnabled => 'Âm thanh';

  @override
  String get settingsRecordStartSound => 'Âm báo bắt đầu ghi';

  @override
  String get settingsRecordStopSound => 'Âm báo dừng ghi';

  @override
  String get settingsTranscriptionCompleteSound => 'Âm báo nhận diện xong';

  @override
  String get settingsDurationWarningSound => 'Cảnh báo giới hạn thời gian';

  @override
  String get settingsSoundVolume => 'Âm lượng thông báo';

  @override
  String get settingsAfterTranscription => 'Sau khi nhận diện';

  @override
  String get settingsAfterTranscriptionSubtitle => 'Cách xử lý văn bản đã nhận diện';

  @override
  String get settingsAfterTranscriptionActionLabel => 'Hành động';

  @override
  String get settingsAfterTranscriptionClipboard => 'Sao chép vào bộ nhớ tạm';

  @override
  String get settingsAfterTranscriptionPaste => 'Tự dán tại con trỏ';

  @override
  String get settingsAfterTranscriptionBoth => 'Sao chép và tự dán';

  @override
  String get settingsAfterTranscriptionNothing => 'Không làm gì';

  @override
  String get pasteFailurePermissionMissing => 'Hệ điều hành đã chặn tự dán. WhisPaste cần quyền nhập văn bản vào ứng dụng khác; trên macOS quyền này gọi là Trợ năng.';

  @override
  String get pasteFailureNoTarget => 'Đã bỏ qua tự dán vì không tìm thấy cửa sổ đích. Hãy chọn ứng dụng cần nhập trước khi ghi âm.';

  @override
  String get pasteFailureElevationBlocked => 'Tự dán bị chặn vì ứng dụng đích đang chạy quyền quản trị. Hãy mở WhisPaste bằng quyền quản trị.';

  @override
  String get pasteFailureGeneric => 'Tự dán thất bại. Văn bản đã nằm trong bộ nhớ tạm; nhấn ⌘V / Ctrl+V để dán.';

  @override
  String get pasteFailureOpenSettings => 'Mở Cài đặt';

  @override
  String get pasteNotificationNoTargetTitle => 'WhisPaste: Bỏ qua tự dán';

  @override
  String get pasteNotificationNoTargetBody => 'Không thấy ứng dụng đích. Hãy chọn nơi cần nhập rồi bắt đầu ghi âm. Văn bản vẫn nằm trong bộ nhớ tạm.';

  @override
  String get pasteNotificationNoTargetTray => 'Tự dán: Không tìm thấy ứng dụng đích';

  @override
  String get pasteNotificationRestartNeededTitle => 'WhisPaste: Cần khởi động lại';

  @override
  String get pasteNotificationRestartNeededBody => 'Đã cấp quyền nhưng WhisPaste vẫn dùng trạng thái cũ. Nhấn để khởi động lại.';

  @override
  String get pasteNotificationRestartNeededTray => 'Tự dán bị chặn — cần khởi động lại';

  @override
  String get pasteNotificationPermissionBlockedTitle => 'WhisPaste: Tự dán bị chặn';

  @override
  String get pasteNotificationPermissionResetEntryBody => 'WhisPaste cần quyền nhập văn bản vào ứng dụng khác (Trợ năng trên macOS). Nhấn để xóa mục quyền cũ và cho macOS hỏi lại.';

  @override
  String get pasteNotificationPermissionOpenSettingsBody => 'WhisPaste cần quyền nhập văn bản vào ứng dụng khác. Nhấn vào đây hoặc biểu tượng trên khay hệ thống để mở Cài đặt.';

  @override
  String get pasteNotificationPermissionBlockedTray => 'Tự dán bị chặn — mở Cài đặt hệ thống';

  @override
  String get pasteNotificationElevationBlockedTitle => 'WhisPaste: Tự dán bị chặn';

  @override
  String get pasteNotificationElevationBlockedBody => 'Ứng dụng đích chạy quyền quản trị. Hãy khởi động WhisPaste bằng quyền quản trị để tự dán vào đó.';

  @override
  String get pasteNotificationElevationBlockedTray => 'Tự dán bị chặn — cần quyền quản trị';

  @override
  String get pasteNotificationFailedTitle => 'WhisPaste: Tự dán thất bại';

  @override
  String get pasteNotificationFailedBody => 'Hệ thống từ chối dán. Văn bản vẫn trong bộ nhớ tạm; nhấn ⌘V / Ctrl+V để dán.';

  @override
  String get pasteNotificationFailedTray => 'Tự dán thất bại';

  @override
  String get pasteCapabilityCheckTitle => 'Vui lòng chờ…';

  @override
  String get pasteCapabilityReady => 'Đã sẵn sàng';

  @override
  String get pasteCapabilityReadySubtitle => 'Văn bản sẽ xuất hiện ngay tại con trỏ.';

  @override
  String get pasteCapabilityPermissionMissing => 'Chưa được cấp quyền';

  @override
  String get pasteCapabilityUnsupported => 'Hệ thống này không hỗ trợ tự dán';

  @override
  String get pasteCapabilityTestButton => 'Thử ngay';

  @override
  String get pasteCapabilityGrantButton => 'Tiếp tục';

  @override
  String get pasteCapabilityWhyMac => 'WhisPaste cần quyền nhập văn bản vào ứng dụng bạn đang dùng; trên macOS đó là quyền Trợ năng.';

  @override
  String get pasteCapabilityTroubleshoot => 'Gặp sự cố?';

  @override
  String get pasteCapabilityRepairHint => 'Đôi khi macOS lưu quyền cũ và không nhận quyền mới. Hãy đặt lại mục này rồi cấp quyền lần nữa.';

  @override
  String get pasteCapabilityRepairButton => 'Đặt lại quyền';

  @override
  String get pasteCapabilityRestartButton => 'Khởi động lại WhisPaste';

  @override
  String get pasteCapabilityRestartTitle => 'Gần xong — hãy khởi động lại WhisPaste';

  @override
  String get pasteCapabilityRestartBody => 'Nếu đã bật quyền, macOS cần khởi động lại ứng dụng để áp dụng. WhisPaste sẽ thoát và mở lại.';

  @override
  String get pasteRestartAlertTitle => 'Khởi động lại WhisPaste';

  @override
  String get pasteRestartAlertBody => 'Đã cấp quyền tự dán nhưng macOS chỉ áp dụng sau khi khởi động lại. WhisPaste sẽ tự mở lại.';

  @override
  String get pasteRestartAlertConfirm => 'Khởi động lại';

  @override
  String get pasteManualGrantAlertTitle => 'Khởi động lại vẫn chưa giải quyết';

  @override
  String get pasteManualGrantAlertBody => 'WhisPaste đã khởi động lại nhưng quyền tự dán vẫn chưa có hiệu lực. Hãy kiểm tra Cài đặt hệ thống → Quyền riêng tư và Bảo mật → Trợ năng rồi bật lại WhisPaste.';

  @override
  String get pasteManualGrantAlertConfirm => 'Mở Cài đặt hệ thống';

  @override
  String get permissionAlertLaterButton => 'Để sau';

  @override
  String get micGateAlertTitle => 'Chưa được cấp quyền micro';

  @override
  String get micGateAlertBody => 'WhisPaste không thể ghi âm nếu chưa được cấp quyền micro. Nhấn xác nhận để mở Cài đặt hệ thống → Quyền riêng tư → Micro và bật quyền cho WhisPaste.';

  @override
  String get micGateAlertBodyGeneric => 'WhisPaste không thể ghi âm nếu chưa được cấp quyền micro. Hãy cho phép ứng dụng dùng micro trong cài đặt quyền riêng tư. WhisPaste sẽ tự phát hiện khi được cấp quyền.';

  @override
  String get micGateAlertConfirm => 'Mở Cài đặt';

  @override
  String get micGateRestartAlertTitle => 'Khởi động lại WhisPaste để hoàn tất';

  @override
  String get micGateRestartAlertBody => 'Đã cấp quyền micro nhưng phiên đang chạy chưa nhận được. WhisPaste sẽ khởi động lại; dữ liệu của bạn được giữ nguyên.';

  @override
  String get micGateRestartAlertConfirm => 'Khởi động lại';

  @override
  String get autoPasteGateAlertTitle => 'Cần bật một quyền để tự nhập chữ';

  @override
  String get autoPasteGateAlertBody => 'WhisPaste tự nhập văn bản tại con trỏ. Trên macOS, bạn cần tự bật quyền Trợ năng trong Cài đặt hệ thống → Quyền riêng tư và Bảo mật → Trợ năng.';

  @override
  String get autoPasteGateAlertConfirm => 'Mở Cài đặt hệ thống';

  @override
  String get pasteCapabilityRestartIneffectiveTitle => 'Khởi động lại chưa áp dụng quyền';

  @override
  String get pasteCapabilityRestartIneffectiveSubtitle => 'Mở lại phần quyền Trợ năng, bật WhisPaste rồi khởi động lại một lần nữa.';

  @override
  String get pasteCapabilityRepairNothingToClear => 'Không có mục cũ cần xóa. Hãy thử khởi động lại.';

  @override
  String get pasteCapabilityRepairFailed => 'Không thể đặt lại quyền trên macOS. Hãy xóa WhisPaste khỏi Cài đặt hệ thống → Trợ năng theo cách thủ công.';

  @override
  String get onboardingPasteTitle => 'Để văn bản được nhập đúng chỗ bạn đang gõ';

  @override
  String get onboardingPasteSubtitle => 'macOS sẽ hỏi quyền nhập văn bản. Hãy chọn Cho phép.';

  @override
  String get onboardingPasteSubtitleWin => 'Windows không yêu cầu quyền riêng; hãy chọn có tự chèn văn bản nhận diện hay không.';

  @override
  String get onboardingPasteChipReady => 'Sẵn sàng tự dán';

  @override
  String get onboardingPasteChipPending => 'Đang chờ quyền tự dán';

  @override
  String get onboardingPasteChipAction => 'Cần cấp quyền tự dán';

  @override
  String get onboardingPasteGrantCta => 'Cho phép tự dán';

  @override
  String get onboardingPasteSkip => 'Tạm thời chỉ sao chép, không tự nhập';

  @override
  String get onboardingPasteWhyMac => 'Nếu chưa cấp quyền, văn bản chỉ được sao chép. Hãy nhấn ⌘V để dán thủ công.';

  @override
  String get onboardingPasteWhyWin => 'Sau mỗi lần đọc, ứng dụng tự nhấn Ctrl+V để nhập văn bản vào vị trí con trỏ. Tính năng đã được kiểm tra trên máy này; hãy bật bên dưới.';

  @override
  String get onboardingPasteWhyWinUipi => 'Trong một số ứng dụng được bảo vệ bằng UIPI/UAC, tự dán có thể không hoạt động. Văn bản vẫn nằm trong bộ nhớ tạm để bạn nhấn Ctrl+V.';

  @override
  String get onboardingPasteWinOnTitle => 'Đã bật tự dán';

  @override
  String get onboardingPasteWinOnDetail => 'Sau mỗi lần đọc, WhisPaste tự nhấn Ctrl+V để nhập văn bản vào nơi đặt con trỏ và giữ một bản sao trong bộ nhớ tạm.';

  @override
  String get onboardingPasteWinEnableCta => 'Bật tự dán';

  @override
  String get onboardingPasteWinAdminCaveat => 'Ứng dụng chạy quyền quản trị có thể không nhận phím giả lập; bạn vẫn có thể dán thủ công bằng Ctrl+V.';

  @override
  String get onboardingPasteWaitingForGrantTitle => 'Đánh dấu ô bên cạnh WhisPaste';

  @override
  String get onboardingPasteWaitingForGrantHint => 'Đã mở Cài đặt hệ thống. Tìm WhisPaste trong danh sách và bật quyền. Nếu chưa có, kéo biểu tượng ứng dụng vào hoặc nhấn dấu +.';

  @override
  String get onboardingPasteTestTitle => 'Thử tự dán';

  @override
  String get onboardingPasteTestSubtitle => 'Nhấn nút thử. Văn bản mẫu phải xuất hiện ở ô bên dưới.';

  @override
  String get onboardingPasteDemoText => 'WhisPaste nhập chữ giúp bạn.';

  @override
  String get onboardingPasteTestSuccess => 'Tự dán đã hoạt động! Nhấn Tiếp theo để tiếp tục.';

  @override
  String get onboardingPasteTestNoFrontmost => 'Chưa tìm thấy ô nhập liệu. Chọn ô bên dưới rồi thử lại.';

  @override
  String get onboardingPasteTestFailure => 'Thử nghiệm thất bại. Hãy khởi động lại hoặc tiếp tục mà không thử.';

  @override
  String get onboardingPasteTestSkip => 'Tiếp tục không thử';

  @override
  String get settingsOverlayFloatingButton => 'Lớp phủ ghi âm';

  @override
  String get settingsOverlayFloatingButtonSubtitle => 'Điều chỉnh trạng thái hiển thị khi ghi âm';

  @override
  String get settingsShowOverlay => 'Hiển thị trạng thái ghi âm';

  @override
  String get settingsShowOverlaySubtitle => 'Chọn vị trí hiển thị trạng thái ghi âm trực tiếp';

  @override
  String get settingsOverlayModeFloating => 'Cửa sổ nổi (luôn hiển thị)';

  @override
  String get settingsOverlayModeOff => 'Tắt';

  @override
  String get settingsOverlayStartPosition => 'Vị trí ban đầu của lớp phủ';

  @override
  String get settingsOverlayStartPositionSubtitle => 'Vị trí cửa sổ nổi xuất hiện khi bắt đầu ghi âm';

  @override
  String get settingsOverlayStartTopCenter => 'Giữa phía trên';

  @override
  String get settingsOverlayStartBottomCenter => 'Giữa phía dưới';

  @override
  String get settingsOverlayStartLastPosition => 'Nhớ vị trí gần nhất';

  @override
  String get settingsShowFloatingButton => 'Nút ghi âm nổi';

  @override
  String get settingsShowFloatingButtonSubtitle => 'Nút luôn nổi phía trên để bắt đầu hoặc dừng ghi âm từ mọi ứng dụng';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsRecognitionLanguage => 'Ngôn ngữ nhận diện';

  @override
  String get settingsCustomVocabulary => 'Từ vựng tùy chỉnh';

  @override
  String get settingsCustomVocabularyHint => 'Tên riêng và thuật ngữ giúp cải thiện độ chính xác';

  @override
  String get settingsCustomVocabularyPlaceholder => 'Ví dụ: tên cơ quan, tên người, thuật ngữ chuyên môn';

  @override
  String get settingsPunctuationPriming => 'Gợi ý dấu câu';

  @override
  String get settingsPunctuationPrimingSubtitle => 'Giúp Whisper thêm dấu câu khi chưa có từ vựng tùy chỉnh. Không ảnh hưởng tốc độ.';

  @override
  String get settingsVadEnabled => 'Cắt khoảng im lặng cuối bản ghi';

  @override
  String get settingsVadEnabledSubtitle => 'Loại bỏ đoạn im lặng hoặc nhiễu dài ở cuối bản ghi trước khi Whisper xử lý, giúp giảm nguy cơ AI tự thêm câu không được nói.';

  @override
  String get settingsStripPunctuation => 'Xóa dấu câu';

  @override
  String get settingsStripPunctuationSubtitle => 'Xóa dấu chấm, phẩy và dấu câu khác trước khi lưu hoặc dán văn bản.';

  @override
  String get settingsNumericOnlyMode => 'Chỉ số';

  @override
  String get settingsNumericOnlyModeSubtitle => 'Chuyển số đọc bằng tiếng Anh và Đức thành chữ số; giữ nguyên nếu không chuyển được toàn bộ.';

  @override
  String get settingsAppLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get settingsSttModels => 'Mô hình nhận diện giọng nói';

  @override
  String get settingsOpenAiApiKey => 'Khóa API OpenAI';

  @override
  String get settingsDeepgramApiKey => 'Khóa API Deepgram';

  @override
  String get settingsToggleApiKeyVisibility => 'Ẩn/hiện khóa API';

  @override
  String get settingsAdvanced => 'Nâng cao';

  @override
  String get settingsAdvancedSubtitle => 'Đặt lại, báo lỗi, cập nhật và hoạt động của hệ thống';

  @override
  String get settingsResetToDefaults => 'Khôi phục mặc định';

  @override
  String get settingsResetTitle => 'Đặt lại cài đặt';

  @override
  String get settingsResetMessage => 'Mọi cài đặt sẽ trở về mặc định và các khóa API bị xóa. Không thể hoàn tác.';

  @override
  String get settingsResetConfirm => 'Đặt lại';

  @override
  String get settingsResetSuccess => 'Đã khôi phục cài đặt mặc định';

  @override
  String get settingsFactoryReset => 'Xóa sạch dữ liệu';

  @override
  String get settingsFactoryResetTitle => 'Xóa sạch dữ liệu';

  @override
  String get settingsFactoryResetMessage => 'Thao tác này xóa vĩnh viễn TẤT CẢ dữ liệu: lịch sử, nhãn, từ thay thế, mô hình AI đã tải, nhật ký và cài đặt. Ứng dụng trở về trạng thái ban đầu.';

  @override
  String get settingsFactoryResetConfirm => 'Xóa tất cả';

  @override
  String get settingsFactoryResetSuccess => 'Đã xóa và đặt lại toàn bộ ứng dụng';

  @override
  String get settingsFactoryResetProgressTitle => 'Đang đặt lại WhisPaste';

  @override
  String get settingsFactoryResetPhaseStoppingSubprocess => 'Đang dừng dịch vụ nhận diện…';

  @override
  String get settingsFactoryResetPhaseDeletingModels => 'Đang xóa các mô hình AI…';

  @override
  String get settingsFactoryResetPhaseDeletingDatabase => 'Đang xóa cơ sở dữ liệu…';

  @override
  String get settingsFactoryResetPhaseResettingSecureStore => 'Đang xóa thông tin đăng nhập…';

  @override
  String get settingsFactoryResetPhaseResettingSettings => 'Đang khôi phục cài đặt mặc định…';

  @override
  String get settingsFactoryResetFailedMessage => 'Không thể đặt lại hoàn toàn. Vui lòng khởi động lại ứng dụng.';

  @override
  String get settingsPortabilitySectionTitle => 'Sao lưu và chuyển máy';

  @override
  String get settingsPortabilitySectionSubtitle => 'Sao lưu thiết lập hoặc chuyển sang máy tính khác';

  @override
  String get settingsPortabilityExportAction => 'Xuất';

  @override
  String get settingsPortabilityImportAction => 'Nhập';

  @override
  String get settingsPortabilityExportLocationLabel => 'Nơi lưu bản xuất';

  @override
  String get settingsPortabilityImportLocationLabel => 'Nguồn nhập dữ liệu';

  @override
  String get settingsPortabilityExportLocationUnset => 'Sẽ hỏi vị trí khi xuất lần đầu';

  @override
  String get settingsPortabilityImportLocationUnset => 'Sẽ hỏi vị trí khi nhập lần đầu';

  @override
  String get settingsPortabilityChooseExportLocation => 'Chọn nơi xuất khác (chưa xuất dữ liệu)';

  @override
  String get settingsPortabilityChooseImportLocation => 'Chọn nguồn nhập khác (chưa nhập dữ liệu)';

  @override
  String get settingsPortabilityImportConfirmTitle => 'Nhập cài đặt?';

  @override
  String get settingsAutosaveLabel => 'Tự động sao lưu';

  @override
  String get settingsAutosaveHint => 'Tự lưu thiết lập vào thư mục đã chọn vài giây sau mỗi thay đổi';

  @override
  String get settingsAutosaveChooseFolder => 'Chọn thư mục sao lưu tự động khác (chưa sao lưu)';

  @override
  String get settingsAutosaveNeverRun => 'Chưa sao lưu';

  @override
  String get settingsAutosaveLastRunFailed => 'Sao lưu thất bại';

  @override
  String get settingsAutosaveErrorLocation => 'Sao lưu tự động thất bại: thư mục không còn khả dụng.';

  @override
  String get groqRemovedToast => 'Đã bỏ Groq STT. Đã chuyển về nhận diện trên máy.';

  @override
  String get tccResetAfterUpdateToast => 'macOS đã đặt lại quyền tự dán sau khi cập nhật.';

  @override
  String get settingsOff => 'Tắt';

  @override
  String get settingsOn => 'Bật';

  @override
  String get statusReady => 'Sẵn sàng';

  @override
  String get statusRecording => 'Đang ghi âm…';

  @override
  String get statusTranscribing => 'Đang nhận diện…';

  @override
  String get statusProcessing => 'Đang xử lý…';

  @override
  String get statusTranscriptionDone => 'Đã nhận diện xong';

  @override
  String get statusCopied => 'Đã sao chép!';

  @override
  String get statusLocal => 'Trên máy';

  @override
  String get statusCloud => 'Đám mây';

  @override
  String get statusOnline => 'Trực tuyến';

  @override
  String get statusOffline => 'Ngoại tuyến';

  @override
  String get recordingGuardFailed => 'Không thu được âm thanh. Hãy thử lại. Đôi khi micro cần ít thời gian để khởi động.';

  @override
  String get recordingAutoStopped => 'Đã dừng ghi âm vì phát hiện im lặng.';

  @override
  String get actionCopy => 'Sao chép';

  @override
  String get actionDuplicate => 'Nhân bản';

  @override
  String get actionDelete => 'Xóa';

  @override
  String get actionDismiss => 'Bỏ qua';

  @override
  String get actionEdit => 'Sửa';

  @override
  String get actionExport => 'Xuất';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionClearSearch => 'Xóa tìm kiếm';

  @override
  String get tooltipLanguage => 'Ngôn ngữ';

  @override
  String get onboardingWelcome => 'Nói một lần, nhập chữ ở bất cứ đâu.';

  @override
  String get feedbackTitle => 'Gửi góp ý';

  @override
  String get feedbackHint => 'Hãy cho chúng tôi biết ý kiến của bạn. Chúng tôi đọc mọi phản hồi.';

  @override
  String get analyticsPreviewBanner => 'Bản xem thử: đang hiển thị dữ liệu mẫu. Thống kê thực tế sẽ có sau khi bạn ghi âm.';

  @override
  String get analyticsEmptyTitle => 'Chưa có bản ghi';

  @override
  String get analyticsEmptySubtitle => 'Bắt đầu ghi âm để xem thống kê.';

  @override
  String get analyticsOverview => 'Tổng quan';

  @override
  String get analyticsOverviewSubtitle => 'Tóm tắt thống kê ghi âm';

  @override
  String get analyticsActivity => 'Hoạt động';

  @override
  String get analyticsInsights => 'Phân tích';

  @override
  String get analyticsTotalRecordings => 'Tổng số bản ghi';

  @override
  String get analyticsTotalDuration => 'Tổng thời lượng';

  @override
  String get analyticsWordsDictated => 'Số từ đã nhận diện';

  @override
  String get analyticsTimeSaved => 'Thời gian tiết kiệm';

  @override
  String get analyticsAvgLatency => 'Tốc độ trung bình';

  @override
  String get analyticsRecordingActivity => 'Hoạt động ghi âm';

  @override
  String get analyticsLast7Days => '7 ngày gần đây';

  @override
  String get analyticsModelUsage => 'Mức sử dụng mô hình';

  @override
  String get analyticsDurationDistribution => 'Phân bố thời lượng';

  @override
  String get analyticsCostSavings => 'Chi phí và tiết kiệm';

  @override
  String get analyticsLocalSavings => 'Tiết kiệm khi dùng trên máy';

  @override
  String get analyticsCloudCost => 'Chi phí đám mây';

  @override
  String get analyticsPeriod7d => '7 ngày';

  @override
  String get analyticsPeriod30d => '30 ngày';

  @override
  String get analyticsPeriod90d => '90 ngày';

  @override
  String get analyticsPeriodAll => 'Toàn thời gian';

  @override
  String get analyticsReset => 'Đặt lại';

  @override
  String get analyticsResetTitle => 'Đặt lại thống kê';

  @override
  String get analyticsResetMessage => 'Bạn có chắc muốn xóa toàn bộ dữ liệu thống kê? Không thể hoàn tác.';

  @override
  String get analyticsDayMon => 'T2';

  @override
  String get analyticsDayTue => 'T3';

  @override
  String get analyticsDayWed => 'T4';

  @override
  String get analyticsDayThu => 'T5';

  @override
  String get analyticsDayFri => 'T6';

  @override
  String get analyticsDaySat => 'T7';

  @override
  String get analyticsDaySun => 'CN';

  @override
  String get analyticsDurationLt15s => 'Dưới 15 giây';

  @override
  String get analyticsDuration15To30s => '15–30 giây';

  @override
  String get analyticsDuration30To60s => '30–60 giây';

  @override
  String get analyticsDuration1To3m => '1–3 phút';

  @override
  String get analyticsDurationGt3m => 'Trên 3 phút';

  @override
  String get replacementsSearch => 'Tìm quy tắc thay thế…';

  @override
  String get replacementsSearchFieldLabel => 'Tìm quy tắc thay thế';

  @override
  String get replacementsAdd => 'Thêm';

  @override
  String get replacementsEmpty => 'Chưa có quy tắc thay thế';

  @override
  String get replacementsEmptyHint => 'Thêm quy tắc để tự thay các từ khi nhận diện. Ví dụ: "btw" → "nhân tiện".';

  @override
  String get replacementsNoMatches => 'Không tìm thấy';

  @override
  String get replacementsNoMatchesHint => 'Thử từ khóa khác.';

  @override
  String get replacementsToggleLabel => 'Bật thay thế văn bản';

  @override
  String get replacementsToggleEnabled => 'Đang bật thay thế';

  @override
  String get replacementsToggleDisabled => 'Đã tắt thay thế';

  @override
  String get replacementsEnableBannerTitle => 'Chức năng thay thế đang tắt';

  @override
  String get replacementsEnableBannerHint => 'Bật để ứng dụng tự thay thế cụm từ kích hoạt trong văn bản.';

  @override
  String get replacementsEnableAction => 'Bật';

  @override
  String get replacementsDisableAction => 'Tắt';

  @override
  String get replacementsEditShortcut => 'Sửa quy tắc thay thế';

  @override
  String get replacementsNewShortcut => 'Tạo quy tắc thay thế';

  @override
  String get replacementsDialogHint => 'Bất kỳ cụm từ kích hoạt nào cũng được tự động thay thế trong văn bản đã nhận diện.';

  @override
  String get replacementsTriggerLabel => 'Cụm từ kích hoạt';

  @override
  String get replacementsTriggerHint => 'Ví dụ: kết luận trung ương';

  @override
  String get replacementsAddTrigger => 'Thêm cụm từ kích hoạt';

  @override
  String get replacementsRemoveTrigger => 'Xóa cụm từ kích hoạt';

  @override
  String get replacementsReplacementLabel => 'Văn bản thay thế';

  @override
  String get replacementsReplacementHint => 'Ví dụ: KL/TW';

  @override
  String get replacementsDeleteTitle => 'Xóa quy tắc thay thế';

  @override
  String get replacementsImportFromFolder => 'Nhập từ thư mục';

  @override
  String get replacementsImportHint => 'Quét thư mục dự án để tìm tên định danh và thêm quy tắc khớp gần đúng; dữ liệu không rời khỏi máy.';

  @override
  String get replacementsImportScanning => 'Đang quét thư mục — dự án lớn có thể mất vài phút…';

  @override
  String get replacementsImportError => 'Nhập thất bại — không thể quét thư mục.';

  @override
  String get replacementsImportedBadge => 'Đã nhập';

  @override
  String get replacementsLearnedBadge => 'Đã học';

  @override
  String get correctionLearningToggleLabel => 'Học từ những lần sửa';

  @override
  String get correctionLearningToggleEnabled => 'Đang theo dõi các cách sửa lặp lại để đề xuất';

  @override
  String get correctionLearningToggleDisabled => 'Đã tắt theo dõi sửa để đề xuất';

  @override
  String get correctionLearningHowTo => 'Trong Lịch sử, khi ghi âm chú thích hãy nói “sửa: …” rồi đọc văn bản đúng. Nếu sửa cùng nội dung hai lần, WhisPaste sẽ đề xuất tạo quy tắc thay thế tự động.';

  @override
  String get correctionCandidatesCardTitle => 'Đề xuất từ các lần sửa';

  @override
  String get correctionCandidatesReviewButton => 'Xem lại';

  @override
  String get correctionCandidatesReviewTitle => 'Xem lại cách sửa đã học';

  @override
  String get replacementsImportNothingFound => 'Không tìm thấy định danh mới trong thư mục.';

  @override
  String get replacementsImportReviewTitle => 'Chọn dữ liệu cần nhập';

  @override
  String get replacementsImportReviewSearchHint => 'Lọc mục đề xuất';

  @override
  String get replacementsImportReviewSelectAllFiltered => 'Chọn tất cả mục đang hiển thị';

  @override
  String get replacementsImportReviewDeselectAll => 'Bỏ chọn tất cả';

  @override
  String get replacementsImportReviewNoMatches => 'Không có mục nào khớp bộ lọc.';

  @override
  String get replacementsMatchModeLabel => 'Cách khớp';

  @override
  String get replacementsMatchModeExact => 'Chính xác';

  @override
  String get replacementsMatchModeFuzzy => 'Gần đúng';

  @override
  String get replacementsFuzzyToleranceLabel => 'Mức sai lệch';

  @override
  String get replacementsFuzzyToleranceStrict => 'Nghiêm ngặt';

  @override
  String get replacementsFuzzyToleranceStandard => 'Tiêu chuẩn';

  @override
  String get replacementsFuzzyToleranceTolerant => 'Linh hoạt';

  @override
  String get replacementsFuzzyToleranceHint => 'Mức độ lời nói được phép khác với cụm từ kích hoạt. Nghiêm ngặt giảm thay nhầm nhưng dễ bỏ sót từ nghe không rõ; linh hoạt dễ khớp hơn nhưng có thể thay nhầm.';

  @override
  String get snippetsSearch => 'Tìm mẫu văn bản…';

  @override
  String get snippetsSearchFieldLabel => 'Tìm mẫu văn bản';

  @override
  String get snippetsAdd => 'Thêm';

  @override
  String get snippetsEmpty => 'Chưa có mẫu văn bản';

  @override
  String get snippetsEmptyHint => 'Thêm mẫu để sử dụng nhanh một đoạn chữ, chẳng hạn chữ ký hoặc nội dung trả lời.';

  @override
  String get snippetsNoMatches => 'Không tìm thấy';

  @override
  String get snippetsNoMatchesHint => 'Thử từ khóa khác.';

  @override
  String get snippetsEditSnippet => 'Sửa mẫu văn bản';

  @override
  String get snippetsNewSnippet => 'Tạo mẫu văn bản';

  @override
  String get snippetsDialogHint => 'Mở bộ chọn mẫu khi ghi âm để chèn đoạn này.';

  @override
  String get snippetsTitleLabel => 'Tiêu đề';

  @override
  String get snippetsTitleHint => 'Ví dụ: Chữ ký email';

  @override
  String get snippetsBodyLabel => 'Nội dung';

  @override
  String get snippetsBodyHint => 'Nội dung được chèn khi chọn mẫu…';

  @override
  String get snippetsKindLabel => 'Loại';

  @override
  String get snippetsKindStatic => 'Cố định';

  @override
  String get snippetsKindInteractive => 'Tương tác';

  @override
  String get snippetsFieldsLabel => 'Trường thông tin';

  @override
  String get snippetsFieldsHint => 'Bạn sẽ lần lượt ghi âm ngắn để điền từng trường theo thứ tự này.';

  @override
  String get snippetsFieldMoveUp => 'Đưa trường lên';

  @override
  String get snippetsFieldMoveDown => 'Đưa trường xuống';

  @override
  String get snippetsFieldRemove => 'Xóa trường';

  @override
  String get snippetsFieldAdd => 'Thêm trường';

  @override
  String get snippetsFieldInsertIntoTemplate => 'Chèn vào mẫu';

  @override
  String get snippetsTemplateLabel => 'Mẫu';

  @override
  String get snippetsTemplateHint => 'Viết mẫu rồi dùng nút chèn từng trường vào vị trí cần thiết.';

  @override
  String get snippetsTemplateFieldHint => 'Nhập nội dung ở đây và chèn các trường bằng nút phía trên.';

  @override
  String get snippetsTemplateMissingFieldsWarning => 'Một số trường chưa có trong mẫu nên nội dung ghi âm tương ứng sẽ không được dùng.';

  @override
  String get snippetsInteractiveBadge => 'Tương tác';

  @override
  String get interactiveSnippetAnnounceHint => 'Chuẩn bị nói…';

  @override
  String get interactiveSnippetAdvance => 'Tiếp theo';

  @override
  String get snippetsDeleteTitle => 'Xóa mẫu';

  @override
  String get snippetsPickerTriggerLabel => 'Từ khóa mở bộ chọn mẫu';

  @override
  String get snippetsPickerTriggerSubtitle => 'Chỉ cần nói riêng từ này để mở bộ chọn mẫu. Để trống để tắt.';

  @override
  String get snippetsPickerTriggerHint => 'Ví dụ: mẫu';

  @override
  String get snippetsPickerTriggerEmptyListHint => 'Đã có từ khóa nhưng chưa có mẫu — khi đọc từ khóa, ứng dụng vẫn nhập như chữ bình thường cho đến khi bạn thêm mẫu đầu tiên.';

  @override
  String get snippetsPickerHotkeyLabel => 'Phím tắt chọn mẫu';

  @override
  String get snippetsPickerHotkeySubtitle => 'Mở ngay bộ chọn mẫu bằng phím tắt.';

  @override
  String get snippetsPickerHotkeyOff => 'Phím tắt chọn mẫu đang tắt.';

  @override
  String get snippetsPickerHotkeyEnable => 'Bật phím tắt';

  @override
  String get snippetsPickerUnavailable => 'Bộ chọn mẫu chưa hỗ trợ trên hệ thống này.';

  @override
  String get snippetsPickerSemanticsLabel => 'Bộ chọn mẫu văn bản';

  @override
  String get snippetsPickerInsertAction => 'Chèn';

  @override
  String get aboutTagline => 'Chuyển lời nói thành văn bản tức thì.';

  @override
  String get aboutWhatsNew => 'Có gì mới';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutReportIssue => 'Báo lỗi';

  @override
  String get aboutSupportTitle => 'Ủng hộ dự án';

  @override
  String get aboutSupportDescription => 'WhisPaste miễn phí và có mã nguồn mở theo giấy phép MIT. Khoản tài trợ giúp chi trả chi phí vận hành, phát triển và phát hành ứng dụng.';

  @override
  String get aboutGitHubSponsors => 'Nhà tài trợ GitHub';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutStarOnGitHub => 'Đánh dấu sao trên GitHub';

  @override
  String get aboutSponsorsTitle => 'Nhà tài trợ';

  @override
  String get supportPromptRecurringTitle => 'Ủng hộ hằng tháng?';

  @override
  String get supportPromptRecurringDescription => 'Cảm ơn bạn từng ủng hộ WhisPaste. Nếu muốn, bạn có thể tài trợ một khoản nhỏ hằng tháng để duy trì hoạt động của dự án.';

  @override
  String get aboutBuiltWith => 'Công nghệ sử dụng';

  @override
  String get aboutFlutterGo => 'Flutter';

  @override
  String get aboutFlutterGoDesc => 'Giao diện đa nền tảng Flutter; nhận diện trên máy qua whisper.cpp và Parakeet.';

  @override
  String get aboutWhisper => 'whisper.cpp và OpenAI Whisper';

  @override
  String get aboutWhisperDesc => 'Nhận diện giọng nói trên máy hoặc đám mây, nhanh và chính xác, hỗ trợ nhiều ngôn ngữ.';

  @override
  String get aboutParakeet => 'NVIDIA Parakeet và sherpa-onnx';

  @override
  String get aboutParakeetDesc => 'Nhận diện trên máy tối ưu tốc độ cho CPU thông thường, hỗ trợ khoảng 25 ngôn ngữ.';

  @override
  String get aboutPrivacyFirst => 'Ưu tiên quyền riêng tư';

  @override
  String get aboutPrivacyFirstDesc => 'Mặc định xử lý trên máy, giọng nói không rời khỏi thiết bị trừ khi bạn chủ động chọn dịch vụ đám mây.';

  @override
  String get aboutPrivacy => 'Quyền riêng tư và dữ liệu';

  @override
  String get aboutPrivacyLocal => 'Mọi bản nhận diện và lịch sử được lưu trên máy, không chuyển lên máy chủ bên ngoài.';

  @override
  String get aboutPrivacyCloud => 'Các dịch vụ OpenAI và Deepgram chỉ nhận âm thanh khi bạn chủ động dùng chúng; áp dụng chính sách quyền riêng tư của nhà cung cấp.';

  @override
  String get aboutPrivacyNoTracking => 'Thống kê sử dụng ẩn danh và tuân thủ GDPR; có thể tắt trong Cài đặt → Quyền riêng tư. Không cần tài khoản người dùng. Việc kiểm tra cập nhật có kết nối tới GitHub.';

  @override
  String get aboutKeyboardShortcuts => 'Phím tắt';

  @override
  String get aboutShortcutRecord => 'Bắt đầu / Dừng ghi âm';

  @override
  String get aboutLinks => 'Liên kết';

  @override
  String get aboutWebsite => 'Trang web';

  @override
  String get aboutGitHubRepo => 'Kho mã nguồn GitHub';

  @override
  String get aboutFollowOnX => 'Theo dõi trên X';

  @override
  String get aboutMitLicense => 'Giấy phép MIT';

  @override
  String get aboutViewOnGitHub => 'Xem trên GitHub';

  @override
  String get aboutPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get aboutSystemInfo => 'Thông tin hệ thống';

  @override
  String get aboutSystemInfoDesc => 'Sao chép thông tin chẩn đoán ngắn gọn khi báo lỗi.';

  @override
  String get aboutCopyDebugInfo => 'Sao chép thông tin chẩn đoán';

  @override
  String get aboutCopied => 'Đã sao chép!';

  @override
  String get aboutMadeWith => 'Được xây dựng bằng ♥ bởi WhisPaste';

  @override
  String get aboutOpenSource => 'Mã nguồn mở theo giấy phép MIT';

  @override
  String get feedbackSubtitle => 'Giúp chúng tôi cải thiện WhisPaste. Mọi ý kiến đều quan trọng.';

  @override
  String get feedbackCategoryLabel => 'Chủ đề góp ý';

  @override
  String get feedbackCategoryBug => 'Báo lỗi';

  @override
  String get feedbackCategoryFeature => 'Đề xuất tính năng';

  @override
  String get feedbackCategoryGeneral => 'Chung';

  @override
  String get feedbackCategoryAiQuality => 'Chất lượng AI';

  @override
  String get feedbackRatingLabel => 'Bạn đánh giá WhisPaste thế nào?';

  @override
  String get feedbackCommentsLabel => 'Nói rõ hơn';

  @override
  String get feedbackPlaceholderBug => 'Mô tả điều đã xảy ra và kết quả mong đợi…';

  @override
  String get feedbackPlaceholderFeature => 'Bạn muốn WhisPaste có thêm tính năng gì?';

  @override
  String get feedbackPlaceholderAi => 'Chất lượng nhận diện giọng nói thế nào?';

  @override
  String get feedbackPlaceholderGeneral => 'Chia sẻ suy nghĩ của bạn…';

  @override
  String get feedbackContactEmailLabel => 'Email (không bắt buộc)';

  @override
  String get feedbackContactEmailExplanation => 'Chỉ dùng để trả lời khi bạn muốn. Chúng tôi không dùng để quảng cáo và sẽ xóa sau 90 ngày.';

  @override
  String get feedbackContactEmailPlaceholder => 'you@example.com';

  @override
  String get feedbackContactEmailInvalid => 'Nhập địa chỉ email hợp lệ hoặc để trống.';

  @override
  String get feedbackContactLanguageLabel => 'Ngôn ngữ trả lời';

  @override
  String get feedbackContactLanguageHint => 'Bạn muốn nhận phản hồi bằng ngôn ngữ nào?';

  @override
  String get feedbackSubmit => 'Gửi góp ý';

  @override
  String get feedbackPrivacyNote => 'Mặc định ẩn danh; chỉ có thể nhận dạng nếu bạn nhập email.';

  @override
  String get feedbackThankYou => 'Cảm ơn bạn!';

  @override
  String get feedbackThankYouMessage => 'Phản hồi của bạn giúp cải thiện WhisPaste cho mọi người.';

  @override
  String get feedbackSendAnother => 'Gửi thêm góp ý';

  @override
  String get feedbackRatingFrustrated => 'Rất khó chịu';

  @override
  String get feedbackRatingMeh => 'Không hài lòng';

  @override
  String get feedbackRatingOkay => 'Bình thường';

  @override
  String get feedbackRatingHappy => 'Hài lòng';

  @override
  String get feedbackRatingLoveIt => 'Rất thích!';

  @override
  String get feedbackSubmitting => 'Đang gửi…';

  @override
  String get feedbackErrorRateLimited => 'Bạn vừa gửi phản hồi gần đây. Hãy thử lại sau.';

  @override
  String get feedbackErrorNetwork => 'Không thể kết nối tới máy chủ. Hãy kiểm tra Internet.';

  @override
  String get feedbackErrorServer => 'Có lỗi xảy ra. Hãy thử lại sau.';

  @override
  String get feedbackErrorNotConfigured => 'Bản này chưa hỗ trợ gửi góp ý.';

  @override
  String get statusBarOnDevice => 'Trên máy';

  @override
  String get statusBarOverlayFloating => 'Lớp phủ: Nổi';

  @override
  String get statusBarOverlayOff => 'Lớp phủ: Tắt';

  @override
  String get statusBarAfterCopy => 'Sau nhận diện: Sao chép';

  @override
  String get statusBarAfterPaste => 'Sau nhận diện: Dán';

  @override
  String get statusBarAfterBoth => 'Sau nhận diện: Sao chép và dán';

  @override
  String get statusBarAfterNothing => 'Sau nhận diện: Thủ công';

  @override
  String get sttStatusStandby => 'Chờ';

  @override
  String get sttStatusStarting => 'Đang khởi động…';

  @override
  String get sttStatusReady => 'Sẵn sàng';

  @override
  String get sttStatusError => 'Lỗi';

  @override
  String get statusBarSttTooltip => 'Dịch vụ nhận diện và trạng thái hiện tại';

  @override
  String get statusBarBackendGpuUtilizationUnavailable => 'Không thể đo mức sử dụng GPU thực tế trên mọi hệ điều hành khi thiếu quyền nâng cao; phần trăm hiện tại là mức sử dụng CPU của tiến trình này.';

  @override
  String get statusBarRecording => 'Đang ghi âm…';

  @override
  String get statusBarTranscribing => 'Đang nhận diện…';

  @override
  String get statusBarRefining => 'Đang chỉnh sửa…';

  @override
  String get statusBarDone => 'Hoàn tất';

  @override
  String get statusBarHotkeyTooltip => 'Phím tắt toàn hệ thống: nhấn để thiết lập';

  @override
  String get statusBarAutoPasteOffHint => 'Đang tắt tự dán, hãy bật trong Cài đặt';

  @override
  String get statusBarAutoPasteOffHintTooltip => 'Tính năng tự dán hiện đang tắt. Nhấn để mở Cài đặt.';

  @override
  String get statusBarAutoPasteOffHintDismiss => 'Bỏ qua';

  @override
  String get statusBarAutomationApiChipLabelError => 'API: lỗi';

  @override
  String get statusBarAutomationApiTooltipError => 'API tự động hóa: không còn cổng trống';

  @override
  String get modifierCtrl => 'Ctrl';

  @override
  String get modifierShift => 'Shift';

  @override
  String get modifierAlt => 'Alt';

  @override
  String get modifierWin => 'Win';

  @override
  String get modifierCmd => 'Cmd';

  @override
  String get modifierOption => 'Option';

  @override
  String get modifierAltGr => 'AltGr';

  @override
  String get shortcutKeySpace => 'Phím cách';

  @override
  String get shortcutKeyEnter => 'Enter';

  @override
  String get shortcutKeyEscape => 'Esc';

  @override
  String get shortcutKeyBackspace => 'Backspace';

  @override
  String get shortcutKeyTab => 'Tab';

  @override
  String get shortcutKeyDelete => 'Delete';

  @override
  String get shortcutKeyInsert => 'Insert';

  @override
  String get shortcutKeyHome => 'Home';

  @override
  String get shortcutKeyEnd => 'End';

  @override
  String get shortcutKeyPageUp => 'Page Up';

  @override
  String get shortcutKeyPageDown => 'Page Down';

  @override
  String get modelServerReady => 'Dịch vụ nhận diện đã sẵn sàng';

  @override
  String get modelServerMissing => 'Chưa cài dịch vụ nhận diện';

  @override
  String get modelServerWhisper => 'Dịch vụ nhận diện trên máy';

  @override
  String get modelReady => 'Sẵn sàng';

  @override
  String get modelDownloadComplete => 'Đã tải xong mô hình AI';

  @override
  String get modelUse => 'Sử dụng';

  @override
  String get modelDownload => 'Tải xuống';

  @override
  String get modelDownloading => 'Đang tải…';

  @override
  String get modelDownloadingEngine => 'Đang chuẩn bị dịch vụ nhận diện…';

  @override
  String get modelVerifying => 'Đang xác minh…';

  @override
  String get modelExtracting => 'Đang giải nén…';

  @override
  String get modelDeleteConfirm => 'Xóa mô hình này?';

  @override
  String get modelDeleteConfirmMessage => 'File mô hình sẽ bị xóa vĩnh viễn. Bạn có thể tải lại bất cứ lúc nào.';

  @override
  String get qualityTierCompactLabel => 'Nhanh và gọn';

  @override
  String get qualityTierCompactDesc => 'Kết quả nhanh, dung lượng tải nhỏ. Thích hợp ghi chú và tin nhắn ngắn.';

  @override
  String get qualityTierBalancedLabel => 'Cân bằng';

  @override
  String get qualityTierBalancedDesc => 'Chính xác và ổn định cho ghi âm hằng ngày. Hoạt động trên hầu hết thiết bị.';

  @override
  String get qualityTierPremiumLabel => 'Chất lượng cao nhất';

  @override
  String get qualityTierPremiumDesc => 'Độ chính xác cao cho bản ghi dài và nội dung phức tạp. Cần GPU đủ mạnh.';

  @override
  String get qualityTierRecommended => 'Đề xuất cho máy của bạn';

  @override
  String get qualityTierDownloadAndContinue => 'Tải mô hình';

  @override
  String get qualityTierChooseDifferent => 'Chọn mức chất lượng khác';

  @override
  String get qualityTierActive => 'Đang dùng';

  @override
  String get qualityTierInfoModerate => 'Cân bằng tốt giữa tốc độ và chất lượng';

  @override
  String get qualityTierBenchmarkReRun => 'Đo hiệu năng lại';

  @override
  String get qualityTierBenchmarkRun => 'Đo hiệu năng';

  @override
  String get qualityTierInfoBenchmarking => 'Đang kiểm tra hiệu năng…';

  @override
  String get qualityTierActionOverride => 'Vẫn sử dụng';

  @override
  String get qualityTierActionOverrideHint => 'Dùng mức chất lượng này dù đã có cảnh báo';

  @override
  String get settingsQualityBasic => 'Cơ bản';

  @override
  String get settingsQualityBalanced => 'Cân bằng';

  @override
  String get settingsQualityHigh => 'Chất lượng cao';

  @override
  String get settingsQualityBest => 'Chất lượng tốt nhất';

  @override
  String get settingsQualityMaximum => 'Độ chính xác tối đa';

  @override
  String get settingsQualityRecommended => '★ Đề xuất';

  @override
  String get settingsModelStatusReady => 'Mô hình nhận diện đã sẵn sàng';

  @override
  String get settingsModelStatusNeeded => 'Mô hình sẽ được tải khi bắt đầu ghi âm';

  @override
  String get settingsModelStatusDownloading => 'Đang tải mô hình nhận diện…';

  @override
  String get settingsAdvancedModelManagement => 'Quản lý mô hình nâng cao';

  @override
  String get infoEngineDownloading => 'Đang chuẩn bị dịch vụ nhận diện, vui lòng chờ.';

  @override
  String get infoModelMissing => 'Hãy tải mô hình nhận diện trong Cài đặt trước.';

  @override
  String get infoPipelineBusy => 'WhisPaste vẫn đang xử lý bản ghi trước.';

  @override
  String get infoSnippetPickerEmpty => 'Đã nhận diện từ khóa mở mẫu nhưng chưa có mẫu nào; ứng dụng đã nhập từ này như văn bản bình thường.';

  @override
  String get infoSnippetPickerEmptyAction => 'Mở Mẫu văn bản';

  @override
  String get oomRecoveryTitle => 'Ghi âm thất bại vì thiếu bộ nhớ GPU';

  @override
  String get oomRecoveryMessage => 'GPU đã hết bộ nhớ. Chọn cách tiếp tục:';

  @override
  String get oomRecoveryTrySmaller => 'Thử mô hình nhỏ hơn';

  @override
  String get oomRecoverySwitchCloud => 'Dùng đám mây';

  @override
  String get oomRecoverySwitchCloudHint => 'Chuyển sang nhận diện qua đám mây';

  @override
  String get oomRecoveryCancel => 'Hủy';

  @override
  String get oomRecoveryPermanentTitle => 'Không thể nhận diện trên máy';

  @override
  String get oomRecoveryPermanentMessage => 'Các mô hình trên máy đều thất bại vì giới hạn bộ nhớ GPU. Hãy chuyển sang dịch vụ đám mây trong Cài đặt.';

  @override
  String get oomRecoveryPermanentCloud => 'Mở Cài đặt';

  @override
  String get oomRecoverySwitchingCloud => 'Đang chuyển sang nhận diện qua đám mây…';

  @override
  String get infoSttCudaOomFallbackModel => 'Đã giảm chất lượng vì GPU hết bộ nhớ. Đang dùng mô hình nhẹ hơn.';

  @override
  String get infoSttCudaOomFallbackCpu => 'GPU hết bộ nhớ. Đã chuyển sang CPU để hoạt động ổn định hơn.';

  @override
  String get errorSttServerConnectionLost => 'Dịch vụ nhận diện dừng đột ngột. Hãy thử lại.';

  @override
  String get errorSttCudaOom => 'GPU đã hết bộ nhớ. Đã giảm chất lượng để lần thử sau có thể hoạt động.';

  @override
  String get errorCloudAuth => 'Thiếu hoặc sai khóa API đám mây. Kiểm tra ở Cài đặt → Nhận diện giọng nói.';

  @override
  String get errorCloudQuota => 'Đã đạt giới hạn yêu cầu của dịch vụ đám mây. Vui lòng chờ rồi thử lại.';

  @override
  String get errorOnboardingNotCompleted => 'Hãy hoàn thành hướng dẫn thiết lập trước.';

  @override
  String get errorSttModelNotFound => 'Không tìm thấy mô hình nhận diện. Hãy tải mô hình trong Cài đặt.';

  @override
  String get errorSttModelUnknown => 'Không nhận diện được mô hình. Hãy chọn mô hình hợp lệ trong Cài đặt.';

  @override
  String get errorRecordingFailed => 'Không thể bắt đầu ghi âm. Hãy thử lại.';

  @override
  String get errorNoAudioRecorded => 'Không thu được âm thanh. Hãy thử lại.';

  @override
  String get errorTranscriptionEmpty => 'Không nhận diện được chữ. Hãy thử lại.';

  @override
  String get errorSttServerFailed => 'Không thể khởi động dịch vụ nhận diện';

  @override
  String get errorSttModelIncompatibleRuntime => 'Mô hình không tương thích với bộ xử lý hiện tại. Hãy tải lại trong Cài đặt.';

  @override
  String get errorSttModelCorruptedRedownloading => 'Mô hình có thể bị hỏng. Đang tự động tải lại.';

  @override
  String get errorSttDllMissing => 'Thiếu thành phần hệ thống cần thiết. Đang thử bằng CPU.';

  @override
  String get errorSttGpuFatal => 'Tăng tốc GPU thất bại. Đang thử bằng CPU.';

  @override
  String get errorSttHeapCorruption => 'Lỗi bộ nhớ. Đang thử bằng CPU.';

  @override
  String get errorSttCpuFallbackFailed => 'Dịch vụ nhận diện thất bại cả trên GPU và CPU. Hãy khởi động lại hoặc tải lại mô hình.';

  @override
  String get errorPipelineTimeout => 'Ghi âm quá lâu. Hãy thử bản ghi ngắn hơn.';

  @override
  String get errorWavFileNotCreated => 'Không thể lưu file âm thanh. Hãy thử lại.';

  @override
  String get errorWavFileEmpty => 'Không thu được tiếng. Hãy kiểm tra micro.';

  @override
  String get errorSttStartTimeout => 'Dịch vụ nhận diện vẫn đang khởi động. Hãy thử lại sau giây lát.';

  @override
  String get errorTranscriptionTimeout => 'Nhận diện quá thời gian. Hãy ghi âm ngắn hơn.';

  @override
  String get errorMicPermissionDenied => 'Cần quyền truy cập micro. Hãy cấp quyền trong Cài đặt hệ thống.';

  @override
  String get errorRecordingStartFailed => 'Không thể bắt đầu ghi âm. Hãy thử lại.';

  @override
  String get errorGeneric => 'Có lỗi xảy ra. Hãy thử lại.';

  @override
  String get modelDownloadFailed => 'Tải thất bại. Kiểm tra kết nối Internet.';

  @override
  String get statusSttLoading => 'Đang tải mô hình…';

  @override
  String get statusSttReady => 'Mô hình đã sẵn sàng';

  @override
  String get historyDuplicate => 'Nhân bản';

  @override
  String get historyDuplicated => 'Đã nhân bản mục';

  @override
  String get historyViewRaw => 'Bản gốc';

  @override
  String get historyViewEdited => 'Đã chỉnh sửa';

  @override
  String get historyApplySmartModePreset => 'Áp dụng chế độ thông minh';

  @override
  String get historySmartModeApplied => 'Đã áp dụng chế độ thông minh';

  @override
  String get historySmartModeFailedModelMissing => 'Chưa tải mô hình chế độ thông minh';

  @override
  String get historySmartModeFailedTimeout => 'Xử lý chế độ thông minh quá thời gian';

  @override
  String get historySmartModeFailedGeneric => 'Xử lý chế độ thông minh thất bại — hãy thử lại';

  @override
  String get historySmartModeSelectTargetLanguage => 'Chọn ngôn ngữ đích';

  @override
  String get historyAddNote => 'Thêm chú thích';

  @override
  String get historyEditNote => 'Sửa chú thích';

  @override
  String get historyNotes => 'Chú thích';

  @override
  String get historyNotePlaceholder => 'Viết chú thích…';

  @override
  String get historyVoiceNoteHint => 'Mẹo: nói “nhãn: tên” hoặc “sửa: nội dung” khi ghi âm.';

  @override
  String get historyNoteAdded => 'Đã thêm chú thích';

  @override
  String get historyNoteDeleted => 'Đã xóa chú thích';

  @override
  String get historyCopiedAsMarkdown => 'Đã sao chép dạng Markdown';

  @override
  String get historyAddTag => 'Thêm nhãn…';

  @override
  String get historySearchTags => 'Tìm hoặc tạo nhãn…';

  @override
  String get historyNoteEdited => 'đã chỉnh sửa';

  @override
  String get historyTagAdded => 'Đã thêm nhãn';

  @override
  String get historyTagRemoved => 'Đã xóa nhãn';

  @override
  String get historyManageTags => 'Quản lý nhãn';

  @override
  String get tagManageTitle => 'Quản lý nhãn';

  @override
  String get tagManageEmpty => 'Chưa tạo nhãn nào.';

  @override
  String get tagDeleteConfirmTitle => 'Xóa nhãn?';

  @override
  String get tagDeleteUnusedTitle => 'Xóa các nhãn chưa dùng?';

  @override
  String get historyEditTranscript => 'Sửa bản nhận diện';

  @override
  String get historyTranscriptSaved => 'Đã lưu bản nhận diện';

  @override
  String get historySaveTranscript => 'Lưu';

  @override
  String get historyShortcutHelp => 'Phím tắt';

  @override
  String get historyShortcutGeneral => 'CHUNG';

  @override
  String get historyShortcutTags => 'Chuyển tới ô nhập nhãn';

  @override
  String get historyShortcutNotes => 'Thêm chú thích';

  @override
  String get historyShortcutPin => 'Đánh dấu / bỏ yêu thích';

  @override
  String get historyShortcutClose => 'Lưu và đóng';

  @override
  String get historyShortcutEditing => 'CHỈNH SỬA';

  @override
  String get historyShortcutToggleEdit => 'Bật/tắt chế độ sửa';

  @override
  String get historyShortcutSave => 'Lưu bản nhận diện';

  @override
  String get historyShortcutBold => 'In đậm';

  @override
  String get historyShortcutItalic => 'In nghiêng';

  @override
  String get historyShortcutCopy => 'Sao chép vào bộ nhớ tạm';

  @override
  String get historyShortcutEditTitle => 'Sửa tiêu đề';

  @override
  String get historyEditTitle => 'Sửa tiêu đề';

  @override
  String get historyTitlePlaceholder => 'Nhập tiêu đề…';

  @override
  String get historyTitleSaved => 'Đã lưu tiêu đề';

  @override
  String get historySearchHelpTitle => 'Mẹo tìm kiếm';

  @override
  String get historySearchHelpTags => 'Gõ # để lọc theo nhãn';

  @override
  String get historySearchHelpLang => 'Gõ lang: để lọc theo ngôn ngữ';

  @override
  String get historySearchHelpFreeText => 'Hoặc gõ từ khóa bất kỳ';

  @override
  String get historySearchQuickTags => 'Nhãn thường dùng';

  @override
  String get historyRecentSearches => 'Tìm kiếm gần đây';

  @override
  String get historyRemoveRecentSearch => 'Xóa tìm kiếm gần đây';

  @override
  String get historyRemoveFilter => 'Bỏ bộ lọc';

  @override
  String get historyQuickActions => 'Bộ lọc nhanh';

  @override
  String get historyQuickActionAllLangs => 'Tất cả ngôn ngữ';

  @override
  String get historyQuickActionFavorites => 'Chỉ mục yêu thích';

  @override
  String get historySortNewest => 'Mới nhất trước';

  @override
  String get historySortOldest => 'Cũ nhất trước';

  @override
  String get historySortLongest => 'Dài nhất trước';

  @override
  String get historySearchSuggestTag => 'Lọc theo nhãn';

  @override
  String get historySearchSuggestLang => 'Lọc theo ngôn ngữ';

  @override
  String get settingsKeyboardShortcut => 'Phím tắt';

  @override
  String get settingsKeyboardShortcutSubtitle => 'Phím tắt toàn hệ thống để bắt đầu và dừng ghi âm';

  @override
  String get settingsHotkeyEnabled => 'Bật phím tắt toàn hệ thống';

  @override
  String get settingsCurrentHotkey => 'Phím tắt hiện tại';

  @override
  String get settingsChangeHotkey => 'Thay đổi';

  @override
  String get settingsHotkeyRecorderTitle => 'Đặt phím tắt mới';

  @override
  String get settingsHotkeyRecorderHint => 'Nhấn tổ hợp phím bạn muốn sử dụng…';

  @override
  String get settingsHotkeyRecorderModifierHint => 'Có thể dùng các tổ hợp như Alt+Space, Ctrl+Alt+V hoặc Ctrl+Alt+Shift+R';

  @override
  String get settingsHotkeyRecorderCancel => 'Hủy';

  @override
  String get settingsHotkeyRecorderSave => 'Lưu';

  @override
  String get settingsHotkeyRecorderClear => 'Xóa';

  @override
  String get settingsHotkeyRecorderInvalidKey => 'Không thể dùng phím này. Hãy thử chữ cái, chữ số, phím F1–F12 hoặc phím mũi tên.';

  @override
  String get settingsHotkeyActionRecording => 'Bắt đầu/dừng ghi âm';

  @override
  String get settingsHotkeyActionQuickNote => 'Ghi chú nhanh';

  @override
  String get settingsQuickNoteHotkeyEnabled => 'Phím tắt ghi chú nhanh';

  @override
  String get settingsQuickNoteHotkeyHint => 'Văn bản vừa đọc được thêm vào ghi chú đã đánh dấu là ghi chú nhanh ở mục Ghi chú.';

  @override
  String get settingsQuickNoteCurrentHotkey => 'Tổ hợp phím';

  @override
  String get settingsQuickNoteHotkeyInactive => 'Không thể đăng ký tổ hợp phím này. Phím tắt ghi chú nhanh hiện chưa hoạt động. Hãy chọn tổ hợp khác.';

  @override
  String get settingsHotkeyActionSnippetPicker => 'Chọn mẫu văn bản';

  @override
  String get settingsSnippetPickerHotkeyEnabled => 'Phím tắt chọn mẫu';

  @override
  String get settingsSnippetPickerHotkeyHint => 'Mở ngay bộ chọn mẫu văn bản, không cần ghi âm hoặc nói từ khóa kích hoạt.';

  @override
  String get settingsSnippetPickerCurrentHotkey => 'Tổ hợp phím';

  @override
  String get settingsSnippetPickerHotkeyInactive => 'Không thể đăng ký tổ hợp này. Phím tắt chọn mẫu hiện chưa hoạt động. Hãy chọn tổ hợp khác.';

  @override
  String get settingsMaxRecordDuration => 'Thời gian ghi âm tối đa';

  @override
  String get settingsMaxRecordDurationSubtitle => 'Tự dừng an toàn khi đạt thời gian này';

  @override
  String get settingsMaxRecordDurationUnlimited => 'Không giới hạn';

  @override
  String get settingsCloseToTray => 'Thu nhỏ xuống khay hệ thống';

  @override
  String get settingsCloseToTraySubtitle => 'Tiếp tục chạy trong khay hệ thống khi đóng cửa sổ';

  @override
  String get settingsSidePanelEnabled => 'Thanh dán nhanh bộ nhớ tạm';

  @override
  String get settingsSidePanelEnabledSubtitle => 'Thanh trượt xuất hiện khi đưa chuột tới mép màn hình để xem bản nhận diện, mẫu văn bản và lịch sử sao chép';

  @override
  String get settingsSidePanelEdge => 'Vị trí thanh bên';

  @override
  String get settingsSidePanelEdgeSubtitle => 'Chọn cạnh màn hình nơi thanh bên xuất hiện';

  @override
  String get settingsSidePanelEdgeLeft => 'Cạnh trái';

  @override
  String get settingsSidePanelEdgeRight => 'Cạnh phải';

  @override
  String get settingsErrorReporting => 'Báo cáo lỗi';

  @override
  String get settingsErrorReportingSubtitle => 'Gửi báo cáo lỗi ẩn danh để giúp cải thiện WhisPaste';

  @override
  String get settingsAutoPasteDelay => 'Độ trễ tự dán';

  @override
  String get settingsAutoPasteDelaySubtitle => 'Thời gian chờ trước khi dán vào cửa sổ đang hoạt động';

  @override
  String get settingsAutoPasteBlocklist => 'Danh sách chặn tự dán';

  @override
  String get settingsAutoPasteBlocklistSubtitle => 'Danh sách ứng dụng không tự dán, ngăn cách bằng dấu phẩy';

  @override
  String get settingsAutoPasteBlocklistPlaceholder => 'Ví dụ: com.apple.Terminal, com.1password';

  @override
  String get settingsCheckUpdates => 'Kiểm tra cập nhật';

  @override
  String get settingsCheckUpdatesSubtitle => 'Tự kiểm tra phiên bản mới khi khởi động';

  @override
  String get settingsCheckForUpdatesNow => 'Kiểm tra cập nhật ngay';

  @override
  String get settingsUpdates => 'Cập nhật';

  @override
  String get settingsUpdatesSubtitle => 'Kênh phát hành và kiểm tra cập nhật';

  @override
  String get settingsBetaUpdates => 'Nhận bản thử nghiệm';

  @override
  String get settingsBetaUpdatesSubtitle => 'Nhận bản phát hành sớm chưa được kiểm thử đầy đủ.';

  @override
  String get settingsStableRevertHintMessage => 'Không thể tự động quay về bản ổn định vì bạn đã cài phiên bản thử nghiệm mới hơn.';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingBack => 'Quay lại';

  @override
  String get onboardingPrivacyTitle => 'Giúp cải thiện WhisPaste';

  @override
  String get onboardingPrivacyHint => 'Âm thanh và văn bản được giữ trên máy. Thống kê ẩn danh gửi tới máy chủ tự quản ở EU, báo cáo lỗi tới Sentry (EU), tuân thủ GDPR.';

  @override
  String get onboardingPrivacyToggle => 'Chia sẻ thống kê ẩn danh';

  @override
  String get onboardingPrivacyToggleHint => 'Mặc định bật, có thể tắt bất cứ lúc nào';

  @override
  String get onboardingPrivacyCrashToggle => 'Gửi báo cáo lỗi ẩn danh';

  @override
  String get onboardingPrivacyCrashToggleHint => 'Giúp sửa lỗi, mặc định bật và có thể tắt bất cứ lúc nào';

  @override
  String get onboardingAppearancePageTitle => 'Giao diện';

  @override
  String get onboardingAppearancePageSubtitle => 'Cách khởi động ứng dụng và kiểu hiển thị lớp phủ ghi âm';

  @override
  String get onboardingBeat1Title => 'Nhấn phím tắt, nói và xong';

  @override
  String get onboardingBeat1Caption => 'Bắt đầu ghi ngay lập tức — lời nói được chuyển thành chữ tại vị trí con trỏ.';

  @override
  String get onboardingBeat2Title => 'Xử lý trực tiếp trên máy';

  @override
  String get onboardingBeat2Caption => 'Nhận diện ngay trên thiết bị, không cần Internet.';

  @override
  String get onboardingBeat3Title => 'Dùng ở mọi nơi có thể nhập chữ';

  @override
  String get onboardingBeat3Caption => 'Trình duyệt, email hay trình soạn thảo — WhisPaste hoạt động toàn hệ thống.';

  @override
  String get onboardingMicChipReady => 'Micro đã sẵn sàng';

  @override
  String get onboardingMicChipPending => 'Đang chờ quyền micro';

  @override
  String get onboardingMicChipAction => 'Cần cấp quyền micro';

  @override
  String get onboardingModelTitle => 'Thiết lập nhận diện giọng nói';

  @override
  String get onboardingModelSubtitle => 'Tải mô hình AI để nhận diện ngoại tuyến. Giọng nói của bạn không rời khỏi máy.';

  @override
  String get onboardingModelRecommended => 'Đề xuất';

  @override
  String get onboardingModelChangeLater => 'Có thể đổi chất lượng sau trong Cài đặt';

  @override
  String get onboardingModelDownloading => 'Đang tải…';

  @override
  String get onboardingModelReady => 'Mô hình đã sẵn sàng';

  @override
  String get onboardingModelGpuCpuFallback => 'Không có chế độ tăng tốc GPU phù hợp. Ứng dụng sẽ dùng CPU.';

  @override
  String get onboardingModelEngineParakeetLabel => 'Nhanh, hỗ trợ tiếng châu Âu';

  @override
  String get onboardingModelEngineParakeetDesc => 'Chuyển lời nói thành chữ rất nhanh với khoảng 25 ngôn ngữ châu Âu; hoạt động tốt trên CPU.';

  @override
  String get onboardingModelEngineWhisperLabel => 'Whisper đa ngôn ngữ';

  @override
  String get onboardingModelEngineWhisperDesc => 'Hỗ trợ nhiều ngôn ngữ, từ vựng tùy chỉnh và gợi ý dấu câu cho tên riêng, chữ viết tắt và thuật ngữ.';

  @override
  String get onboardingModelEngineUnsupportedLanguage => 'Chưa hỗ trợ ngôn ngữ bạn chọn';

  @override
  String get onboardingTestRecordingTitle => 'Thử ghi âm';

  @override
  String get onboardingTestRecordingSubtitle => 'Nhấn nút bên dưới rồi nói một câu. Chữ sẽ hiện trong ô thử nghiệm. Bạn cũng có thể dùng phím tắt.';

  @override
  String get onboardingTestRecordingHotkeyLabel => 'Phím tắt của bạn';

  @override
  String get onboardingTestRecordingStartCta => 'Bắt đầu ghi âm';

  @override
  String get onboardingTestRecordingStopCta => 'Dừng ghi âm';

  @override
  String get onboardingTestRecordingCompletionHint => 'Hãy thử ghi âm trước khi tiếp tục.';

  @override
  String get onboardingTestRecordingMicBypassCta => 'Tiếp tục không dùng micro';

  @override
  String get onboardingTestRecordingMicBypassHint => 'Nếu micro chưa hoạt động, WhisPaste chưa thể ghi âm. Bạn có thể kiểm tra lại qua trạng thái micro ở trang này hoặc Cài đặt.';

  @override
  String get onboardingTestRecordingPlaceholder => 'Văn bản bạn đọc sẽ hiện tại đây…';

  @override
  String get onboardingTestRecordingInProgress => 'Đang ghi âm: hãy bắt đầu nói. Nhấn lần nữa để dừng.';

  @override
  String get onboardingTestRecordingDoneMessage => 'Đã xong! Ứng dụng sẽ hoạt động như vậy ở mọi ô nhập chữ.';

  @override
  String get onboardingTestRecordingReassurance => 'Đây chỉ là thử nghiệm; chữ chỉ nằm trong ô này.';

  @override
  String get onboardingReadyTitle => 'Thiết lập hoàn tất!';

  @override
  String get onboardingReadySubtitle => 'Cách sử dụng WhisPaste';

  @override
  String get onboardingReadyStep1 => 'Nhấn phím tắt để bắt đầu ghi âm';

  @override
  String get onboardingReadyStep2 => 'Nhấn lần nữa để dừng và nhận diện';

  @override
  String get onboardingReadyStep3AutoPaste => 'Chữ tự nhập vào ứng dụng đang mở';

  @override
  String get onboardingReadyStep3CopyOnly => 'Chữ đã được sao chép; nhấn ⌘V / Ctrl+V để dán';

  @override
  String get onboardingReadyContextCarryoverHint => 'WhisPaste có thể dùng ngữ cảnh từ lần ghi âm trước trong tối đa 10 phút. Khi chuyển sang chủ đề khác, hãy tạm dừng một lát để giảm nhầm lẫn.';

  @override
  String get onboardingReadyAutostartToggle => 'Mở WhisPaste khi đăng nhập';

  @override
  String get onboardingReadyAutostartToggleHint => 'Mặc định tắt; có thể bật trong Cài đặt';

  @override
  String get onboardingTriggerTitle => 'Bạn muốn bắt đầu ghi âm bằng cách nào?';

  @override
  String get onboardingTriggerSubtitle => 'Chọn phím tắt và cách khởi động ghi âm.';

  @override
  String get onboardingTriggerCurrentHotkey => 'Phím tắt hiện tại';

  @override
  String get onboardingTriggerHotkeyConflictTitle => 'Phím tắt đã được sử dụng';

  @override
  String get onboardingTriggerHotkeyConflictBody => 'Có thể ứng dụng khác đang dùng phím tắt này. Hãy chọn tổ hợp mới bên dưới.';

  @override
  String get onboardingReadyHotkeyConflictBody => 'Quay lại trang phím tắt để đặt tổ hợp khác.';

  @override
  String get onboardingTriggerModeHoldHint => 'Giữ phím để nói; thả ra để kết thúc';

  @override
  String get onboardingTriggerModeToggleHint => 'Nhấn một lần để bắt đầu, nhấn lần nữa để kết thúc';

  @override
  String get onboardingTriggerSystemWideHint => 'Hoạt động toàn hệ thống, không chỉ trong WhisPaste.';

  @override
  String get onboardingStartUsing => 'Bắt đầu sử dụng';

  @override
  String get onboardingReviewExit => 'Đóng hướng dẫn';

  @override
  String get onboardingReviewDone => 'Xong';

  @override
  String get onboardingReviewEntry => 'Hướng dẫn';

  @override
  String get onboardingReviewSubtitle => 'Xem lại năm bước thiết lập bất cứ lúc nào; các cài đặt chỉ thay đổi khi bạn chỉnh.';

  @override
  String get onboardingReviewLabel => 'Xem lại hướng dẫn';

  @override
  String get onboardingReviewAction => 'Mở';

  @override
  String get onboardingRevisionNoticeTitle => 'WhisPaste đã cập nhật — cài đặt của bạn không thay đổi.';

  @override
  String get onboardingRevisionExit => 'Thoát hướng dẫn';

  @override
  String get onboardingRevisionExitConfirmTitle => 'Thoát hướng dẫn?';

  @override
  String get onboardingRevisionExitConfirmBody => 'Hướng dẫn bản cập nhật chỉ hiện một lần; các bước bỏ qua sẽ không được thiết lập. Có thể mở lại trong Cài đặt → Hướng dẫn.';

  @override
  String get onboardingRevisionExitConfirmAction => 'Thoát';

  @override
  String get overlayRecording => 'Đang ghi âm';

  @override
  String get overlayTranscribing => 'Đang nhận diện…';

  @override
  String get overlayRefining => 'Đang xử lý lại…';

  @override
  String get overlayDone => 'Đã sao chép';

  @override
  String get overlayDonePasted => 'Đã dán';

  @override
  String get overlayDoneBoth => 'Đã sao chép và dán';

  @override
  String get overlayDoneReady => 'Xong';

  @override
  String get overlayError => 'Lỗi';

  @override
  String get overlayCancel => 'Hủy';

  @override
  String get overlayPause => 'Tạm dừng';

  @override
  String get overlayResume => 'Tiếp tục';

  @override
  String get overlayStop => 'Dừng';

  @override
  String get overlayKeyboardHintNextFieldEnterOnly => 'Enter: ô tiếp · Esc: hủy';

  @override
  String get overlayProcessingLocal => 'Trên máy';

  @override
  String get overlayProcessingCloud => 'Đám mây';

  @override
  String get overlayRecordingQuickNote => 'Đang ghi âm vào ghi chú';

  @override
  String get overlayTargetQuickNote => 'Ghi chú';

  @override
  String get overlayDoneQuickNote => 'Đã thêm vào ghi chú';

  @override
  String get floatingButtonHide => 'Ẩn';

  @override
  String get floatingButtonQuit => 'Thoát';

  @override
  String get a11yRecordingButton => 'Nút ghi âm';

  @override
  String get a11yRecordingOverlay => 'Lớp phủ ghi âm';

  @override
  String get a11ySidePanel => 'Thanh dán nhanh';

  @override
  String get trayStatusRecording => 'Đang ghi âm…';

  @override
  String get trayStatusReady => 'Sẵn sàng';

  @override
  String get trayStartRecording => 'Bắt đầu ghi âm';

  @override
  String get trayStopRecording => 'Dừng ghi âm';

  @override
  String get trayOpenApp => 'Mở WhisPaste';

  @override
  String get traySettings => 'Cài đặt';

  @override
  String get trayQuit => 'Thoát';

  @override
  String get trayMicrophone => 'Micro';

  @override
  String get settingsComingSoon => 'Sắp có';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get hintDismiss => 'Bỏ gợi ý';

  @override
  String get voiceNoteButton => 'Ghi chú bằng giọng nói';

  @override
  String get voiceNoteRecording => 'Đang ghi âm ghi chú…';

  @override
  String get voiceNoteTranscribing => 'Đang nhận diện…';

  @override
  String get voiceNoteAdded => 'Đã thêm ghi chú bằng giọng nói';

  @override
  String get voiceCorrectionApplied => 'Đã sửa bản nhận diện bằng giọng nói';

  @override
  String get voiceCorrectionUndone => 'Đã hoàn tác sửa';

  @override
  String get voiceNoteEmpty => 'Không phát hiện lời nói';

  @override
  String get voiceNoteError => 'Ghi chú bằng giọng nói thất bại';

  @override
  String get historyVoiceNoteButtonTooltip => 'Ghi chú bằng giọng nói — nói “nhãn: …” để thêm nhãn hoặc “sửa: …” để viết lại bản nhận diện này';

  @override
  String get updateReadyToInstall => 'Đã sẵn sàng cập nhật, nhấn để cài đặt';

  @override
  String get updateUpToDate => 'Bạn đang dùng phiên bản mới nhất';

  @override
  String get updateCheckNow => 'Kiểm tra ngay';

  @override
  String get updateInstall => 'Cài bản cập nhật';

  @override
  String get updateDownload => 'Tải xuống';

  @override
  String get updateViewRelease => 'Ghi chú phát hành';

  @override
  String get updateError => 'Không thể kiểm tra cập nhật';

  @override
  String get updateRateLimited => 'Quá nhiều yêu cầu. Hãy thử lại sau.';

  @override
  String get settingsOverlaySize => 'Kích thước lớp phủ';

  @override
  String get settingsOverlaySizeSubtitle => 'Chọn chế độ chi tiết hoặc tối giản';

  @override
  String get settingsOverlaySizeNormal => 'Bình thường';

  @override
  String get settingsOverlaySizeCompact => 'Gọn';

  @override
  String get settingsOverlaySizeMini => 'Rất nhỏ';

  @override
  String get settingsOverlayStyle => 'Kiểu lớp phủ';

  @override
  String get settingsOverlayStyleSubtitle => 'Chọn nền kính mờ hoặc nền đặc';

  @override
  String get settingsOverlayStyleGlass => 'Kính mờ';

  @override
  String get settingsOverlayStyleSolid => 'Nền đặc';

  @override
  String get settingsOverlayLiveTranscript => 'Hiện chữ khi đang nói';

  @override
  String get settingsOverlayLiveTranscriptSubtitle => 'Hiển thị chữ nhận diện trực tiếp khi đang nói thay vì chỉ hiển thị sóng âm. Tính năng này dùng thêm CPU.';

  @override
  String get overlayRetry => 'Thử lại';

  @override
  String get overlayDismiss => 'Bỏ qua';

  @override
  String get overlayContextCancel => 'Hủy ghi âm';

  @override
  String get overlayContextSwitchNormal => 'Chế độ bình thường';

  @override
  String get overlayContextSwitchCompact => 'Chế độ gọn';

  @override
  String get overlayContextSwitchMini => 'Chế độ rất nhỏ';

  @override
  String get overlayContextHide => 'Ẩn lớp phủ';

  @override
  String get buttonContextOpen => 'Mở WhisPaste';

  @override
  String get buttonContextStartRecording => 'Bắt đầu ghi âm';

  @override
  String get buttonContextShowHistory => 'Xem lịch sử';

  @override
  String get buttonContextSettings => 'Cài đặt';

  @override
  String get buttonContextQuit => 'Thoát WhisPaste';

  @override
  String get settingsHistory => 'Lịch sử';

  @override
  String get settingsHistorySubtitle => 'Lưu trữ và tự động dọn dẹp';

  @override
  String get settingsHistoryMaxEntries => 'Số mục tối đa';

  @override
  String get settingsHistoryMaxEntriesUnlimited => 'Không giới hạn';

  @override
  String get settingsHistoryAutoTrashDays => 'Tự xóa thùng rác sau';

  @override
  String get settingsHistoryAutoTrashNever => 'Không bao giờ';

  @override
  String get settingsHistoryRetentionPreset => 'Thời hạn lưu';

  @override
  String get settingsHistoryPresetMinimal => 'Tối thiểu';

  @override
  String get settingsHistoryPresetStandard => 'Tiêu chuẩn';

  @override
  String get settingsHistoryPresetUnlimited => 'Không giới hạn';

  @override
  String get settingsHistoryPresetCustom => 'Tùy chỉnh';

  @override
  String get settingsHistoryHideOnOpen => 'Ẩn lịch sử khi mở';

  @override
  String get settingsHistoryHideOnOpenSubtitle => 'Hiển thị nút “Xem lịch sử” thay cho nội dung khi ứng dụng khởi động hoặc mở lại cửa sổ';

  @override
  String get historyPinGateTitle => 'Lịch sử đã bị khóa';

  @override
  String get historyPinGateHint => 'Nhập mã PIN để xem các bản nhận diện.';

  @override
  String get historyPinUnlock => 'Mở khóa';

  @override
  String get historyPinDialogTitle => 'Nhập mã PIN';

  @override
  String get historyPinDialogSubtitle => 'Lịch sử của bạn được bảo vệ bằng mã PIN.';

  @override
  String get historyPinFieldHint => 'Mã PIN';

  @override
  String get historyPinRepeatHint => 'Nhập lại mã PIN';

  @override
  String get historyPinWrong => 'Mã PIN không đúng.';

  @override
  String get historyPinForgot => 'Quên mã PIN?';

  @override
  String get historyPinForgotConfirmTitle => 'Xóa lịch sử và bỏ mã PIN?';

  @override
  String get historyPinForgotConfirmMessage => 'Không thể khôi phục mã PIN đã quên. Để đặt lại, toàn bộ lịch sử gồm mục lưu trữ, thùng rác và bản ghi được giữ lại sẽ bị xóa vĩnh viễn.';

  @override
  String get historyPinForgotConfirmAction => 'Xóa lịch sử';

  @override
  String get historyPinSetTitle => 'Đặt mã PIN';

  @override
  String get historyPinSetSubtitle => 'Mã gồm 4–8 chữ số. Giúp ngăn người khác xem lịch sử trên máy này, nhưng không mã hóa dữ liệu.';

  @override
  String get historyPinInvalid => 'Nhập từ 4 đến 8 chữ số.';

  @override
  String get historyPinMismatch => 'Hai mã PIN không khớp.';

  @override
  String get settingsHistoryPin => 'Bảo vệ bằng mã PIN';

  @override
  String get settingsHistoryPinSubtitle => 'Yêu cầu mã PIN để xem lịch sử, kể cả trong thanh bên, nút nổi và API tự động hóa.';

  @override
  String get settingsHistoryPinChange => 'Thay đổi';

  @override
  String get settingsHistoryPinRemove => 'Gỡ bỏ';

  @override
  String get settingsHistoryAutoLock => 'Tự khóa';

  @override
  String get settingsHistoryAutoLockSubtitle => 'Ẩn lại lịch sử sau khoảng thời gian không thao tác.';

  @override
  String get settingsHistoryAutoLockNever => 'Không bao giờ';

  @override
  String get settingsFloatingButtonSection => 'Nút nổi';

  @override
  String get settingsFloatingButtonSectionSubtitle => 'Nút ghi âm luôn nổi để thao tác nhanh';

  @override
  String get settingsSttIdleTimeout => 'Thời gian chờ khi không dùng AI';

  @override
  String get settingsSttIdleTimeoutSubtitle => 'Thời gian giữ mô hình nhận diện trong bộ nhớ sau khi sử dụng';

  @override
  String get settingsSttIdleTimeoutKeepAlive => 'Luôn giữ hoạt động';

  @override
  String get reviewPromptTitle => 'Bạn có thích WhisPaste không?';

  @override
  String get reviewPromptBody => 'Đánh giá của bạn giúp người khác biết đến ứng dụng và hỗ trợ phát triển.';

  @override
  String get reviewPromptYes => 'Rất thích!';

  @override
  String get reviewPromptNotNow => 'Để sau';

  @override
  String get reviewPromptNever => 'Đừng hỏi lại';

  @override
  String get reviewPromptStarGitHub => '⭐ Đánh dấu sao trên GitHub';

  @override
  String get reviewPromptRateStore => '★ Đánh giá trên cửa hàng';

  @override
  String get reviewPromptGateBody => 'Chỉ là câu hỏi nhanh, chưa phải đánh giá trên cửa hàng.';

  @override
  String get reviewPromptGateYes => 'Có, tôi thích';

  @override
  String get reviewPromptGateNo => 'Không hẳn';

  @override
  String get reviewSupportEntry => 'Đánh giá và ủng hộ WhisPaste';

  @override
  String get reviewSupportLabel => 'Đánh giá của bạn';

  @override
  String get reviewSupportSubtitle => 'Đánh giá giúp người khác biết đến WhisPaste và hỗ trợ dự án.';

  @override
  String get reviewSupportAction => 'Đánh giá';

  @override
  String get ideasBoardLabel => 'Ý tưởng và đề xuất tính năng';

  @override
  String get ideasBoardAction => 'Xem bảng ý tưởng';

  @override
  String get feedbackIdeasLink => 'Đề xuất và bình chọn ý tưởng';

  @override
  String get insufficientRamTitle => 'Không đủ bộ nhớ';

  @override
  String get insufficientRamQuit => 'Thoát WhisPaste';

  @override
  String get insufficientRamLearnMore => 'Yêu cầu hệ thống';

  @override
  String get insufficientRamSystemCheck => 'Kiểm tra hệ thống';

  @override
  String get insufficientRamYourSystem => 'Hệ thống của bạn';

  @override
  String get insufficientRamRequired => 'Yêu cầu';

  @override
  String get hotkeyRegistrationFailed => 'Đăng ký phím tắt thất bại. Hãy đặt lại trong Cài đặt.';

  @override
  String get hotkeyRegistrationFailedDefaultActive => 'Đăng ký phím tắt thất bại, tạm dùng Ctrl+Shift+Space. Hãy đặt lại trong Cài đặt.';

  @override
  String get exportFormatPickerTitle => 'Chọn định dạng xuất';

  @override
  String get exportFormatText => 'Văn bản';

  @override
  String get exportFormatMarkdown => 'Markdown';

  @override
  String get exportFormatCsv => 'CSV';

  @override
  String get exportFormatJson => 'JSON';

  @override
  String get exportFormatWord => 'Word';

  @override
  String get cpuFallbackToast => 'Nhận diện đang chậm hơn bình thường một chút nhưng vẫn xử lý.';

  @override
  String get recoveryExhaustedToast => 'Không thể khởi động dịch vụ nhận diện. Hãy khởi động lại ứng dụng hoặc tải lại mô hình.';

  @override
  String get recoveryExhaustedAction => 'Mở Cài đặt';

  @override
  String get recoveryVcRuntimeToast => 'Không thể khởi động dịch vụ nhận diện vì thiếu thành phần Microsoft Visual C++ trên Windows. Hãy cài Visual C++ Redistributable (x64) rồi mở lại WhisPaste.';

  @override
  String get recoveryVcRuntimeAction => 'Cài đặt';

  @override
  String get modelAbiInfoToast => 'Đang tải lại mô hình giọng nói, vui lòng chờ.';

  @override
  String get recoveryGpuDisabledToast => 'WhisPaste đã tắt tăng tốc GPU vì lần khởi động trước gặp lỗi. Bạn vẫn có thể đọc và nhận diện bình thường.';

  @override
  String get serverDownloadFailedToast => 'Không thể tải dịch vụ nhận diện. Hãy kiểm tra Internet.';

  @override
  String get serverDownloadFailedAction => 'Thử lại';

  @override
  String get serverDownloadStalledToast => 'Tải xuống bị gián đoạn, đang kết nối lại.';

  @override
  String get historyWriteFailedToast => 'Không thể lưu mục này. Hãy kiểm tra dung lượng còn trống.';

  @override
  String get historyWriteFailedAction => 'Sao chép thông tin lỗi';

  @override
  String get factoryResetFailedToast => 'Chưa thể đặt lại hoàn toàn. Khởi động lại ứng dụng?';

  @override
  String get factoryResetFailedAction => 'Thoát ứng dụng';

  @override
  String get errorSttRejectEmpty => 'Không có âm thanh để nhận diện. Hãy ghi lại.';

  @override
  String get errorSttRejectInvalidWav => 'File âm thanh bị lỗi. Hãy ghi lại.';

  @override
  String get errorSttRejectUnsupportedLanguage => 'Mô hình không hỗ trợ ngôn ngữ này. Hãy kiểm tra ngôn ngữ trong Cài đặt.';

  @override
  String get errorSttRejectPromptTooLong => 'Từ vựng tùy chỉnh quá dài. Hãy rút gọn trong Cài đặt.';

  @override
  String get settingsGpuAcceleration => 'Tăng tốc đồ họa';

  @override
  String get settingsGpuAccelerationSubtitle => 'Chọn CPU hoặc GPU để nhận diện giọng nói trên máy';

  @override
  String get settingsGpuAccelerationAuto => 'Tự động (đề xuất)';

  @override
  String get settingsGpuAccelerationEnabled => 'Chỉ định dùng GPU';

  @override
  String get settingsGpuAccelerationDisabled => 'Chỉ dùng CPU';

  @override
  String get settingsSttEngine => 'Bộ máy nhận diện';

  @override
  String get settingsSttEngineSubtitle => 'Whisper hỗ trợ 99 ngôn ngữ và nhiều GPU. Parakeet nhanh hơn trên máy chỉ có CPU nhưng hỗ trợ ít ngôn ngữ hơn.';

  @override
  String get settingsSttEngineWhisper => 'Whisper';

  @override
  String get settingsSttEngineParakeet => 'Parakeet (nhanh, hỗ trợ khoảng 25 ngôn ngữ)';

  @override
  String get parakeetModelTitle => 'Mô hình Parakeet TDT';

  @override
  String get parakeetModelSubtitle => 'Chỉ tải một lần (khoảng 640 MB), sau đó dùng hoàn toàn ngoại tuyến';

  @override
  String get parakeetModelDownload => 'Tải xuống';

  @override
  String get parakeetModelDownloading => 'Đang tải…';

  @override
  String get parakeetModelInstalled => 'Đã cài';

  @override
  String get parakeetModelDelete => 'Xóa';

  @override
  String get parakeetModelCancel => 'Hủy';

  @override
  String get settingsSearchHint => 'Tìm cài đặt…';

  @override
  String get settingsSearchNoResults => 'Không có kết quả';

  @override
  String get settingsSearchNoResultsHint => 'Thử từ khóa tìm kiếm khác.';

  @override
  String get settingsSearchFieldLabel => 'Tìm cài đặt';

  @override
  String get settingsPrivacy => 'Quyền riêng tư';

  @override
  String get settingsPrivacySubtitle => 'Quản lý dữ liệu mà WhisPaste chia sẻ';

  @override
  String get settingsShareUsageStats => 'Chia sẻ thống kê sử dụng ẩn danh';

  @override
  String get settingsShareUsageStatsSubtitle => 'Thống kê không chứa cookie hay mã nhận dạng, giúp cải thiện ứng dụng';

  @override
  String get settingsRetainRecentAudio => 'Giữ lại bản ghi gần đây';

  @override
  String get settingsRetainRecentAudioSubtitle => 'Giữ âm thanh của 20 lần đọc gần nhất để kiểm tra hoặc khôi phục; bản ghi cũ tự động bị xóa';

  @override
  String get storeThankYouTitle => 'Cảm ơn bạn đã ủng hộ!';

  @override
  String get storeThankYouBody => 'Rất vui vì bạn sử dụng WhisPaste. Nếu ứng dụng giúp công việc dễ dàng hơn, một đánh giá ngắn sẽ là sự ủng hộ lớn.';

  @override
  String get storeThankYouCtaStore => '★ Đánh giá trên cửa hàng';

  @override
  String get storeThankYouCtaGitHub => '⭐ Đánh dấu sao trên GitHub';

  @override
  String get storeThankYouDismiss => 'Đóng';

  @override
  String get featureSpotlightHeading => 'Điểm mới của WhisPaste';

  @override
  String get featureSpotlightDismiss => 'Đã hiểu';

  @override
  String get featureSpotlightSnippetPickerTitle => 'Bộ chọn mẫu văn bản';

  @override
  String get featureSpotlightSnippetPickerDescription => 'Lưu đoạn văn bản hay dùng và chèn ở bất cứ đâu bằng phím tắt hoặc từ khóa nói, không cần gõ lại.';

  @override
  String get featureSpotlightSidePanelTitle => 'Thanh bộ nhớ tạm';

  @override
  String get featureSpotlightSidePanelDescription => 'Đưa chuột đến mép màn hình để xem nội dung đã sao chép và kéo mục vào tài liệu.';

  @override
  String get featureSpotlightInteractiveSnippetsTitle => 'Mẫu tương tác';

  @override
  String get featureSpotlightInteractiveSnippetsDescription => 'Mẫu có các ô trống: ứng dụng hướng dẫn điền lần lượt từng ô bằng giọng nói. Nhấn Enter để sang ô sau, rồi dán toàn bộ văn bản.';

  @override
  String get featureSpotlightSmartModeTitle => 'Chế độ thông minh';

  @override
  String get featureSpotlightSmartModeDescription => 'Làm sạch, rút gọn hoặc dịch văn bản trước khi dán ngay trên máy; có phím tắt, cấu hình và ngôn ngữ đích riêng.';

  @override
  String get featureSpotlightHistoryPinTitle => 'Khóa lịch sử bằng mã PIN';

  @override
  String get featureSpotlightHistoryPinDescription => 'Bảo vệ lịch sử nhận diện bằng PIN, gồm thanh bên và menu nút nổi. Có thể tự khóa khi không dùng. Cài đặt → Lịch sử.';

  @override
  String get featureSpotlightChangelogLink => 'Xem nhật ký thay đổi';

  @override
  String get featureSpotlightReviewLabel => 'Xem tính năng mới';

  @override
  String get featureSpotlightReviewAction => 'Hiện';

  @override
  String get notesNewNote => 'Ghi chú mới';

  @override
  String get notesEmptyTitle => 'Chưa có ghi chú';

  @override
  String get notesEmptyHint => 'Tạo ghi chú để lưu văn bản từ bất cứ ứng dụng nào.';

  @override
  String get notesUntitled => 'Ghi chú chưa có tên';

  @override
  String get notesEditorPlaceholder => 'Bắt đầu nhập…';

  @override
  String get notesListSemantics => 'Danh sách ghi chú';

  @override
  String get notesCopy => 'Sao chép ghi chú';

  @override
  String get notesCopied => 'Đã sao chép ghi chú';

  @override
  String get notesFavorite => 'Đánh dấu yêu thích';

  @override
  String get notesUnfavorite => 'Bỏ yêu thích';

  @override
  String get notesQuickNoteSet => 'Đặt làm ghi chú nhanh để phím tắt bổ sung nội dung';

  @override
  String get notesQuickNoteClear => 'Bỏ đánh dấu ghi chú nhanh';

  @override
  String get notesQuickNoteHotkeyLabel => 'Phím tắt';

  @override
  String get notesQuickNoteHotkeyOff => 'Phím tắt ghi chú nhanh đang tắt.';

  @override
  String get notesQuickNoteHotkeyEnable => 'Bật phím tắt';

  @override
  String get notesMoveToTrash => 'Chuyển vào thùng rác';

  @override
  String get notesMovedToTrash => 'Đã chuyển vào thùng rác';

  @override
  String get notesRestore => 'Khôi phục';

  @override
  String get notesDeleteForever => 'Xóa vĩnh viễn';

  @override
  String get notesDeleteForeverConfirm => 'Xóa vĩnh viễn ghi chú?';

  @override
  String get notesTrash => 'Thùng rác';

  @override
  String get notesTrashEmpty => 'Thùng rác đang trống';

  @override
  String get notesTrashEmptyHint => 'Ghi chú bị xóa được chuyển vào đây và không bị tự xóa.';

  @override
  String get notesUndo => 'Hoàn tác';

  @override
  String get notesAddTag => 'Thêm nhãn';

  @override
  String get notesTagPlaceholder => 'Tên nhãn…';

  @override
  String get notesSearchPlaceholder => 'Tìm ghi chú…';

  @override
  String get notesSearchFieldLabel => 'Tìm ghi chú';

  @override
  String get notesNoResults => 'Không tìm thấy kết quả';

  @override
  String get notesExport => 'Xuất';

  @override
  String get markdownToolbarHeading => 'Tiêu đề';

  @override
  String get markdownToolbarNumberedList => 'Danh sách đánh số';

  @override
  String get markdownToolbarQuote => 'Trích dẫn';

  @override
  String get markdownToolbarCode => 'Mã';

  @override
  String get findReplaceToggle => 'Tìm và thay thế trong văn bản';

  @override
  String get findReplaceFindLabel => 'Tìm trong văn bản';

  @override
  String get findReplaceFindHint => 'Tìm…';

  @override
  String get findReplaceReplaceLabel => 'Thay kết quả tìm bằng';

  @override
  String get findReplaceReplaceHint => 'Thay bằng…';

  @override
  String get findReplaceNext => 'Kết quả tiếp theo';

  @override
  String get findReplacePrevious => 'Kết quả trước';

  @override
  String get findReplaceReplaceAction => 'Thay mục này';

  @override
  String get findReplaceReplaceAllAction => 'Thay tất cả';

  @override
  String get findReplaceClose => 'Đóng tìm và thay thế';

  @override
  String get findReplaceNoMatches => 'Không tìm thấy';

  @override
  String get sidePanelTranscriptionsTitle => 'Bản nhận diện';

  @override
  String get sidePanelSnippetsTitle => 'Mẫu văn bản';

  @override
  String get sidePanelClipboardHistoryTitle => 'Lịch sử sao chép';

  @override
  String get sidePanelClipboardHistoryEmpty => 'Chưa sao chép gì';

  @override
  String get sidePanelClipboardHistoryEmptyHint => 'Nội dung sao chép khi WhisPaste chạy sẽ hiện ở đây và được xóa khi khởi động lại.';

  @override
  String get sidePanelClose => 'Đóng thanh bên';

  @override
  String get sidePanelSearchHint => 'Tìm kiếm';

  @override
  String get sidePanelSearchFieldLabel => 'Tìm trong danh sách';

  @override
  String get sidePanelNoMatches => 'Không tìm thấy';

  @override
  String get sidePanelNoMatchesHint => 'Thử từ khóa khác.';

  @override
  String get settingsSmartMode => 'Chế độ thông minh';

  @override
  String get settingsSmartModeSubtitle => 'Làm sạch, rút gọn và dịch văn bản sau khi đọc';

  @override
  String get smartModeStandardPreset => 'Cấu hình mặc định';

  @override
  String get smartModePresetOff => 'Tắt';

  @override
  String get smartModePresetOffDescription => 'Không xử lý thêm: sử dụng đúng văn bản nhận diện được.';

  @override
  String get smartModePresetCleanup => 'Làm sạch';

  @override
  String get smartModePresetCleanupDescription => 'Loại bỏ từ đệm như “ừm”, sửa dấu câu và chữ hoa mà không đổi ý nghĩa hay ngôn ngữ.';

  @override
  String get smartModePresetConcise => 'Rút gọn';

  @override
  String get smartModePresetConciseDescription => 'Rút gọn câu chữ dư thừa nhưng giữ mọi thông tin quan trọng bằng ngôn ngữ gốc.';

  @override
  String get smartModePresetTranslate => 'Dịch';

  @override
  String get smartModePresetTranslateDescription => 'Dịch văn bản đã nhận diện sang ngôn ngữ đích được chọn bên dưới.';

  @override
  String get smartModeTargetLanguage => 'Ngôn ngữ đích';

  @override
  String get smartModeTargetLanguageGerman => 'Tiếng Đức';

  @override
  String get smartModeTargetLanguageEnglish => 'Tiếng Anh';

  @override
  String get smartModeTargetLanguageSpanish => 'Tiếng Tây Ban Nha';

  @override
  String get smartModeTargetLanguageFrench => 'Tiếng Pháp';

  @override
  String get smartModeTargetLanguagePortuguese => 'Tiếng Bồ Đào Nha';

  @override
  String get smartModeTargetLanguageMandarin => 'Tiếng Trung phổ thông';

  @override
  String get smartModeTargetLanguageRussian => 'Tiếng Nga';

  @override
  String get smartModeDownload => 'Tải xuống';

  @override
  String get smartModeDownloadComplete => 'Mô hình chế độ thông minh đã sẵn sàng';

  @override
  String get smartModeRamWarningTitle => 'Phát hiện bộ nhớ thấp';

  @override
  String get smartModeRamWarningBody => 'Mô hình chế độ thông minh hoạt động tốt nhất với RAM từ 8 GB. Máy này có thể chạy chậm hoặc gặp lỗi. Vẫn tải?';

  @override
  String get smartModeRamWarningContinue => 'Vẫn tải';

  @override
  String get smartModeRamWarningCancel => 'Hủy';

  @override
  String get smartModeMemoryFootprintInfo => 'Chạy hoàn toàn trên máy, dùng khoảng 4–5 GB RAM khi hoạt động, chưa kể mô hình nhận diện đã tải vào bộ nhớ.';

  @override
  String get smartModeSpeedExampleInfo => 'Ví dụ: đoạn đọc 50 từ thường mất khoảng 1–6 giây xử lý tùy phần cứng.';

  @override
  String get settingsHotkeyActionSmartMode => 'Chế độ thông minh';

  @override
  String get settingsSmartModeHotkeyEnabled => 'Phím tắt chế độ thông minh';

  @override
  String get settingsSmartModeHotkeyHint => 'Ghi âm với chế độ xử lý đã chọn, độc lập với chế độ mặc định. Có thể giữ phím để nói.';

  @override
  String get settingsSmartModeHotkeyPreset => 'Cấu hình có sẵn';

  @override
  String get settingsSmartModeCurrentHotkey => 'Tổ hợp phím';

  @override
  String get settingsSmartModeHotkeyInactive => 'Không thể đăng ký tổ hợp này. Phím tắt chế độ thông minh chưa hoạt động. Chọn tổ hợp khác.';

  @override
  String get smartModeOnboardingHintTitle => 'Thử chế độ thông minh';

  @override
  String get smartModeOnboardingHintBody => 'Có thể tự làm sạch, rút gọn hoặc dịch văn bản hoàn toàn trên máy. Hãy tải mô hình hoặc thiết lập sau trong Cài đặt.';

  @override
  String get smartModeOnboardingHintExampleBeforeLabel => 'Lời đọc gốc';

  @override
  String get smartModeOnboardingHintExampleBefore => 'ừm, lịch họp với khách đã dời sang thứ Năm lúc ba giờ chiều, và chúng ta vẫn cần slide cập nhật từ phòng marketing';

  @override
  String get smartModeOnboardingHintExampleAfterLabel => 'Kết quả chế độ thông minh';

  @override
  String get smartModeOnboardingHintExampleAfter => 'Lịch họp với khách đã dời sang thứ Năm lúc 15 giờ. Chúng ta vẫn cần slide cập nhật từ bộ phận tiếp thị.';

  @override
  String get smartModeOnboardingHintDownloadCta => 'Tải xuống';

  @override
  String get smartModeOnboardingHintSkipCta => 'Bỏ qua';

  @override
  String get smartModeUsageHintTitle => 'Thử chế độ thông minh cho lần ghi âm tới';

  @override
  String get smartModeUsageHintBody => 'Chế độ thông minh có thể tự làm sạch, rút gọn hoặc dịch văn bản trên máy. Đây là nội dung bạn vừa đọc:';

  @override
  String get smartModeUsageHintCta => 'Thiết lập';

  @override
  String get smartModeUsageHintDismiss => 'Để sau';

  @override
  String get settingsAutomationApi => 'API tự động hóa nội bộ';

  @override
  String get settingsAutomationApiSubtitle => 'Điều khiển ghi âm từ tập lệnh qua API HTTP chỉ hoạt động trên máy này';

  @override
  String get settingsAutomationApiEnable => 'Bật API tự động hóa nội bộ';

  @override
  String get settingsAutomationApiEnableSubtitle => 'Chỉ sử dụng 127.0.0.1/::1 — không thể truy cập từ mạng ngoài';

  @override
  String get settingsAutomationApiStatusStopped => 'Chưa chạy';

  @override
  String get settingsAutomationApiCustomPortLabel => 'Cổng tùy chỉnh';

  @override
  String get settingsAutomationApiCustomPortSubtitle => 'Để trống nếu muốn tự chọn cổng; sẽ đổi cổng khác khi bị chiếm';

  @override
  String get settingsAutomationApiCustomPortHint => 'Tự động';

  @override
  String get settingsAutomationApiCustomPortInvalid => 'Nhập cổng từ 1024 đến 65535';

  @override
  String get settingsAutomationApiToken => 'Mã truy cập Bearer';

  @override
  String get settingsAutomationApiTokenSubtitle => 'Gửi "Authorization: Bearer <token>"; mọi yêu cầu không có mã đều bị từ chối';

  @override
  String get settingsAutomationApiRegenerate => 'Tạo lại';

  @override
  String get settingsAutomationApiRegenerateConfirmTitle => 'Tạo lại mã truy cập?';

  @override
  String get settingsAutomationApiRegenerateConfirmMessage => 'Mã hiện tại sẽ lập tức hết hiệu lực. Các tập lệnh đang dùng mã này phải được cập nhật.';

  @override
  String get settingsAutomationApiCopyToken => 'Sao chép mã';

  @override
  String get settingsAutomationApiTokenCopied => 'Đã sao chép mã vào bộ nhớ tạm';

  @override
  String get settingsAutomationApiDocumentation => 'Tài liệu';

  @override
  String get settingsAutomationApiDocumentationSubtitle => 'Danh sách điểm cuối và ví dụ lệnh curl';

  @override
  String get settingsAutomationApiDocumentationAction => 'Mở';

  @override
  String get historyShowOriginalTranscript => 'Hiện lời nhận diện gốc';

  @override
  String get historyHideOriginalTranscript => 'Ẩn lời nhận diện gốc';

  @override
  String get historyOriginalTranscriptLabel => 'Lời nhận diện gốc';

  @override
  String get settingsHotkeyActionSelectionEdit => 'Sửa đoạn đã chọn';

  @override
  String get settingsSelectionEditHotkeyEnabled => 'Phím tắt sửa đoạn đã chọn';

  @override
  String get settingsSelectionEditHotkeyHint => 'Chọn văn bản trong ứng dụng bất kỳ, nhấn phím tắt rồi nói yêu cầu, chẳng hạn “rút gọn”, “viết hay hơn” hoặc “dịch”. Kết quả thay thế đoạn đã chọn; hoàn tác để khôi phục bản gốc. Sử dụng mô hình thông minh.';

  @override
  String get settingsSelectionEditHotkeyInactive => 'Không thể đăng ký tổ hợp này. Phím tắt sửa đoạn đã chọn chưa hoạt động. Chọn tổ hợp khác.';

  @override
  String get overlayTargetSelectionEdit => 'Sửa đoạn đã chọn';

  @override
  String get overlayRecordingSelectionEdit => 'Nói nội dung cần sửa';

  @override
  String get overlaySelectionEditHint => 'Nói yêu cầu sửa, chẳng hạn: rút gọn · cải thiện · dịch';

  @override
  String get overlayEditingSelection => 'Đang sửa đoạn đã chọn…';

  @override
  String get overlayDoneSelectionEdit => 'Đã thay thế đoạn được chọn';

  @override
  String get errorSelectionEditNoSelection => 'Chưa chọn văn bản — hãy chọn đoạn cần sửa rồi nhấn phím tắt';

  @override
  String get errorSelectionEditNoEngine => 'Hãy thiết lập Chế độ thông minh trước (tải mô hình hoặc thêm khóa OpenAI) để sửa đoạn đã chọn';

  @override
  String get errorSelectionEditUnsupported => 'Sửa đoạn đã chọn cần chức năng tự dán, chưa có trong bản này';

  @override
  String get errorSelectionEditCopyFailed => 'Không đọc được đoạn đã chọn — kiểm tra quyền tự dán';

  @override
  String get errorSelectionEditFailed => 'Không thể sửa — văn bản gốc được giữ nguyên';

  @override
  String get errorSelectionEditPasteFailed => 'Không thể thay thế đoạn đã chọn — văn bản gốc được giữ nguyên';

  @override
  String historyItemsSelected(int count) => _renderVietnamese('Đã chọn {count} mục', {'count': count});

  @override
  String historyWordCount(int count) => _renderVietnamese('{count} từ', {'count': count});

  @override
  String historyReadingTime(int minutes) => _renderVietnamese('Đọc trong {minutes} phút', {'minutes': minutes});

  @override
  String historyNoResultsHint(String query) => _renderVietnamese('Không có bản nhận diện nào khớp với "{query}".\nHãy thử từ khóa khác.', {'query': query});

  @override
  String historyTrashEmptied(int count) => _renderVietnamese('{count, plural, =1{Đã dọn thùng rác — xóa 1 mục} other{Đã dọn thùng rác — xóa {count} mục}}', {'count': count});

  @override
  String historyMergeConfirm(int count) => _renderVietnamese('Gộp {count} mục?', {'count': count});

  @override
  String historyResultCount(int count) => _renderVietnamese('{count, plural, =1{1 kết quả} other{{count} kết quả}}', {'count': count});

  @override
  String pasteCapabilityRepairDone(int count) => _renderVietnamese('{count, plural, =0{Không có mục quyền cũ. Hãy thử dán.} =1{Đã xóa 1 mục quyền cũ. Hãy thử dán để cấp quyền mới.} other{Đã xóa {count} mục quyền cũ. Hãy thử dán để cấp quyền mới.}}', {'count': count});

  @override
  String settingsCustomVocabularyBudgetCounter(int count, int budget) => _renderVietnamese('Khoảng {count} / {budget} token', {'count': count, 'budget': budget});

  @override
  String settingsCustomVocabularyBudgetWarning(int budget) => _renderVietnamese('Nội dung quá dài có thể tự rút ngắn — chỉ khoảng {budget} token đầu tiên được sử dụng.', {'budget': budget});

  @override
  String settingsPortabilityExportSuccess(String path) => _renderVietnamese('Đã xuất cài đặt vào {path}', {'path': path});

  @override
  String settingsPortabilityExportError(String reason) => _renderVietnamese('Xuất thất bại: {reason}', {'reason': reason});

  @override
  String settingsPortabilityImportConfirmMessage(String path) => _renderVietnamese('Thao tác này thay thế cài đặt hiện tại — gồm giao diện, cấu hình nhận diện, cách hoạt động, từ thay thế và mẫu văn bản — bằng nội dung tại {path}.', {'path': path});

  @override
  String settingsPortabilityImportSuccess(String path) => _renderVietnamese('Đã nhập cài đặt từ {path}', {'path': path});

  @override
  String settingsPortabilityImportNotFound(String path) => _renderVietnamese('Không tìm thấy file xuất tại {path}. Hãy xuất cài đặt trước hoặc chép file vào đó.', {'path': path});

  @override
  String settingsPortabilityImportError(String reason) => _renderVietnamese('Nhập thất bại: {reason}', {'reason': reason});

  @override
  String settingsAutosaveLastRun(String time) => _renderVietnamese('Lần sao lưu gần nhất: {time}', {'time': time});

  @override
  String settingsAutosaveLastRunFailedSince(String time) => _renderVietnamese('Lần thử gần nhất thất bại — bản sao lưu cuối: {time}', {'time': time});

  @override
  String settingsAutosaveErrorWrite(String reason) => _renderVietnamese('Sao lưu tự động thất bại: {reason}', {'reason': reason});

  @override
  String migrationComplete(int count) => _renderVietnamese('{count, plural, one{Đã chuyển 1 bản ghi từ WhisPaste 1.x} other{Đã chuyển {count} bản ghi từ WhisPaste 1.x}}', {'count': count});

  @override
  String aboutVersion(String version) => _renderVietnamese('Phiên bản {version}', {'version': version});

  @override
  String analyticsThisWeek(String delta) => _renderVietnamese('{delta} trong tuần này', {'delta': delta});

  @override
  String analyticsVsLastMonth(String delta) => _renderVietnamese('{delta} so với tháng trước', {'delta': delta});

  @override
  String analyticsDurationHoursMinutes(int hours, int minutes) => _renderVietnamese('{hours} giờ {minutes} phút', {'hours': hours, 'minutes': minutes});

  @override
  String analyticsSavedAmount(String amount) => _renderVietnamese('Đã tiết kiệm {amount}', {'amount': amount});

  @override
  String analyticsSpentAmount(String amount) => _renderVietnamese('Đã chi {amount}', {'amount': amount});

  @override
  String replacementsDeleteMessage(String trigger) => _renderVietnamese('Xóa quy tắc "{trigger}"? Không thể hoàn tác.', {'trigger': trigger});

  @override
  String replacementsImportSummary(int found, int added, int skipped) => _renderVietnamese('Tìm thấy {found}, đã thêm {added}, bỏ qua {skipped} mục trùng', {'found': found, 'added': added, 'skipped': skipped});

  @override
  String correctionCandidatesCardHint(int count) => _renderVietnamese('Có {count} đề xuất từ những cách sửa lặp lại — hãy xem lại trước khi tự động thay thế.', {'count': count});

  @override
  String correctionCandidatesReviewSubtitle(int count) => _renderVietnamese('Có {count} cách sửa được lặp lại — chọn những quy tắc cần áp dụng tự động. Chỉ có hiệu lực sau khi xác nhận.', {'count': count});

  @override
  String correctionCandidatesCommitSummary(int added) => _renderVietnamese('Đã thêm {added} quy tắc thay thế đã học', {'added': added});

  @override
  String replacementsImportReviewSubtitle(int count) => _renderVietnamese('Có {count} mục đề xuất — chọn những mục cần làm quy tắc thay thế. Chỉ thêm sau khi bạn xác nhận.', {'count': count});

  @override
  String replacementsImportReviewSelectedCount(int selected, int total) => _renderVietnamese('Đã chọn {selected}/{total}', {'selected': selected, 'total': total});

  @override
  String replacementsImportReviewImportButton(int count) => _renderVietnamese('Nhập {count} mục đã chọn', {'count': count});

  @override
  String replacementsFuzzyTooShortWarning(int minLength) => _renderVietnamese('Cụm từ kích hoạt dưới {minLength} ký tự không được khớp gần đúng vì dễ nhận nhầm.', {'minLength': minLength});

  @override
  String snippetsFieldNameHint(int number) => _renderVietnamese('Tên trường {number}', {'number': number});

  @override
  String snippetsFieldsMinWarning(int min) => _renderVietnamese('{min, plural, one{Mẫu tương tác cần ít nhất 1 trường có tên} other{Mẫu tương tác cần ít nhất {min} trường có tên}}.', {'min': min});

  @override
  String interactiveSnippetBriefingLabel(int count) => _renderVietnamese('{count, plural, =1{1 trường} other{{count} trường}} · Nhấn Enter để bắt đầu', {'count': count});

  @override
  String interactiveSnippetBriefingHint(String name) => _renderVietnamese('Trường 1: {name} · Esc: hủy', {'name': name});

  @override
  String interactiveSnippetAnnounceLabel(int index, int count, String name) => _renderVietnamese('Trường {index}/{count}: {name}', {'index': index, 'count': count, 'name': name});

  @override
  String interactiveSnippetSpeakNowLabel(String name, int index, int count) => _renderVietnamese('{index}/{count}: {name}', {'name': name, 'index': index, 'count': count});

  @override
  String snippetsDeleteMessage(String title) => _renderVietnamese('Xóa mẫu "{title}"? Không thể hoàn tác.', {'title': title});

  @override
  String statusBarSttBackendTooltip(String backend) => _renderVietnamese('Bộ máy nhận diện: {backend}', {'backend': backend});

  @override
  String statusBarAutomationApiChipLabel(int port) => _renderVietnamese('API: {port}', {'port': port});

  @override
  String statusBarAutomationApiTooltip(int port) => _renderVietnamese('API tự động hóa hoạt động ở cổng {port}', {'port': port});

  @override
  String statusBarAutomationApiTooltipFallback(int port, int requestedPort) => _renderVietnamese('API tự động hóa ở cổng {port} (cổng {requestedPort} đang bận)', {'port': port, 'requestedPort': requestedPort});

  @override
  String qualityTierDownloadSize(String size) => _renderVietnamese('Dung lượng tải {size}', {'size': size});

  @override
  String qualityTierInfoSlow(String ratio) => _renderVietnamese('Chất lượng tốt nhất, cần thời gian xử lý gấp khoảng {ratio} lần', {'ratio': ratio});

  @override
  String qualityTierInfoSlowerThanCompact(String ratio) => _renderVietnamese('Chất lượng tốt nhất, chậm hơn Small khoảng {ratio} lần', {'ratio': ratio});

  @override
  String qualityTierModelTooltip(String modelName, String size) => _renderVietnamese('Whisper {modelName} · {size}', {'modelName': modelName, 'size': size});

  @override
  String analyticsModelDisplayName(String tierLabel, String modelLabel) => _renderVietnamese('{tierLabel} (Whisper {modelLabel})', {'tierLabel': tierLabel, 'modelLabel': modelLabel});

  @override
  String oomRecoveryTrySmallerHint(String model) => _renderVietnamese('Chuyển sang {model} rồi ghi âm lại', {'model': model});

  @override
  String oomRecoveryDowngrading(String model) => _renderVietnamese('Đang chuyển sang {model}…', {'model': model});

  @override
  String oomRecoveryAttemptFailed(String model) => _renderVietnamese('Mô hình {model} cũng thất bại. Đang thử cách tiếp theo…', {'model': model});

  @override
  String historyCreateTag(Object tag) => _renderVietnamese('Tạo "{tag}"', {'tag': tag});

  @override
  String tagUsageCount(int count) => _renderVietnamese('{count, plural, =0{chưa sử dụng} =1{1 mục} other{{count} mục}}', {'count': count});

  @override
  String tagOverflowMore(int count) => _renderVietnamese('{count, plural, =1{thêm 1 nhãn} other{thêm {count} nhãn}}', {'count': count});

  @override
  String tagDeleteConfirmMessage(String name, int count) => _renderVietnamese('Nhãn "{name}" đang dùng trong {count, plural, =1{1 mục} other{{count} mục}}. Nhãn sẽ bị gỡ khỏi tất cả các mục.', {'name': name, 'count': count});

  @override
  String tagDeleted(String name) => _renderVietnamese('Đã xóa nhãn "{name}"', {'name': name});

  @override
  String tagDeleteUnusedMessage(int count) => _renderVietnamese('{count, plural, =1{1 nhãn chưa dùng} other{{count} nhãn chưa dùng}} sẽ bị xóa vĩnh viễn.', {'count': count});

  @override
  String tagDeleteUnusedAction(int count) => _renderVietnamese('Xóa {count} nhãn chưa dùng', {'count': count});

  @override
  String tagDeletedUnused(int count) => _renderVietnamese('Đã xóa {count, plural, =1{1 nhãn chưa dùng} other{{count} nhãn chưa dùng}}', {'count': count});

  @override
  String historySearchActiveTag(String tag) => _renderVietnamese('#{tag}', {'tag': tag});

  @override
  String historySearchActiveLang(String code) => _renderVietnamese('lang:{code}', {'code': code});

  @override
  String settingsQuickNoteHotkeyCollision(String action) => _renderVietnamese('Tổ hợp này đang được dùng cho "{action}". Hãy chọn tổ hợp khác.', {'action': action});

  @override
  String settingsSnippetPickerHotkeyCollision(String action) => _renderVietnamese('Tổ hợp này đang được dùng cho "{action}". Hãy chọn tổ hợp khác.', {'action': action});

  @override
  String settingsStableRevertHintLink(String stableVersion) => _renderVietnamese('Tải bản ổn định {stableVersion} thủ công', {'stableVersion': stableVersion});

  @override
  String onboardingStepOf(int current, int total) => _renderVietnamese('Bước {current} / {total}', {'current': current, 'total': total});

  @override
  String onboardingTestRecordingReassuranceWithDuration(int seconds, String section,) => _renderVietnamese('Đây chỉ là thử nghiệm; chữ nằm trong ô này. Bản ghi tự dừng sau {seconds} giây; chỉnh được tại Cài đặt → {section}.', {'seconds': seconds, 'section': section});

  @override
  String overlayKeyboardHint(String hotkey) => _renderVietnamese('Nhấn {hotkey} để dừng', {'hotkey': hotkey});

  @override
  String overlayKeyboardHintNextFieldEnter(String hotkey) => _renderVietnamese('Enter hoặc {hotkey}: ô tiếp · Esc: hủy', {'hotkey': hotkey});

  @override
  String overlayRecordingTargetTimer(String elapsed, String target) => _renderVietnamese('{elapsed} · {target}', {'elapsed': elapsed, 'target': target});

  @override
  String voiceTagAdded(String tag) => _renderVietnamese('Đã thêm nhãn "{tag}" bằng giọng nói', {'tag': tag});

  @override
  String updateAvailable(String version) => _renderVietnamese('Có bản cập nhật: v{version}', {'version': version});

  @override
  String updateDownloading(int percent) => _renderVietnamese('Đang tải cập nhật… {percent}%', {'percent': percent});

  @override
  String updateStatusBarChip(String version) => _renderVietnamese('Có bản v{version}', {'version': version});

  @override
  String settingsHistoryAutoTrashDaysLabel(int count) => _renderVietnamese('{count, plural, =1{1 ngày} other{{count} ngày}}', {'count': count});

  @override
  String historyPinLockedOut(int seconds) => _renderVietnamese('Thử quá nhiều lần. Vui lòng chờ {seconds} giây.', {'seconds': seconds});

  @override
  String settingsHistoryAutoLockMinutes(int minutes) => _renderVietnamese('Sau {minutes} phút', {'minutes': minutes});

  @override
  String settingsSttIdleTimeoutMinutes(int count) => _renderVietnamese('{count, plural, =1{1 phút} other{{count} phút}}', {'count': count});

  @override
  String insufficientRamBody(double detectedGb, int requiredGb) => _renderVietnamese('WhisPaste cần ít nhất {requiredGb} GB RAM để chạy. Máy bạn có {detectedGb} GB. Nếu thiếu bộ nhớ, mô hình AI có thể không tải được hoặc bị thoát đột ngột.', {'detectedGb': detectedGb, 'requiredGb': requiredGb});

  @override
  String hotkeyConflictWarning(String platform, String note) => _renderVietnamese('Phím tắt này đã được {platform} sử dụng ({note}) và có thể không hoạt động.', {'platform': platform, 'note': note});

  @override
  String settingsSearchResultCount(int count) => _renderVietnamese('{count, plural, =0{Không có kết quả} =1{1 kết quả} other{{count} kết quả}}', {'count': count});

  @override
  String notesQuickNoteHotkeyChange(String combination) => _renderVietnamese('Đổi phím tắt ghi chú nhanh — hiện là {combination}', {'combination': combination});

  @override
  String notesNoResultsHint(String query) => _renderVietnamese('Không có ghi chú nào khớp "{query}". Hãy thử từ khóa khác.', {'query': query});

  @override
  String notesResultCount(int count) => _renderVietnamese('{count, plural, =1{1 kết quả} other{{count} kết quả}}', {'count': count});

  @override
  String markdownToolbarBold(String shortcut) => _renderVietnamese('In đậm ({shortcut})', {'shortcut': shortcut});

  @override
  String markdownToolbarItalic(String shortcut) => _renderVietnamese('In nghiêng ({shortcut})', {'shortcut': shortcut});

  @override
  String markdownToolbarBulletList(String shortcut) => _renderVietnamese('Danh sách dấu đầu dòng ({shortcut})', {'shortcut': shortcut});

  @override
  String findReplaceMatchCount(int current, int total) => _renderVietnamese('{current}/{total}', {'current': current, 'total': total});

  @override
  String settingsSmartModeHotkeyCollision(String action) => _renderVietnamese('Tổ hợp này đang được dùng cho "{action}". Hãy chọn tổ hợp khác.', {'action': action});

  @override
  String settingsAutomationApiStatusRunning(int port) => _renderVietnamese('Đang chạy tại cổng {port}', {'port': port});

  @override
  String settingsAutomationApiStatusRunningFallback(int port, int requestedPort,) => _renderVietnamese('Đang chạy tại cổng {port} (cổng {requestedPort} đã được sử dụng)', {'port': port, 'requestedPort': requestedPort});

  @override
  String settingsAutomationApiStatusError(int start, int end) => _renderVietnamese('Không có cổng trống từ {start} đến {end}', {'start': start, 'end': end});

  @override
  String historyCharacterCount(int count) => _renderVietnamese('{count} ký tự', {'count': count});

  @override
  String historyPastedInto(String app) => _renderVietnamese('Đã dán vào {app}', {'app': app});

}
