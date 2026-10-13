/// Deterministic Vietnamese administrative-document text normalization.
///
/// Only explicit "số" identifiers and "ngày...tháng...năm..." dates are
/// transformed. Unknown document types and ambiguous cases remain unchanged.
library;

final _tokenPattern = RegExp(r'[A-Za-zÀ-ỹĐđ]+|[0-9]+', unicode: true);
final _asciiDigits = RegExp(r'^[0-9]+$');
final _whitespace = RegExp(r'^\s+$');
const _digits = <String, int>{
  'không': 0, 'một': 1, 'hai': 2, 'ba': 3, 'bốn': 4, 'tư': 4,
  'năm': 5, 'lăm': 5, 'sáu': 6, 'bảy': 7, 'tám': 8,
  'chín': 9, 'mốt': 1,
};
const _fillers = <String>{'linh', 'lẻ'};
const _thousands = <String>{'nghìn', 'ngàn'};
final _numberWords = <String>{
  ..._digits.keys, ..._fillers, ..._thousands, 'trăm', 'mươi', 'mười',
};

/// Require a known document type AND issuing body; do not guess an agency.
const _codeSuffixes = <String, String>{
  'kết luận ban chấp hành trung ương': '-KL/TW',
  'kết luận của trung ương': '-KL/TW',
  'kết luận trung ương': '-KL/TW',
  'nghị quyết ban chấp hành trung ương': '-NQ/TW',
  'nghị quyết của trung ương': '-NQ/TW',
  'nghị quyết trung ương': '-NQ/TW',
  'chỉ thị trung ương': '-CT/TW',
  'hướng dẫn văn phòng trung ương': '-HD/VPTW',
  'quyết định của ủy ban nhân dân': '/QĐ-UBND',
  'quyết định ủy ban nhân dân': '/QĐ-UBND',
  'kế hoạch của ủy ban nhân dân': '/KH-UBND',
  'kế hoạch ủy ban nhân dân': '/KH-UBND',
  'thông báo của ủy ban nhân dân': '/TB-UBND',
  'thông báo ủy ban nhân dân': '/TB-UBND',
  'công văn của ủy ban nhân dân': '/CV-UBND',
  'công văn ủy ban nhân dân': '/CV-UBND',
  'nghị quyết chính phủ': '/NQ-CP',
  'kl tw': '-KL/TW',
  'nq tw': '-NQ/TW',
  'qđ ubnd': '/QĐ-UBND',
  'kh ubnd': '/KH-UBND',
  'tb ubnd': '/TB-UBND',
};

class _Token {
  const _Token(this.text, this.start, this.end);
  final String text;
  final int start;
  final int end;
  String get lower => text.toLowerCase();
}

class _NumberRead {
  const _NumberRead(this.value, this.display, this.next);
  final int value;
  final String display;
  final int next;
}

class _Edit {
  const _Edit(this.start, this.end, this.replacement);
  final int start;
  final int end;
  final String replacement;
}

List<_Token> _tokenize(String text) => [
  for (final m in _tokenPattern.allMatches(text))
    _Token(m.group(0)!, m.start, m.end),
];

bool _isNumberToken(_Token t) =>
    _asciiDigits.hasMatch(t.text) || _numberWords.contains(t.lower);

int? _belowThousand(List<String> words, {bool allowLeadingFiller = false}) {
  if (words.isEmpty) return 0;
  var at = 0;
  var value = 0;
  var hasHundreds = false;
  if (words.length >= 2 && words[1] == 'trăm') {
    final digit = _digits[words.first];
    if (digit == null || words.first == 'mốt' || words.first == 'lăm') {
      return null;
    }
    value += digit * 100;
    at = 2;
    hasHundreds = true;
  }
  if (at < words.length && _fillers.contains(words[at])) {
    if (!hasHundreds && !allowLeadingFiller) return null;
    at++;
    if (at == words.length) return null;
  }
  if (at == words.length) return value;
  if (words[at] == 'mười') {
    value += 10;
    at++;
    if (at < words.length) {
      final ones = _digits[words[at]];
      if (ones == null) return null;
      value += ones;
      at++;
    }
  } else if (at + 1 < words.length && words[at + 1] == 'mươi') {
    final tens = _digits[words[at]];
    if (tens == null || tens < 2) return null;
    value += tens * 10;
    at += 2;
    if (at < words.length) {
      final ones = _digits[words[at]];
      if (ones == null) return null;
      value += ones;
      at++;
    }
  } else {
    final ones = _digits[words[at]];
    if (ones == null || words[at] == 'mốt' || words[at] == 'lăm') {
      return null;
    }
    value += ones;
    at++;
  }
  return at == words.length ? value : null;
}

