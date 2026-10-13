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

## Khắc phục lỗi không tìm thấy micro trên Windows

Nếu hiện `Đã cấp quyền micro` nhưng khi ghi âm báo `Windows không tìm thấy
thiết bị ghi âm`, ứng dụng có quyền truy cập nhưng Windows chưa cung cấp
thiết bị đầu vào âm thanh hoạt động. Hãy kiểm tra:

1. Mở **Cài đặt Windows → Hệ thống → Âm thanh → Đầu vào**; kiểm tra có
   micro tích hợp hoặc USB/Bluetooth nào được nhận không.
2. Chọn thiết bị đầu vào đang hoạt động, bật lại thiết bị nếu bị vô hiệu
   hóa, thử nói và quan sát thanh kiểm tra mức âm của Windows.
3. Trong **Quyền riêng tư → Micro**, bật quyền dùng micro cho ứng dụng
   máy tính thông thường (desktop apps).
4. Thử ghi bằng ứng dụng Sound Recorder/Voice Recorder của Windows.
   Nếu Windows cũng không thu được, hãy kiểm tra driver, cáp và phần cứng.
5. Đóng rồi mở lại WhisPaste VN sau khi đổi thiết bị âm thanh.

Bản vá này sẽ ưu tiên thiết bị mặc định; khi Windows báo thiết bị mặc định
không tồn tại, ứng dụng thử lần lượt các thiết bị đầu vào mà hệ điều hành
liệt kê. Nếu không có thiết bị nào, ứng dụng **không thể tự tạo ra micro
bằng phần mềm** và sẽ hiển thị thông báo cụ thể cùng nút mở cài đặt âm thanh.

### Phím ghi âm F8

Bản VN mặc định dùng F8. Bản trước có lỗi mã phím F1–F12 khiến đăng ký
F8 thất bại và tự chuyển sang Ctrl+Shift+Space. Bản vá dùng trực tiếp
`LogicalKeyboardKey.f8` (và các phím F1–F12 tương ứng).

Nếu bạn từng đổi phím thành Ctrl+R thì cài đặt cũ vẫn được giữ nguyên;
hãy đổi lại thành F8 trong Cài đặt → Phím tắt sau khi cài bản vá.

## Hiệu năng nhận diện tiếng nói trên Windows

### Vì sao bản VN ban đầu xử lý chậm?

Bản Windows đầu tiên (workflow ngày 12/10/2026) đã đóng gói whisper.cpp
v1.8.4 với `GGML_VULKAN=OFF`, `GGML_NATIVE=OFF` và
`GGML_OPENMP=OFF`. Bản này chỉ có CPU backend, nên card đồ họa không thể
giúp suy luận Whisper dù phần mềm có tùy chọn tăng tốc GPU.

Một phiên đo thực tế ghi nhận benchmark 3 giây âm thanh mất khoảng
5,49 giây xử lý (RTF ~1,83). Đây là phép đo của mẫu benchmark, không phải
cam kết rằng mọi đoạn ghi âm sẽ chậm ở đúng tỷ lệ đó.

### Đối chiếu log thực tế của cùng một máy, cùng mô hình (13/10/2026)

Log người dùng đã xác nhận cả WhisPaste 1.3.0 nguyên bản (12/10) và
WhisPaste VN CPU-only (13/10) đều sử dụng **whisper-large-v3-turbo**
(`ggml-large-v3-turbo-q5_0.bin`, 547 MB). Vì vậy tốc độ chậm không phải
do chuyển từ model Small sang model Large hay do dịch giao diện:

- Bản nguyên gốc: giải mã một câu 6–10 giây mất khoảng 1,4–2 giây
  (RTF 0,17–0,23), benchmark 3 giây mất 1,79 giây.
- Bản VN CPU-only: khởi động/warmup tốn 73,16 giây; giải mã câu
  7,74 giây mất 50,10 giây (RTF 6,48).
- Sau lần đầu: background benchmark 3 giây chiếm worker 66,1 giây
  (RTF 22,04); lượt đọc mới mất 93,46 giây mới trả kết quả ở native,
  nhưng cửa sổ đã báo timeout sau 62 giây.

**Phát hiện và vá bổ sung:** Nếu bước warmup 250 ms kéo dài quá 15 giây
hoặc thất bại, bỏ qua benchmark **tự động** trên worker Whisper dùng chung;
vẫn giữ chức năng benchmark **thủ công**. Mục tiêu là không để tác vụ kiểm
tra tốc độ chiếm worker hàng phút và cản trở ghi âm thật. Cơ chế này chỉ
giảm nghẽn hàng chờ, không thể khiến DLL CPU-only cũ suy luận nhanh hơn.

### Cấu hình cho lần BUILD tiếp theo

