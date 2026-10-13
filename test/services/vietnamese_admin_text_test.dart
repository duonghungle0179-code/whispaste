import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/services/vietnamese_admin_text.dart';

void main() {
  group('Vietnamese administrative dictation', () {
    test('converts the core document number and natural spoken date', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Số sáu mươi mốt, kết luận Trung ương, '
          'ngày ba tháng mười hai năm hai nghìn lẻ chín.',
        ),
        'Số 61-KL/TW, ngày 3/12/2009.',
      );
    });

    test('resolves number and agency to a full administrative code', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Số một trăm bốn mươi tám quyết định Ủy ban nhân dân',
        ),
        'Số 148/QĐ-UBND',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Số ba mươi lăm nghị quyết Trung ương',
        ),
        'Số 35-NQ/TW',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Số năm mươi hướng dẫn văn phòng Trung ương',
        ),
        'Số 50-HD/VPTW',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Số bảy mươi hai kế hoạch Ủy ban nhân dân',
        ),
        'Số 72/KH-UBND',
      );
    });

    test('handles numeric dates and calendar checks', () {
      expect(
        normalizeVietnameseAdministrativeText('ngày 3 tháng 12 năm 2009'),
        'ngày 3/12/2009',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Ngày mùng năm tháng năm năm hai nghìn không trăm hai mươi sáu',
        ),
        'Ngày mùng 5/5/2026',
      );
      expect(
        normalizeVietnameseAdministrativeText('ngày 29 tháng 2 năm 2024'),
        'ngày 29/2/2024',
      );
      expect(
        normalizeVietnameseAdministrativeText('ngày 31 tháng 2 năm 2026'),
        'ngày 31 tháng 2 năm 2026',
      );
    });

    test('preserves leading zero in explicitly spelled-out document number', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Số không tám kết luận Trung ương',
        ),
        'Số 08-KL/TW',
      );
    });

    test('supports digit by digit spoken years', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'ngày ba tháng mười hai năm hai không hai sáu',
        ),
        'ngày 3/12/2026',
      );
    });

    test('does not fabricate document symbols or issuing bodies', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Số sáu mươi mốt kết luận huyện',
        ),
        'Số 61 kết luận huyện',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'kết luận Trung ương số sáu mươi mốt',
        ),
        'kết luận Trung ương số 61',
      );
    });

    test('keeps unrelated spoken prose unchanged', () {
      const prose = 'Hôm nay tôi mua sáu mươi mốt cuốn sách ở cơ quan.';
      expect(normalizeVietnameseAdministrativeText(prose), prose);
      const unknown = 'Công văn huyện về việc phân công nhiệm vụ.';
      expect(normalizeVietnameseAdministrativeText(unknown), unknown);
    });

    test('renders congress numbers as Roman ordinals, including spoken numbers', () {
      expect(
        normalizeVietnameseAdministrativeText('Đại hội số 13'),
        'Đại hội số XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText('đại hội số mười ba'),
        'đại hội số XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội lần thứ 13'),
        'Đại hội lần thứ XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Đại hội đại biểu toàn quốc lần thứ mười ba',
        ),
        'Đại hội đại biểu toàn quốc lần thứ XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Đại hội Đảng bộ tỉnh Gia Lai lần thứ 21',
        ),
        'Đại hội Đảng bộ tỉnh Gia Lai lần thứ XXI',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội XIII'),
        'Đại hội XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          normalizeVietnameseAdministrativeText('Đại hội số 13'),
        ),
        'Đại hội số XIII',
      );
    });

    test('does not turn ordinary numbers or administrative codes into Roman', () {
      expect(
        normalizeVietnameseAdministrativeText('Số 13 kết luận Trung ương'),
        'Số 13-KL/TW',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội có 13 đại biểu'),
        'Đại hội có 13 đại biểu',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội 13 người'),
        'Đại hội 13 người',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội năm 2026'),
        'Đại hội năm 2026',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội số 13-KL/TW'),
        'Đại hội số 13-KL/TW',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Đại hội lần thứ 13, ngày 13 tháng 10 năm 2026',
        ),
        'Đại hội lần thứ XIII, ngày 13/10/2026',
      );
    });

    test('Party document codes require both type and issuing body', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Nghị quyết số 27 NQ Trung ương',
        ),
        'Nghị quyết số 27-NQ/TW',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Kết luận số 61 của Ban Bí thư',
        ),
        'Kết luận số 61-KL/TW của Ban Bí thư',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Hướng dẫn số 02 HD Ban Tổ chức Trung ương',
        ),
        'Hướng dẫn số 02-HD/BTCTW',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Kế hoạch số 210 KH Huyện ủy',
        ),
        'Kế hoạch số 210-KH/HU',
      );
      expect(
        normalizeVietnameseAdministrativeText('Nghị quyết số 27'),
        'Nghị quyết số 27',
      );
      expect(
        normalizeVietnameseAdministrativeText('Kế hoạch số 210'),
        'Kế hoạch số 210',
      );
    });

    test('party congress session and year range normalization', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Ban chấp hành Trung ương Đảng khóa 13, nhiệm kỳ 2020 đến 2025',
        ),
        'Ban Chấp hành Trung ương Đảng khóa XIII, nhiệm kỳ 2020-2025',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Nghị quyết đại hội Đảng bộ xã khóa mười',
        ),
        'Nghị quyết đại hội Đảng bộ xã khóa X',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'lớp bồi dưỡng đảng viên mới khóa 13',
        ),
        'lớp bồi dưỡng đảng viên mới khóa 13',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'nhiệm kỳ 2025 đến 2030, giai đoạn 2026 tới 2031',
        ),
        'nhiệm kỳ 2025-2030, giai đoạn 2026-2031',
      );
      expect(
        normalizeVietnameseAdministrativeText('quý 3 năm 2024'),
        'quý III năm 2024',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Số 13 kết luận Trung ương, ngày 13 tháng 10 năm 2026',
        ),
        'Số 13-KL/TW, ngày 13/10/2026',
      );
    });

    test('proper Party bodies are cased, ordinary prose preserved', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'ban thường vụ tỉnh ủy họp với ủy ban kiểm tra',
        ),
        'Ban Thường vụ Tỉnh ủy họp với Ủy ban Kiểm tra',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'bch đảng bộ xã làm việc với btv huyện ủy',
        ),
        'BCH Đảng bộ xã làm việc với BTV Huyện ủy',
      );
      expect(
        normalizeVietnameseAdministrativeText(
          'Hôm nay 13 đại biểu tham dự hội nghị',
        ),
        'Hôm nay 13 đại biểu tham dự hội nghị',
      );
    });

    test('already formatted identifiers stay unchanged on repeated passes', () {
      const formatted = 'Số 61-KL/TW, ngày 3/12/2009';
      expect(normalizeVietnameseAdministrativeText(formatted), formatted);
      expect(
        normalizeVietnameseAdministrativeText(
          normalizeVietnameseAdministrativeText(formatted),
        ),
        formatted,
      );
    });

    test('normalizes multiple references without dropping surrounding text', () {
      expect(
        normalizeVietnameseAdministrativeText(
          'Căn cứ số ba mươi lăm nghị quyết Trung ương và '
          'số một trăm bốn mươi tám quyết định Ủy ban nhân dân.',
        ),
        'Căn cứ số 35-NQ/TW và số 148/QĐ-UBND.',
      );
    });
  });
}
