# WhisPaste VN: quy tắc đọc số La Mã và ký hiệu văn bản (16/10/2026)

Đây là **bộ quy tắc hậu xử lý giọng nói** và bộ mẫu kiểm thử, KHÔNG phải quá trình huấn luyện lại trọng số Whisper/Parakeet. Pipeline hiện sử dụng `normalizeVietnameseAdministrativeText()` tại `lib/services/recording_orchestrator.dart` trước khi lưu lịch sử và dán văn bản.

## Căn cứ và nguồn dữ liệu

1. Hướng dẫn số 05-HD/VPTW (27/5/2026), mục 3.1.2 về mã loại văn bản và cơ quan:
   https://tulieuvankien.dangcongsan.vn/van-ban-cua-dang/huong-dan-so-05-hd-vptw-ngay-27-5-2026-cua-van-phong-trung-uong-dang-ve-the-thuc-va-ky-thuat-trinh-bay-van-ban-cua-dang.html
2. Quy định 399-QĐ/TW (9/1/2026) về thể loại, thẩm quyền và thể thức:
   https://tulieuvankien.dangcongsan.vn/he-thong-van-ban/van-ban-cua-dang/quy-dinh-so-399-qd-tw-ngay-09-01-2026-cua-ban-bi-thu-ve-the-loai-tham-quyen-ban-hanh-va-the-thuc-van-ban-cua-dang.html
3. Hướng dẫn 36-HD/VPTW năm 2018 (tham khảo bối cảnh mã lịch sử, ví dụ **Quy định: QĐi** thời kỳ cũ):
   https://thuvienphapluat.vn/van-ban/Bo-may-hanh-chinh/Huong-dan-36-HD-VPTW-2018-huong-dan-the-thuc-va-ky-thuat-trinh-bay-van-ban-cua-Dang-380096.aspx
4. Người dùng cung cấp bảng 517 dòng số/ký hiệu (16/10/2026). Có 365 dòng dạng `số/loại/cơ quan`, 151 dòng dạng `số-loại/cơ quan`, 1 dòng khác; có mã lặp. Đây là **định dạng ghi thực tế trong hồ sơ**, không chứng nhận tất cả đều đúng thể thức hiện hành.

**Tuyệt đối không tự sửa ký hiệu trên hồ sơ lịch sử đã nhập**, ví dụ `191/CV/ĐU`, `5/NQ-ĐU`, `78/QĐ/ĐU`, `11-QĐi/TW`. Khi tạo mã MỚI qua giọng đọc, dùng mặc định `29-CV/ĐU` theo cách đọc rõ loại và cơ quan.

## Cách đọc số và chuyển thành mã

| Giọng đọc | Đầu ra |
| --- | --- |
| hai mươi chín công văn đảng ủy | 29-CV/ĐU |
| số hai mươi chín công văn đảng ủy | số 29-CV/ĐU |
| công văn số hai mươi chín công văn đảng ủy | công văn số 29-CV/ĐU |
| số hai chín công văn đảng ủy | số 29-CV/ĐU |
| hai mươi chín cê vê đê u | 29-CV/ĐU |
| nghị quyết không ba en quy hát u | nghị quyết 03-NQ/HU |
| tờ trình không bốn tờ trình đảng ủy | tờ trình 04-TTr/ĐU |
| báo cáo không hai báo cáo đảng ủy | báo cáo 02-BC/ĐU |
| quyết định không bốn quyết định ủy ban kiểm tra đảng ủy | quyết định 04-QĐ/UBKTĐU |
| kế hoạch không một kế hoạch ủy ban kiểm tra | kế hoạch 01-KH/UBKT |
| biên bản một biên bản chi bộ | biên bản 1-BB/CB |

- Đọc `không ba` trước ký hiệu: giữ `03`.
- Đọc từng chữ số `hai chín` trong ngữ cảnh mã: `29`, không cộng thành 11.
- Không đoán một số hiệu không được đọc.
- Nếu đầu vào đã có ký hiệu, không cưỡng bức sửa thành định dạng mới.
- Nếu đầu vào chỉ là `29 công văn đảng ủy cần xử lý`, đây có thể là số lượng tài liệu, nên **không tự biến thành mã**.
- Không tự thay toàn bộ `công văn`, `đảng ủy` trong văn bản thường bằng `CV`, `ĐU`.

## Mã loại văn bản đã hỗ trợ

| Đọc | Mã | Đọc | Mã |
| --- | --- | --- | --- |
| nghị quyết | NQ | kết luận | KL |
| chỉ thị | CT | quyết định | QĐ |
| quy định | QĐ | quy chế | QC |
| công văn | CV | báo cáo | BC |
| biên bản | BB | thông báo | TB |
| tờ trình | TTr | thông tri | TT |
| kế hoạch | KH | chương trình | CTr |
| hướng dẫn | HD | đề án | ĐA |

`ĐA` được hỗ trợ theo ví dụ biên mục, không mặc nhiên xác nhận số hiệu văn bản cụ thể.

## Cơ quan và tổ chức thường gặp trong ký hiệu