int? _parseSpokenNumber(List<String> words) {
  if (words.isEmpty) return null;
  final thousandAt = words.indexWhere(_thousands.contains);
  if (thousandAt < 0) return _belowThousand(words);
  if (thousandAt == 0 ||
      words.skip(thousandAt + 1).any(_thousands.contains)) {
    return null;
  }
  final high = _belowThousand(words.sublist(0, thousandAt));
  final low = _belowThousand(
    words.sublist(thousandAt + 1),
    allowLeadingFiller: true,
  );
  if (high == null || high == 0 || low == null) return null;
  return high * 1000 + low;
}

/// Reads the longest syntactically valid number from adjacent tokens.
_NumberRead? _readNumber(String text, List<_Token> tokens, int start) {
  if (start >= tokens.length || !_isNumberToken(tokens[start])) return null;
  var end = start;
  while (end < tokens.length && end - start < 15) {
    if (!_isNumberToken(tokens[end])) break;
    if (end > start &&
        !_whitespace.hasMatch(
          text.substring(tokens[end - 1].end, tokens[end].start),
        )) {
      break;
    }
    end++;
  }
  for (var last = end; last > start; last--) {
    final words = tokens.sublist(start, last).map((t) => t.lower).toList();
    if (words.length == 1 && _asciiDigits.hasMatch(words.first)) {
      final value = int.tryParse(words.first);
      if (value != null) return _NumberRead(value, words.first, last);
    }
    // Explicit digit sequences: "không tám" -> 08, "hai không hai sáu" -> 2026.
    if (words.length >= 2 &&
        words.length <= 4 &&
        (words.first == 'không' || words.length == 4) &&
        words.every(_digits.containsKey)) {
      final digits = words.map((w) => _digits[w]!).join();
      final value = int.tryParse(digits);
      if (value != null) return _NumberRead(value, digits, last);
    }
    final value = _parseSpokenNumber(words);
    if (value != null) return _NumberRead(value, '$value', last);
  }
  return null;
}

bool _isValidDate(int day, int month, int year) {
  if (year < 1000 || year > 2999 ||
      month < 1 || month > 12 ||
      day < 1 || day > 31) {
    return false;
  }
  final date = DateTime.utc(year, month, day);
  return date.year == year && date.month == month && date.day == day;
}

String _applyEdits(String text, List<_Edit> edits) {
  if (edits.isEmpty) return text;
  final output = StringBuffer();
  var cursor = 0;
  for (final edit in edits) {
    if (edit.start < cursor) continue;
    output.write(text.substring(cursor, edit.start));
    output.write(edit.replacement);
    cursor = edit.end;
  }
  output.write(text.substring(cursor));
  return output.toString();
}

String _normalizeDates(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    if (tokens[i].lower != 'ngày') continue;
    var first = i + 1;
    if (first < tokens.length &&
        (tokens[first].lower == 'mùng' || tokens[first].lower == 'mồng')) {
      first++;
    }
    final day = _readNumber(text, tokens, first);
    if (day == null ||
        day.next >= tokens.length ||
        tokens[day.next].lower != 'tháng') {
      continue;
    }
    final month = _readNumber(text, tokens, day.next + 1);
    if (month == null ||
        month.next >= tokens.length ||
        tokens[month.next].lower != 'năm') {
      continue;
    }
    final year = _readNumber(text, tokens, month.next + 1);
    if (year == null || !_isValidDate(day.value, month.value, year.value)) {
      continue;
    }
    final formatted = day.value.toString() + '/' +
        month.value.toString() + '/' + year.value.toString();
    edits.add(_Edit(tokens[first].start, tokens[year.next - 1].end, formatted));
    i = year.next - 1;
  }
  return _applyEdits(text, edits);
}

String _normalizeNumbers(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    if (tokens[i].lower != 'số') continue;
    final num = _readNumber(text, tokens, i + 1);
    if (num == null || num.value > 999999) continue;
    String? suffix;
    var last = num.next;
    for (final entry in _codeSuffixes.entries) {
      final phrase = entry.key.split(' ');
      if (num.next + phrase.length > tokens.length) continue;
      var matches = true;
      for (var p = 0; p < phrase.length; p++) {
        if (tokens[num.next + p].lower != phrase[p]) {
          matches = false;
          break;
        }
      }
      if (matches) {
        suffix = entry.value;
        last = num.next + phrase.length;
        break;
      }
    }
    final start = tokens[i + 1].start;
    final end = tokens[last - 1].end;
    final formatted = num.display + (suffix ?? '');
    if (text.substring(start, end) != formatted) {
      edits.add(_Edit(start, end, formatted));
    }
    i = last - 1;
  }
  return _applyEdits(text, edits);
}

