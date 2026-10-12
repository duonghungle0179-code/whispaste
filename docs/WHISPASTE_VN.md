# WhisPaste VN — nhập mục lục văn bản bằng giọng nói

Bản tùy biến từ WhisPaste mã nguồn mở, tập trung vào nhận diện tiếng Việt
offline và chuyển lời đọc thành số, ký hiệu, ngày tháng văn bản hành chính.

## Giao diện tiếng Việt

- Đã dịch đầy đủ **1.280 chuỗi** trong bộ ngôn ngữ của WhisPaste,
  bao gồm Cài đặt, Lịch sử, Ghi âm, thông báo lỗi, thiết lập ban đầu,
  mẫu văn bản, chú thích và các màn hình phụ.
- Tiếng Việt là ngôn ngữ giao diện cố định của bản VN; giữ nguyên
  khi cập nhật từ bản cài đã lưu lựa chọn tiếng Anh.
- Các cửa sổ phụ (lớp phủ ghi âm, nút nổi, thanh bên) cũng dùng tiếng Việt.
- Thanh điều hướng và tìm kiếm Cài đặt có nhãn tiếng Việt; tìm kiếm
  hỗ trợ từ tiếng Việt không dấu.
- Bản dịch nằm tại lib/core/l10n/app_vi.arb. Thư mục generated chứa
  bản mã tạo sẵn; lệnh flutter gen-l10n sẽ làm mới từ tệp ARB này.

## Cách dùng trên Windows

1. Mở ứng dụng mới sau khi BUILD và cài đặt.
2. Tải mô hình Whisper Small khi sử dụng lần đầu (cần Internet).
3. Bật chế độ **Tự dán tại con trỏ** trong Cài đặt nếu muốn nhập thẳng
   vào Google Sheets.
4. Chọn ô trong Google Sheets, nhấn F8 để ghi âm, nhấn F8 lần nữa để dừng.
5. Đối chiếu số hiệu, ký hiệu và ngày tháng trước khi lưu chính thức.

Ví dụ bạn đọc:

> Số sáu mươi mốt kết luận Trung ương, ngày ba tháng mười hai năm hai nghìn lẻ chín.

Kết quả mong muốn:

> Số 61-KL/TW, ngày 3/12/2009.

## Quy tắc xử lý an toàn

- Chỉ thêm hậu tố khi nhận diện rõ loại văn bản và cơ quan đã có trong từ điển.
- Không tự suy đoán hậu tố với đơn vị chưa rõ.
- Ngày không tồn tại (31/2) được để nguyên.
- Giữ bản nhận diện gốc trong lịch sử để đối chiếu.
- Có thể cần đặt cột Google Sheets là **Văn bản thuần túy** để không
  bị Sheets tự đổi kiểu dữ liệu.

## Các thành phần mã nguồn

- Chuẩn hóa hành chính: lib/services/vietnamese_admin_text.dart
- Luồng ghi âm → nhận diện → dán: lib/services/recording_orchestrator.dart
- Giao diện nhận diện tiếng Việt: lib/features/settings/sections/vietnamese_stt_section.dart
- Dịch UI: lib/core/l10n/app_vi.arb
- Kiểm thử dịch UI: test/core/l10n/vietnamese_locale_test.dart
- Kiểm thử chuẩn hóa văn bản: test/services/vietnamese_admin_text_test.dart

## Trạng thái kỹ thuật

Mã nguồn đã được cập nhật trên fork. Chưa chạy Flutter Analyzer, kiểm thử
Flutter hay đóng gói EXE mới vì môi trường thao tác hiện tại không có Flutter SDK
và bạn đã yêu cầu không dùng GitHub Actions khi chỉ cập nhật mã nguồn.

Giao diện của bản WhisPaste đã cài trên máy sẽ KHÔNG thay đổi cho tới khi
build và cài bản tùy biến mới.

Các workflow trong fork chỉ chạy thủ công theo yêu cầu của bạn.