| Đọc | Mã |
| --- | --- |
| Đảng ủy | ĐU |
| Huyện ủy (hồ sơ lịch sử) | HU |
| Tỉnh ủy | TU |
| Trung ương / Bộ Chính trị / Ban Bí thư | TW |
| Chi bộ | CB |
| Đại hội | ĐH |
| Ủy ban Kiểm tra | UBKT |
| Ủy ban Kiểm tra Đảng ủy (theo hồ sơ mẫu) | UBKTĐU |
| Ủy ban Kiểm tra Trung ương | UBKTTW |
| Cơ quan Ủy ban Kiểm tra | CQUBKT |
| Ban Chỉ đạo | BCĐ |
| Tiểu ban | TB |
| Hội đồng | HĐ |
| Văn phòng Trung ương | VPTW |
| Văn phòng Tỉnh ủy | VPTU |
| Văn phòng Huyện ủy (mẫu lịch sử) | VPHU |
| Ban Tổ chức Trung ương | BTCTW |
| Ban Tổ chức Tỉnh ủy | BTCTU |
| Ban Tổ chức Huyện ủy (mẫu lịch sử) | BTCHU |
| Ban Tuyên giáo và Dân vận Trung ương | BTGDVTW |
| Ban Tuyên giáo và Dân vận Tỉnh ủy | BTGDVTU |
| Ban Xây dựng Đảng | BXDĐ |
| Đảng ủy Quân sự | ĐUQS |
| Quân ủy Trung ương | QUTW |
| Đảng ủy Công an | ĐUCA |
| Đảng ủy Công an huyện (mẫu lịch sử) | ĐUCAH |
| Đảng ủy Biên phòng | ĐUBP |

**Ưu tiên cơ quan dài và cụ thể nhất**: `đảng ủy công an huyện` -> `ĐUCAH`, không được khớp tiền tố `đảng ủy công an` -> `ĐUCA`. Với tên cơ quan có thể thay đổi theo thời kỳ, ưu tiên ký hiệu trên văn bản gốc nếu cần tính pháp lý.

## Đọc chữ cái thành ký hiệu

| Đọc theo âm | Mã | Chỉ có hiệu lực trong cấu trúc mã |
| --- | --- | --- |
| en quy / nờ quy | NQ | Có |
| cê vê / xê vê | CV | Có |
| bê cê / bê xê | BC | Có |
| bê bê | BB | Có |
| quy đê | QĐ | Có |
| hát đê | HD | Có |
| tê bê | TB | Có |
| hát u | HU | Có |
| đê u | ĐU | Có |
| tê u | TU | Có |
| tê vê kép | TW | Có |

## Quy tắc số La Mã

| Cách đọc | Kết quả |
| --- | --- |
| Đại hội số năm 2026 | Đại hội V 2026 |
| Đại hội năm 2026 | Đại hội năm 2026 |
| Đại hội số mười ba | Đại hội XIII |
| Đại hội lần thứ năm | Đại hội lần thứ V |
| Ban Chấp hành Trung ương Đảng khóa mười ba | Ban Chấp hành Trung ương Đảng khóa XIII |
| Quốc hội khóa mười lăm | Quốc hội khóa XV |
| Hội đồng nhân dân tỉnh khóa mười bốn | Hội đồng nhân dân tỉnh khóa XIV |
| quý bốn năm 2026 | quý IV năm 2026 |

- **Đại hội**: chỉ chuyển khi có `số`, `lần`, `thứ` hoặc `lần thứ` đi kèm đúng ngữ cảnh; không chuyển mọi số đứng sau `Đại hội`.
- **Năm**: `Đại hội năm 2026` không phải `Đại hội V 2026`.
- **Khóa**: La Mã khi thuộc Đại hội, cơ quan Đảng hoặc cơ quan dân cử; không chuyển số khóa học, lớp đào tạo.
- **Quý**: I, II, III, IV.
- **Mốc năm, ngày tháng, số hiệu văn bản, số lượng người và chữ số trong tên sự kiện**: không tự chuyển thành La Mã.
- Có giới hạn phòng ngừa: số kỳ/khóa chỉ từ I đến XXX; quý I–IV. Đây là **quy tắc an toàn hiện tại của ứng dụng**, không phải giới hạn pháp lý.

## Bộ kiểm thử

- `test/services/vietnamese_admin_text_test.dart`: các kiểm thử hồi quy trước đó.
- `test/services/vietnamese_archive_dictation_training_test.dart`: **180 phép kết hợp loại văn bản × cơ quan** (15 × 12), 29 câu biên mục đọc bằng lời, 11 kiểu đánh vần mã, 17 ca La Mã, các tình huống giữ nguyên mã lịch sử và số lượng tài liệu.
- Mỗi ví dụ mã thông thường được kiểm tra thêm tính **idempotent** (chạy quy tắc lần hai không làm biến dạng đầu ra).
- Các mẫu này là dữ liệu thử quy tắc hậu xử lý, không phải bộ huấn luyện mô hình ASR.
- GitHub Actions vẫn thủ công; chỉ công bố “tests passed” sau khi chạy CI / Flutter test thực tế.

### Lưu ý về mã còn mơ hồ trong nguồn người dùng

`01-PH/ĐU`, `01-CN/ĐU`, `Ctr/KDV` và `01/BCĐ` chưa có đủ thông tin để xác quyết loại văn bản và cơ quan khi phát âm. Chúng **được giữ nguyên**, không tự bịa cách đọc hay biến thành quy tắc phổ quát.
