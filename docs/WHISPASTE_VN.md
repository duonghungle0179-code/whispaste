# WhisPaste VN - Nhap muc luc van ban bang giong noi

Ban fork tuy bien tu WhisPaste, tap trung nhan dien tieng Viet offline va
chuan hoa so, ky hieu van ban hanh chinh truoc khi dan vao Google Sheets.

## Su dung

1. Mo phan mem, tai model Whisper Small trong Cai dat neu chua co.
2. Nhan F8 de ghi am, doc, nhan F8 lan nua de ket thuc.
3. Whisper nhan dien voi ma ngon ngu vi.
4. Bo chuan hoa chay offline, khong can API key.
5. Chon che do dan chu vao ung dung dang mo trong Cai dat neu can.
6. Luon doi chieu so hieu va ngay thang voi van ban goc.

## Mau cau

| Cach doc | Ket qua |
| --- | --- |
| So sau muoi mot ket luan Trung uong | 61-KL/TW |
| So ba muoi lam nghi quyet Trung uong | 35-NQ/TW |
| So mot tram bon muoi tam quyet dinh Uy ban nhan dan | 148/QD-UBND |
| So khong tam ket luan Trung uong | 08-KL/TW |
| Ngay ba thang muoi hai nam hai nghin le chin | 3/12/2009 |

Mau doc bang tieng Viet co dau (goi y):

> So sau muoi mot ket luan Trung uong, ngay ba thang muoi hai nam hai nghin le chin.

Gia tri du kien (co dau): So 61-KL/TW, ngay 3/12/2009.

## Nguyen tac an toan

- Chi gan hau to neu biet ro LOAI VAN BAN + CO QUAN ban hanh.
- Neu khong xac dinh duoc co quan, chi doi so viet bang chu thanh chu so;
  khong tu doan ky hieu.
- Ngay khong hop le (31/2) khong duoc tu chuyen.
- Van ban ngoai ngu canh "so ...", "ngay ... thang ... nam ..." duoc giu nguyen.
- Loi nhan dien ten co quan cua Whisper khong duoc tu dong sua.
- Lich su giu ban loi doc goc de doi chieu.
- De Google Sheets giu nguyen chuoi ky hieu, dung cot dinh dang Plain text.

## Noi sua doi

- Bo chuan hoa: lib/services/vietnamese_admin_text.dart
- Luong nhan dien va dan: lib/services/recording_orchestrator.dart
- Giao dien cai dat gon: lib/features/settings/sections/vietnamese_stt_section.dart
- Kiem thu: test/services/vietnamese_admin_text_test.dart

## Trang thai

- Da tao ma nguon va bo kiem thu; chua chay Flutter/Dart tests vi moi truong
  khong co SDK tuong thich.
- Chua kiem tra microphone/Google Sheets tren Windows that.
- Chua dong goi EXE; cho lenh BUILD rieng.
- Tat ca workflow tren fork chi cho phep khoi chay thu cong.
