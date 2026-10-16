# WhisPaste VN Browser Extension · MVP 0.1

Phiên bản **Chromium Manifest V3** cho **Brave và Google Chrome trên máy tính**. Hoạt động độc lập, không làm thay đổi app Flutter Windows.

## Cài đặt

1. Tải/clone branch `feature/whispaste-vn-browser-extension` từ repository.
2. Chrome: mở `chrome://extensions`; Brave: `brave://extensions`.
3. Bật **Developer mode / Chế độ nhà phát triển**.
4. Chọn **Load unpacked / Tải tiện ích đã giải nén**, trỏ tới thư mục `browser-extension`.
5. Ghim WhisPaste VN lên thanh tiện ích, mở trang web có ô nhập, chọn ô rồi bấm biểu tượng WhisPaste.

Chỉ áp dụng cho desktop Chromium. Không cài được extension Chrome lên Brave iPhone.

## Luồng ghi âm

**Chrome:** Chọn `Trình duyệt (khi hỗ trợ)` → `Bắt đầu ghi âm` → nói tiếng Việt → `Dừng`. SpeechRecognition có thể dùng dịch vụ nhận diện ngoài thiết bị tùy browser; không mặc định offline.

**Brave hoặc các bản không có SpeechRecognition:** Chọn `Whisper-compatible API`. Điền một URL endpoint `POST /v1/audio/transcriptions` đầy đủ, tên mô hình và (nếu cần) API key; nhấn **Lưu cấu hình** để cấp quyền đúng máy chủ. Chọn ghi âm, sau đó Dừng; audio được gửi **chỉ tới endpoint bạn cấu hình**. Extension không cung cấp sẵn máy chủ, API key hoặc mô hình chạy offline; endpoint phải trả JSON `{"text":"..."}`, hỗ trợ `multipart/form-data` với `file`, `model`, `language=vi` và CORS/permission tương thích. Một số dịch vụ có yêu cầu định dạng audio hoặc mô hình khác nên cần kiểm thử.

- Endpoint: HTTPS; HTTP chỉ cho localhost/127.0.0.1. Quyền host được xin khi bạn đồng ý, không tự lấy quyền mọi website.
- API key: lưu trong **chrome.storage.session** (chỉ tới khi hết phiên trình duyệt); không lưu trong `storage.local`.
- Chế độ thử: nhập tay câu nhận diện vào ô đầu vào rồi bấm **Chuẩn hóa**; không cần mic/API.

## Kết quả và học từ

- Số hiệu: `số hai mươi chín công văn đảng ủy` → `số 29-CV/ĐU`.
- Đánh vần: `Nghị quyết không ba en quy hát u` → `Nghị quyết 03-NQ/HU`.
- La Mã: `Đại hội số năm 2026` → `Đại hội V 2026`, nhưng `Đại hội năm 2026` giữ nguyên.
- Những mã đã viết như `191/CV/ĐU` giữ nguyên, không sửa hồ sơ lịch sử.
- Sửa trực tiếp **một từ rõ ràng** trong ô kết quả rồi nhấn **Sao chép** hoặc **Chèn**: extension tự học cặp từ đã sửa. Những thay đổi phức tạp phải thêm thủ công ở phần **Từ điển cá nhân**.
- Từ điển lưu trên máy bằng `chrome.storage.local`, **không tự đồng bộ** với phiên bản Windows hoặc giữa Chrome và Brave.

## Chèn văn bản và giới hạn

`Chèn vào ô đang nhập` dùng quyền **activeTab + scripting** tại tab bạn vừa chọn; hỗ trợ input văn bản, textarea và contenteditable cơ bản. Nếu website hạn chế (Google Docs canvas, trang chrome://, brave://, iframe khác nguồn, editor đặc thù), extension chuyển sang **sao chép để bạn tự Ctrl+V**. Không đọc dữ liệu toàn bộ website và không có quyền truy cập mọi tab.

Phiên bản 0.1 **chưa có** mô hình STT offline đóng gói, tổ hợp phím nói trực tiếp trên trang, nhận diện trong iframe, đồng bộ dữ liệu, và chưa được QA giao diện trên Brave/Chrome thật.

## Kiểm thử

Tại thư mục root repository, với Node.js >=20:

```bash
node --test test/browser_extension/normalizer.test.mjs
```

Kiểm thử thuần JS không thay thế việc kiểm tra microphone, host permissions, mạng, popup và nhập liệu trên browser. `normalizer.mjs` là **subset viết bằng JavaScript** của bộ quy tắc Dart: các sửa đổi quy tắc ở Windows cần được bổ sung vào cả hai bộ và có kiểm thử parity tương ứng.

Không cần chạy GitHub Actions cho bản MVP; branch độc lập, không chỉnh code Windows.
