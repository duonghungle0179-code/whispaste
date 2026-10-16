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
        'Đại hội XIII',
      );
      expect(
        normalizeVietnameseAdministrativeText('đại hội số mười ba'),
        'đại hội XIII',
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
        'Đại hội XIII',
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
        normalizeVietnameseAdministrativeText('Đại hội số năm 2026'),
        'Đại hội V 2026',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội số 5 năm 2026'),
        'Đại hội V năm 2026',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội 5 năm 2026'),
        'Đại hội 5 năm 2026',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội năm'),
        'Đại hội năm',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội lần thứ năm'),
        'Đại hội lần thứ V',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội năm 2025'),
        'Đại hội năm 2025',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội năm hai nghìn hai mươi sáu'),
        'Đại hội năm hai nghìn hai mươi sáu',
      );
      expect(
        normalizeVietnameseAdministrativeText('Đại hội lần thứ năm'),
        'Đại hội lần thứ V',
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

    test('spoken Party document codes from archival samples', () {
      final examples = <String, String>{
        'Nghị quyết không ba nghị quyết huyện ủy': 'Nghị quyết 03-NQ/HU',
        'Nghị quyết số không tám nghị quyết huyện ủy':
            'Nghị quyết số 08-NQ/HU',
        'Chỉ thị không năm chỉ thị trung ương': 'Chỉ thị 05-CT/TW',
        'Kế hoạch bốn mươi tám kế hoạch đảng ủy':
            'Kế hoạch 48-KH/ĐU',
        'Báo cáo sơ kết năm năm thực hiện nghị quyết không ba nghị quyết huyện ủy của Huyện ủy':
            'Báo cáo sơ kết năm năm thực hiện nghị quyết 03-NQ/HU của Huyện ủy',
      };
      for (final entry in examples.entries) {
        expect(normalizeVietnameseAdministrativeText(entry.key),
            entry.value);
      }
    });

    test('spoken codes are guarded against ambiguity', () {
      const cases = <String, String>{
        'Nghị quyết không ba của huyện ủy':
            'Nghị quyết không ba của Huyện ủy',
        'Nghị quyết không ba nghị quyết của huyện':
            'Nghị quyết không ba nghị quyết của huyện',
        'Nghị quyết không ba chỉ thị huyện ủy':
            'Nghị quyết không ba chỉ thị Huyện ủy',
        'Nghị quyết không ba, nghị quyết huyện ủy':
            'Nghị quyết không ba, nghị quyết Huyện ủy',
        'Hôm nay không ba người đến hội nghị':
            'Hôm nay không ba người đến hội nghị',
        'Nghị quyết 03-NQ/HU': 'Nghị quyết 03-NQ/HU',
      };
      for (final example in cases.entries) {
        final result = normalizeVietnameseAdministrativeText(example.key);
        expect(result, example.value, reason: example.key);
        expect(normalizeVietnameseAdministrativeText(result), result);
      }
      const sample = 'Nghị quyết không ba nghị quyết huyện ủy';
      final once = normalizeVietnameseAdministrativeText(sample);
      expect(normalizeVietnameseAdministrativeText(once), once);
    });

    test('guarded code recovery for Whisper mistakes observed in logs', () {
      const cases = <String, String>{
        'Số 41. Người huyết Đảng ủy.': 'Số 41-NQ/ĐU.',
        'Số 41 Lý Quyết Đảng ủy': 'Số 41-NQ/ĐU',
        'Số bốn mươi mốt nghị huyết huyện ủy':
            'Số 41-NQ/HU',
        'Số 41, người huyết tỉnh ủy': 'Số 41-NQ/TU',
      };
      for (final entry in cases.entries) {
        final once = normalizeVietnameseAdministrativeText(entry.key);
        expect(once, entry.value, reason: entry.key);
        expect(normalizeVietnameseAdministrativeText(once), once);
      }
      const unsafe = <String>[
        'Người huyết Đảng ủy',
        'Số 41 người huyết đã hủy',
        'Số 41 / người huyết Đảng ủy',
        'Số 41.\nNgười huyết Đảng ủy',
        'Số 41. Người huyết của ai',
        'Bốn mươi mốt người huyết Đảng ủy',
      ];
      for (final input in unsafe) {
        final result = normalizeVietnameseAdministrativeText(input);
        expect(result.contains('-NQ/'), isFalse, reason: input);
      }
    });

    test('2026 Party archive abbreviation catalog from source documents', () {
      const examples = <String, String>{
        'Nghị quyết không ba nghị quyết huyện ủy':
            'Nghị quyết 03-NQ/HU',
        'Quy chế không chín quy chế trung ương':
            'Quy chế 09-QC/TW',
        'Báo cáo không một báo cáo đại hội':
            'Báo cáo 01-BC/ĐH',
        'Biên bản hai mươi biên bản đại hội':
            'Biên bản 20-BB/ĐH',
        'Công văn một trăm ba mươi tám công văn ban tuyên giáo và dân vận tỉnh ủy':
            'Công văn 138-CV/BTGDVTU',
        'Tờ trình ba mươi tám tờ trình ban tổ chức trung ương':
            'Tờ trình 38-TTr/BTCTW',
        'Đề án không hai đề án huyện ủy':
            'Đề án 02-ĐA/HU',
        'Quyết định hai mươi ba quyết định ủy ban kiểm tra trung ương':
            'Quyết định 23-QĐ/UBKTTW',
        'Quy định hai mươi ba quy định ủy ban kiểm tra trung ương':
            'Quy định 23-QĐ/UBKTTW',
        'Chương trình ba mươi mốt chương trình trung ương':
            'Chương trình 31-CTr/TW',
        'Thông tri không ba thông tri trung ương':
            'Thông tri 03-TT/TW',
        'Thông báo một trăm ba mươi tư thông báo văn phòng trung ương':
            'Thông báo 134-TB/VPTW',
        'Kế hoạch một trăm mười lăm kế hoạch văn phòng trung ương':
            'Kế hoạch 115-KH/VPTW',
        'Chỉ thị không bảy chỉ thị trung ương':
            'Chỉ thị 07-CT/TW',
        'Kết luận năm mươi bảy kết luận trung ương':
            'Kết luận 57-KL/TW',
        'Hướng dẫn không sáu hướng dẫn ban tổ chức trung ương':
            'Hướng dẫn 06-HD/BTCTW',
        'Kế hoạch mười bảy kế hoạch văn phòng huyện ủy':
            'Kế hoạch 17-KH/VPHU',
        'Công văn hai trăm năm mươi bảy công văn đảng ủy công an huyện':
            'Công văn 257-CV/ĐUCAH',
        'Kế hoạch một trăm bốn mươi lăm kế hoạch ban tuyên giáo và dân vận trung ương':
            'Kế hoạch 145-KH/BTGDVTW',
      };
      for (final item in examples.entries) {
        expect(normalizeVietnameseAdministrativeText(item.key), item.value);
        expect(
          normalizeVietnameseAdministrativeText(
            normalizeVietnameseAdministrativeText(item.key),
          ),
          item.value,
        );
      }
    });

    test('ambiguous codes are never invented from prose', () {
      const untouched = <String>[
        'Quyết định không ba quy định huyện ủy',
        'Quyết định số không ba quy định huyện ủy',
        'Quy định số không ba quyết định huyện ủy',
        'Quy định không ba quyết định huyện ủy',
        'Hôm nay báo cáo ba công việc với huyện ủy',
        'Đề án không hai đề án của huyện',
        'Báo cáo ba, báo cáo huyện ủy',
        'Công văn của Ban Tuyên giáo và Dân vận Tỉnh ủy',
      ];
      for (final sample in untouched) {
        final once = normalizeVietnameseAdministrativeText(sample);
        expect(once.contains('-QĐ/HU') || once.contains('-BC/HU') ||
            once.contains('-ĐA/HU') || once.contains('-CV/BTGDVTU'), isFalse);
      }
      expect(
        normalizeVietnameseAdministrativeText('Số 23-QĐ/UBKTTW'),
        'Số 23-QĐ/UBKTTW',
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
