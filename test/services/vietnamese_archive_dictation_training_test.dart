import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/services/vietnamese_admin_text.dart';

void main() {
  group('Vietnamese archive dictation from user catalog', () {
    test('natural spoken forms become requested numbered Party symbols', () {
      const examples = <String, String>{
        'hai mươi chín công văn đảng ủy': '29-CV/ĐU',
        '29 công văn đảng ủy': '29-CV/ĐU',
        'số hai mươi chín công văn đảng ủy': 'số 29-CV/ĐU',
        'số hai chín công văn đảng ủy': 'số 29-CV/ĐU',
        'ký hiệu hai mươi chín công văn đảng ủy':
            'ký hiệu 29-CV/ĐU',
        'Công văn số hai mươi chín công văn đảng ủy':
            'Công văn số 29-CV/ĐU',
        'báo cáo không hai báo cáo đảng ủy':
            'báo cáo 02-BC/ĐU',
        'quyết định bảy mươi tám quyết định đảng ủy':
            'quyết định 78-QĐ/ĐU',
        'biên bản một biên bản đảng ủy': 'biên bản 1-BB/ĐU',
        'nghị quyết sáu mươi lăm nghị quyết đảng ủy':
            'nghị quyết 65-NQ/ĐU',
        'tờ trình không bốn tờ trình đảng ủy':
            'tờ trình 04-TTr/ĐU',
        'hướng dẫn không một hướng dẫn đảng ủy':
            'hướng dẫn 01-HD/ĐU',
        'quyết định không bốn quyết định ủy ban kiểm tra đảng ủy':
            'quyết định 04-QĐ/UBKTĐU',
        'thông báo hai mươi hai thông báo ủy ban kiểm tra đảng ủy':
            'thông báo 22-TB/UBKTĐU',
        'kế hoạch không một kế hoạch ủy ban kiểm tra':
            'kế hoạch 01-KH/UBKT',
        'quyết định một quyết định chi bộ': 'quyết định 1-QĐ/CB',
        'thông báo không sáu thông báo đảng ủy':
            'thông báo 06-TB/ĐU',
        'công văn không một công văn tiểu ban':
            'công văn 01-CV/TB',
        'báo cáo không một báo cáo đại hội': 'báo cáo 01-BC/ĐH',
        'biên bản hai mươi biên bản đại hội':
            'biên bản 20-BB/ĐH',
        'chỉ thị không sáu chỉ thị tỉnh ủy':
            'chỉ thị 06-CT/TU',
        'quy định hai mươi ba quy định ủy ban kiểm tra trung ương':
            'quy định 23-QĐ/UBKTTW',
        'công văn một trăm ba mươi tám công văn ban tuyên giáo và dân vận tỉnh ủy':
            'công văn 138-CV/BTGDVTU',
        'quy chế không năm quy chế ban tổ chức tỉnh ủy':
            'quy chế 05-QC/BTCTU',
        'quyết định không chín quyết định đảng ủy công an huyện':
            'quyết định 09-QĐ/ĐUCAH',
        'thông báo mười hai thông báo ban chỉ đạo':
            'thông báo 12-TB/BCĐ',
        'quyết định mười hai quyết định quân ủy trung ương':
            'quyết định 12-QĐ/QUTW',
        'chỉ thị không hai chỉ thị đảng ủy biên phòng':
            'chỉ thị 02-CT/ĐUBP',
        'số ba mươi lăm nghị quyết trung ương': 'số 35-NQ/TW',
      };
      for (final example in examples.entries) {
        final actual = normalizeVietnameseAdministrativeText(example.key);
        expect(actual, example.value, reason: example.key);
        expect(normalizeVietnameseAdministrativeText(actual), actual);
      }
    });

    test('letter-by-letter Vietnamese pronunciations form document symbols', () {
      const examples = <String, String>{
        'Nghị quyết không ba en quy hát u': 'Nghị quyết 03-NQ/HU',
        'nghị quyết không ba nờ quy hát u':
            'nghị quyết 03-NQ/HU',
        'hai mươi chín cê vê đê u': '29-CV/ĐU',
        'số hai mươi chín cê vê đê u': 'số 29-CV/ĐU',
        'số hai chín xê vê đê u': 'số 29-CV/ĐU',
        'quy định hai mươi ba quy đê tê u':
            'quy định 23-QĐ/TU',
        'quyết định hai mươi ba quy đê đê u':
            'quyết định 23-QĐ/ĐU',
        'báo cáo không một bê xê hát u':
            'báo cáo 01-BC/HU',
        'biên bản không hai bê bê đê u':
            'biên bản 02-BB/ĐU',
        'hướng dẫn không một hát đê đê u':
            'hướng dẫn 01-HD/ĐU',
        'thông báo không ba tê bê hát u':
            'thông báo 03-TB/HU',
      };
      for (final example in examples.entries) {
        final result = normalizeVietnameseAdministrativeText(example.key);
        expect(result, example.value, reason: example.key);
        expect(normalizeVietnameseAdministrativeText(result), result);
      }
    });

    test('type and agency vocabulary works combinatorially', () {
      const types = <String, String>{
        'nghị quyết': 'NQ',
        'quyết định': 'QĐ',
        'quy định': 'QĐ',
        'chỉ thị': 'CT',
        'kết luận': 'KL',
        'quy chế': 'QC',
        'báo cáo': 'BC',
        'biên bản': 'BB',
        'công văn': 'CV',
        'tờ trình': 'TTr',
        'kế hoạch': 'KH',
        'hướng dẫn': 'HD',
        'chương trình': 'CTr',
        'thông báo': 'TB',
        'thông tri': 'TT',
      };
      const agencies = <String, String>{
        'đảng ủy': 'ĐU',
        'huyện ủy': 'HU',
        'tỉnh ủy': 'TU',
        'trung ương': 'TW',
        'văn phòng trung ương': 'VPTW',
        'ủy ban kiểm tra trung ương': 'UBKTTW',
        'ủy ban kiểm tra đảng ủy': 'UBKTĐU',
        'chi bộ': 'CB',
        'ban chỉ đạo': 'BCĐ',
        'tiểu ban': 'TB',
        'đảng ủy quân sự': 'ĐUQS',
        'đảng ủy công an': 'ĐUCA',
      };
      for (final type in types.entries) {
        for (final agency in agencies.entries) {
          final spoken = '${type.key} số hai mươi chín '
              '${type.key} ${agency.key}';
          final written = '${type.key} số 29-'
              '${type.value}/${agency.value}';
          expect(
            normalizeVietnameseAdministrativeText(spoken),
            written,
            reason: spoken,
          );
        }
      }
    });

    test('Roman ordinal cues differ from literal calendar years', () {
      const examples = <String, String>{
        'Đại hội số năm 2026': 'Đại hội V 2026',
        'Đại hội năm 2026': 'Đại hội năm 2026',
        'Đại hội năm hai nghìn hai mươi sáu':
            'Đại hội năm hai nghìn hai mươi sáu',
        'Đại hội số mười ba': 'Đại hội XIII',
        'Đại hội số mười lăm': 'Đại hội XV',
        'Đại hội lần thứ năm': 'Đại hội lần thứ V',
        'Đại hội 5 người': 'Đại hội 5 người',
        'Đại hội 5 năm 2026': 'Đại hội 5 năm 2026',
        'Quốc hội khóa mười lăm': 'Quốc hội khóa XV',
        'Hội đồng nhân dân tỉnh khóa mười bốn':
            'Hội đồng nhân dân tỉnh khóa XIV',
        'hội nông dân tỉnh khóa mười': 'hội nông dân tỉnh khóa X',
        'lớp bồi dưỡng chính trị khóa 13':
            'lớp bồi dưỡng chính trị khóa 13',
        'quý một năm 2026': 'quý I năm 2026',
        'quý hai năm 2026': 'quý II năm 2026',
        'quý ba năm 2026': 'quý III năm 2026',
        'quý bốn năm 2026': 'quý IV năm 2026',
        'Đại hội số 13-KL/TW': 'Đại hội số 13-KL/TW',
      };
      for (final example in examples.entries) {
        expect(
          normalizeVietnameseAdministrativeText(example.key),
          example.value,
          reason: example.key,
        );
      }
    });

    test('does not rewrite quantities, prose, old-format archival IDs', () {
      const unchanged = <String>[
        '191/CV/ĐU',
        '15/BC/ĐU',
        '78/QĐ/ĐU',
        '5/NQ-ĐU',
        '01/BCĐ',
        '04-QĐ/UBKTĐU',
        '29-CV/ĐU',
        'Số 05-HD/VPTW',
        '29 công văn đảng ủy cần phân loại',
        'Căn cứ 29 công văn đảng ủy cần xử lý',
        'Quyết định 29 quy định đảng ủy',
        'Công văn 29 báo cáo đảng ủy',
      ];
      for (final source in unchanged) {
        final actual = normalizeVietnameseAdministrativeText(source);
        if (source.contains('cần') || source.startsWith('Căn cứ') ||
            source.startsWith('Quyết định 29') ||
            source.startsWith('Công văn 29')) {
          expect(actual.contains('-CV/ĐU') ||
              actual.contains('-QĐ/ĐU') ||
              actual.contains('-BC/ĐU'), isFalse, reason: source);
        } else {
          expect(actual, source, reason: source);
        }
      }
      expect(
        normalizeVietnameseAdministrativeText(
            'Số 29, công văn đảng ủy').contains('-CV/ĐU'),
        isFalse,
      );
    });
  });
}