/// Roman numerals are appropriate for a congress's ordinal number, not
/// arbitrary numbers such as document IDs, calendar dates or headcounts.
String _toCongressRoman(int value) {
  const symbols = <int, String>{
    10: 'X', 9: 'IX', 5: 'V', 4: 'IV', 1: 'I',
  };
  final result = StringBuffer();
  for (final entry in symbols.entries) {
    while (value >= entry.key) {
      result.write(entry.value);
      value -= entry.key;
    }
  }
  return result.toString();
}

/// "Đại hội số 13" -> "Đại hội số XIII".
/// "Đại hội đại biểu toàn quốc lần thứ mười ba" -> "... lần thứ XIII".
/// Only recognises a direct ordinal or an explicit "lần thứ" in the
/// same short clause; other values (13 people, 13/10, 13-KL/TW) are untouched.
String _normalizeCongressOrdinals(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i + 1 < tokens.length; i++) {
    if (tokens[i].lower != 'đại' || tokens[i + 1].lower != 'hội') {
      continue;
    }
    // Require the words "đại hội" to be adjacent, without punctuation.
    if (!_whitespace.hasMatch(
      text.substring(tokens[i].end, tokens[i + 1].start),
    )) {
      continue;
    }

    var numberAt = i + 2;
    if (numberAt >= tokens.length) continue;
    var hasOrdinalMarker = false;
    final marker = tokens[numberAt].lower;
    if (marker == 'số' || marker == 'lần' || marker == 'thứ') {
      hasOrdinalMarker = true;
      numberAt++;
      if (marker == 'lần' &&
          numberAt < tokens.length &&
          tokens[numberAt].lower == 'thứ') {
        numberAt++;
      }
    } else if (!_isNumberToken(tokens[numberAt])) {
      // Allow "Đại hội Đảng bộ tỉnh ... lần thứ 13", but do not jump
      // across sentence boundaries or unrelated, distant statements.
      var found = false;
      for (var j = i + 2; j + 2 < tokens.length && j < i + 14; j++) {
        if (tokens[j].lower == 'lần' &&
            tokens[j + 1].lower == 'thứ' &&
            !RegExp(r'[.!?;\n]').hasMatch(
              text.substring(tokens[i + 1].end, tokens[j].start),
            )) {
          numberAt = j + 2;
          hasOrdinalMarker = true;
          found = true;
          break;
        }
      }
      if (!found) continue;
    }

    final number = _readNumber(text, tokens, numberAt);
    // Bounded ordinals avoid misreading years (e.g. "Đại hội 2026").
    if (number == null || number.value < 1 || number.value > 30) {
      continue;
    }
    final end = tokens[number.next - 1].end;
    final tail = text.substring(end);
    // Do not change identifiers or dates, e.g. "13-KL/TW" or "13/10".
    if (RegExp(r'^\s*[-/]').hasMatch(tail) ||
        RegExp(r'^\s*[.,]\s*[0-9]').hasMatch(tail)) {
      continue;
    }
    // Without "số/lần/thứ", "13 người" is a count, not an ordinal.
    if (!hasOrdinalMarker &&
        number.next < tokens.length &&
        const <String>{
          'người', 'đại', 'thành', 'năm', 'ngày', 'tháng', 'khách',
          'đoàn', 'đơn',
        }.contains(tokens[number.next].lower) &&
        text.substring(end, tokens[number.next].start).trim().isEmpty) {
      continue;
    }

    edits.add(_Edit(
      tokens[numberAt].start,
      end,
      _toCongressRoman(number.value),
    ));
    i = number.next - 1;
  }
  return _applyEdits(text, edits);
}

/// Normalizes explicit spoken references, without guessing incomplete metadata.
///
/// "Số sáu mươi mốt kết luận Trung ương" -> "Số 61-KL/TW"
/// "ngày ba tháng mười hai năm hai nghìn lẻ chín" -> "ngày 3/12/2009"
String normalizeVietnameseAdministrativeText(String text) =>
    _normalizeCongressOrdinals(_normalizeNumbers(_normalizeDates(text)));