- Cài Vulkan SDK trong GitHub Actions rồi xây whisper.cpp có
  `GGML_VULKAN=ON`, `GGML_BACKEND_DL=ON`: GPU có trình điều khiển
  Vulkan tương thích được sử dụng; không có Vulkan thì vẫn chạy CPU.
- Xây thêm các biến thể CPU (`GGML_CPU_ALL_VARIANTS=ON`) để thư viện có
  thể chọn bộ lệnh phù hợp với CPU, thay vì chỉ dùng cấu hình CPU cơ bản.
- Giữ `GGML_OPENMP=OFF` để không phát sinh phụ thuộc VCOMP140.DLL
  trên máy Windows không có runtime tương ứng.
- Workflow phải kiểm tra `ggml-vulkan.dll`, `whisper.dll` và ít nhất
  một `ggml-cpu*.dll` trước khi đăng artifact, tránh trường hợp một bản
  BUILD "thành công" nhưng thiếu thư viện tăng tốc hoặc dự phòng.
- Log ghi thời gian suy luận, hệ số RTF và nhóm backend CPU/GPU để phân
  biệt nghẽn thư viện native với quá trình chuẩn hóa văn bản.

Hiệu năng thực tế vẫn phụ thuộc CPU/GPU, driver, độ dài tiếng nói và model.
Vulkan không bảo đảm nhanh hơn CPU trên mọi thiết bị. Các thay đổi này
chưa được xác nhận bằng BUILD và benchmark trên máy người dùng.

**Không cần tải lại Whisper Small 181 MB** khi cập nhật EXE: mô hình
được lưu riêng trong thư mục dữ liệu ứng dụng.

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


## Bộ quy tắc đọc văn bản Đảng (13/10/2026)

Bộ quy tắc được rút ra từ 356 trích yếu trong danh mục văn bản người dùng cung cấp, với nguyên tắc **không tự suy đoán số hiệu và cơ quan ban hành**.

| Cách đọc / nhận dạng | Kết quả dự kiến |
| --- | --- |
| Đại hội số 13 | Đại hội số XIII |
| Ban chấp hành Trung ương Đảng khóa 13 | Ban Chấp hành Trung ương Đảng khóa XIII |
| Nghị quyết số 27 NQ Trung ương | Nghị quyết số 27-NQ/TW |
| Kết luận số 61 của Ban Bí thư | Kết luận số 61-KL/TW của Ban Bí thư |
| Hướng dẫn số 02 HD Ban Tổ chức Trung ương | Hướng dẫn số 02-HD/BTCTW |
| Kế hoạch số 210 KH Huyện ủy | Kế hoạch số 210-KH/HU |
| Nhiệm kỳ 2020 đến 2025 | Nhiệm kỳ 2020-2025 |
| Quý 3 năm 2024 | Quý III năm 2024 |

- Các loại ký hiệu hỗ trợ: NQ, KL, CT, QĐ, HD, KH, CTr, TB, TT.
- Cơ quan đọc rõ: Trung ương (TW), Tỉnh ủy (TU), Huyện ủy (HU), Đảng ủy (ĐU), Ban Tổ chức Trung ương (BTCTW), Văn phòng Trung ương (VPTW), Ban Nội chính Tỉnh ủy (BNCTU).
- Trường hợp loại văn bản hoặc cơ quan không rõ thì không đoán hậu tố, ví dụ `Nghị quyết số 27` vẫn là `Nghị quyết số 27`.
- Không chuyển `khóa 13` ở lớp bồi dưỡng thành `khóa XIII`, không chuyển số hiệu văn bản hoặc ngày tháng thành số La Mã.
- Chỉ chuẩn hóa tên tổ chức, tên cơ quan khi nhận rõ từ ngữ; không đổi mọi chữ viết tắt (BCH/BTV/UBKT) thành tên đầy đủ.
- Danh mục có lỗi gõ và ký hiệu mâu thuẫn, vì vậy các mục nguồn không được coi là văn bản quy phạm chuẩn để sửa chính tả hàng loạt.
- Chưa chạy kiểm thử Flutter/Windows và chưa build EXE sau các thay đổi này. Các quy tắc mới sẽ chỉ hoạt động sau khi build và cài bản mới.

## Light Neumorphism UI (bản nhánh thử nghiệm)

Mã nguồn giao diện sáng pastel/lavender được triển khai bằng widget Flutter, không dùng ảnh nền. Tài liệu màu sắc, phạm vi, hướng dẫn kiểm thử: [WHISPASTE_VN_NEUMORPHISM.md](WHISPASTE_VN_NEUMORPHISM.md). Thay đổi chỉ có hiệu lực sau khi build/cài EXE mới; chưa chạy GitHub Actions.
