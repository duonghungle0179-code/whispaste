/// Deterministic Vietnamese administrative-document text normalization.
///
/// Formats dates and explicitly spoken document symbols, including
/// "nghị quyết không ba nghị quyết huyện ủy" -> "nghị quyết 03-NQ/HU".
/// Unknown issuers and ambiguous documents remain unchanged.
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

/// Extra numeric reading for spoken *document codes* only.
/// "hai chín công văn đảng ủy" is 29-CV/ĐU, but ordinary "hai chín"
/// elsewhere is not converted into a number.
_NumberRead? _readDocumentNumber(String text, List<_Token> tokens, int start) {
  final ordinary = _readNumber(text, tokens, start);
  if (start >= tokens.length) return ordinary;
  var end = start;
  while (end < tokens.length && end - start < 6 &&
      _digits.containsKey(tokens[end].lower)) {
    if (end > start) {
      final separator = text.substring(tokens[end - 1].end, tokens[end].start);
      if (!_whitespace.hasMatch(separator) || separator.contains('\n')) break;
    }
    end++;
  }
  if (end - start < 2 || (ordinary != null && ordinary.next >= end)) {
    return ordinary;
  }
  final digits = tokens.sublist(start, end).map((t) => _digits[t.lower]!).join();
  final value = int.tryParse(digits);
  if (value == null) return ordinary;
  return _NumberRead(value, digits, end);
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

/// "Đại hội số năm 2026" -> "Đại hội V 2026".
/// "Đại hội năm 2026" remains unchanged.
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
    } else {
      // A bare number after "Đại hội" is not enough evidence that it
      // is an ordinal. Require "số", "lần", "thứ", or a nearby "lần thứ".
      if (_isNumberToken(tokens[numberAt])) continue;
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

    // Vietnamese "năm" may be five or a calendar-year introducer.
    // Without "số/lần/thứ", do not turn "Đại hội năm 2026"
    // into "Đại hội V 2026".
    if (!hasOrdinalMarker && tokens[numberAt].lower == 'năm') {
      continue;
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

    // "số" is a spoken ordinal cue, not part of the desired output:
    // "Đại hội số năm 2026" -> "Đại hội V 2026".
    // Preserve "lần thứ" and "thứ" in other ordinal expressions.
    final start = marker == 'số' ? tokens[i + 2].start : tokens[numberAt].start;
    edits.add(_Edit(
      start,
      end,
      _toCongressRoman(number.value),
    ));
    i = number.next - 1;
  }
  return _applyEdits(text, edits);
}


// --- Conservative terminology rules for Vietnamese Party documents ---
//
// These are spoken-text formatting rules, not a catalogue of real documents.
// The document number alone is not enough to infer an issuing authority.
// Refs: 05-HD/VPTW (27 May 2026); user-supplied archival title examples.

const _partyDocumentTypes = <String, String>{
  'nghị quyết': 'NQ',
  'quy chế': 'QC',
  'báo cáo': 'BC',
  'biên bản': 'BB',
  'công văn': 'CV',
  'tờ trình': 'TTr',
  'đề án': 'ĐA',
  'kết luận': 'KL',
  'chỉ thị': 'CT',
  'quyết định': 'QĐ',
  'quy định': 'QĐ',
  'hướng dẫn': 'HD',
  'kế hoạch': 'KH',
  'chương trình': 'CTr',
  'thông báo': 'TB',
  'thông tri': 'TT',
};

const _partyTypeAliases = <String, String>{
  ..._partyDocumentTypes,
  // Common dictation spellings for letter-by-letter administrative codes.
  'en quy': 'NQ',
  'nờ quy': 'NQ',
  'cê vê': 'CV',
  'xê vê': 'CV',
  'bê cê': 'BC',
  'bê xê': 'BC',
  'bê bê': 'BB',
  'quy đê': 'QĐ',
  'hát đê': 'HD',
  'tê bê': 'TB',
  'nq': 'NQ',
  'qc': 'QC',
  'bc': 'BC',
  'bb': 'BB',
  'cv': 'CV',
  'ttr': 'TTr',
  'đa': 'ĐA',
  'kl': 'KL',
  'ct': 'CT',
  'qđ': 'QĐ',
  'qd': 'QĐ',
  'hd': 'HD',
  'kh': 'KH',
  'ctr': 'CTr',
  'tb': 'TB',
  'tt': 'TT',
};

// Longer phrases must precede their prefixes. A term is recognised ONLY
// when explicitly spoken, not guessed from a document number.
const _partyIssuingBodies = <String, String>{
  // Phonetic readings are accepted only inside a fully identified code.
  'hát u': 'HU',
  'đê u': 'ĐU',
  'tê u': 'TU',
  'tê vê kép': 'TW',
  'tê bê': 'TB',
  'đảng ủy quân sự': 'ĐUQS',
  'quân ủy trung ương': 'QUTW',
  'đảng ủy công an': 'ĐUCA',
  'đảng ủy biên phòng': 'ĐUBP',
  'ủy ban kiểm tra đảng ủy': 'UBKTĐU',
  'ủy ban kiểm tra đảng uỷ': 'UBKTĐU',
  'cơ quan ủy ban kiểm tra': 'CQUBKT',
  'ban xây dựng đảng': 'BXDĐ',
  'ủy ban kiểm tra': 'UBKT',
  'chi bộ': 'CB',
  'ban chỉ đạo': 'BCĐ',
  'tiểu ban': 'TB',
  'hội đồng': 'HĐ',
  'đoàn chủ tịch đại hội': 'ĐH',
  'đoàn thư ký đại hội': 'ĐH',
  'ban tuyên giáo và dân vận trung ương': 'BTGDVTW',
  'ban tuyên giáo và dân vận tỉnh ủy': 'BTGDVTU',
  'ủy ban kiểm tra trung ương': 'UBKTTW',
  'văn phòng trung ương đảng': 'VPTW',
  'văn phòng tỉnh ủy': 'VPTU',
  'văn phòng huyện ủy': 'VPHU',
  'đảng ủy công an huyện': 'ĐUCAH',
  'ban dân vận huyện ủy': 'BDVHU',
  'ban tổ chức tỉnh ủy': 'BTCTU',
  'ban tổ chức huyện ủy': 'BTCHU',
  'ban nội chính tỉnh ủy': 'BNCTU',
  'ban tổ chức trung ương': 'BTCTW',
  'văn phòng trung ương': 'VPTW',
  'ban chấp hành trung ương đảng': 'TW',
  'ban chấp hành trung ương': 'TW',
  'ban bí thư trung ương đảng': 'TW',
  'ban thường vụ tỉnh ủy': 'TU',
  'ban thường vụ huyện ủy': 'HU',
  'bch trung ương': 'TW',
  'trung ương đảng': 'TW',
  'bộ chính trị': 'TW',
  'ban bí thư': 'TW',
  'tỉnh ủy': 'TU',
  'tỉnh uỷ': 'TU',
  'huyện ủy': 'HU',
  'huyện uỷ': 'HU',
  'đảng ủy': 'ĐU',
  'đảng uỷ': 'ĐU',
  'đại hội': 'ĐH',
  'trung ương': 'TW',
  'ubktđu': 'UBKTĐU',
  'cq ubkt': 'CQUBKT',
  'đ u q s': 'ĐUQS',
  'đuca': 'ĐUCA',
  'đubp': 'ĐUBP',
  'ubkt': 'UBKT',
  'bxdđ': 'BXDĐ',
  'cb': 'CB',
  'bcđ': 'BCĐ',
  'qu tw': 'QUTW',
  'ubkttw': 'UBKTTW',
  'btgdvtw': 'BTGDVTW',
  'btgdvtu': 'BTGDVTU',
  'vptu': 'VPTU',
  'vphu': 'VPHU',
  'đucah': 'ĐUCAH',
  'bdvhu': 'BDVHU',
  'btctu': 'BTCTU',
  'btchu': 'BTCHU',
  'btctw': 'BTCTW',
  'vptw': 'VPTW',
  'bnctu': 'BNCTU',
  'tw': 'TW',
  'tu': 'TU',
  'hu': 'HU',
  'đu': 'ĐU',
  'đ u': 'ĐU',
};

class _PartyPhraseMatch {
  const _PartyPhraseMatch(this.value, this.next);
  final String value;
  final int next;
}

/// Whitespace-only phrase matching; never match across punctuation or lines.
_PartyPhraseMatch? _matchPartyPhrase(
  String text,
  List<_Token> tokens,
  int start,
  Map<String, String> phrases,
) {
  if (start < 0 || start >= tokens.length) return null;
  _PartyPhraseMatch? best;
  var bestLength = 0;
  for (final entry in phrases.entries) {
    final parts = entry.key.split(' ');
    if (start + parts.length > tokens.length) continue;
    var found = true;
    for (var j = 0; j < parts.length; j++) {
      if (tokens[start + j].lower != parts[j]) {
        found = false;
        break;
      }
      if (j > 0) {
        final between = text.substring(
          tokens[start + j - 1].end,
          tokens[start + j].start,
        );
        if (!_whitespace.hasMatch(between) || between.contains('\n')) {
          found = false;
          break;
        }
      }
    }
    if (found && parts.length > bestLength) {
      best = _PartyPhraseMatch(entry.value, start + parts.length);
      bestLength = parts.length;
    }
  }
  return best;
}

/// Keeps spoken symbol fragments inside one uninterrupted phrase.
bool _partyWordsAreAdjacent(
  String text,
  List<_Token> tokens,
  int start,
  int end,
) {
  for (var j = start + 1; j < end; j++) {
    final separator = text.substring(tokens[j - 1].end, tokens[j].start);
    if (!_whitespace.hasMatch(separator) || separator.contains('\n')) {
      return false;
    }
  }
  return true;
}

String? _partyDocumentTypeBeforeNumber(
  String text,
  List<_Token> tokens,
  int numberKeywordIndex,
) {
  for (final entry in _partyDocumentTypes.entries) {
    final start = numberKeywordIndex - entry.key.split(' ').length;
    final matched = _matchPartyPhrase(
      text,
      tokens,
      start,
      <String, String>{entry.key: entry.value},
    );
    if (matched != null && matched.next == numberKeywordIndex) {
      return matched.value;
    }
  }
  return null;
}

_PartyPhraseMatch? _partyBodyAfter(
  String text,
  List<_Token> tokens,
  int start,
) {
  if (start < tokens.length && tokens[start].lower == 'của') {
    start++;
  }
  return _matchPartyPhrase(text, tokens, start, _partyIssuingBodies);
}

/// Format explicitly spoken codes such as:
/// - "Nghị quyết số 27 NQ Trung ương" -> "Nghị quyết số 27-NQ/TW"
/// - "Hướng dẫn số 02 HD Ban Tổ chức Trung ương" -> "02-HD/BTCTW"
/// - "Nghị quyết số 27 của Bộ Chính trị" -> "27-NQ/TW của ..."
///
/// Without BOTH the document type and its issuing body, leave the number
/// as-is. Never overwrite an existing hyphenated/slashed document code.
String _normalizePartyDocumentCodes(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    if (tokens[i].lower != 'số') continue;
    final number = _readDocumentNumber(text, tokens, i + 1);
    if (number == null || number.value > 999999) continue;
    final numberEnd = tokens[number.next - 1].end;
    final tail = text.substring(numberEnd);
    if (RegExp(r'^\s*[-/]').hasMatch(tail)) continue;

    final precedingType = _partyDocumentTypeBeforeNumber(text, tokens, i);
    final spokenType = _matchPartyPhrase(
      text,
      tokens,
      number.next,
      _partyTypeAliases,
    );

    // Explicit code spoken AFTER the number: consume code words, not content.
    if (spokenType != null &&
        (precedingType == null || precedingType == spokenType.value)) {
      // Quyết định and Quy định have the same code (QĐ) but are different
      // document types. Reject a conflicting full-word dictation.
      if (precedingType == 'QĐ' && spokenType.value == 'QĐ' &&
          i >= 2 && spokenType.next > number.next) {
        final before = text.substring(
          tokens[i - 2].start, tokens[i - 1].end,
        ).toLowerCase();
        final after = text.substring(
          tokens[number.next].start, tokens[spokenType.next - 1].end,
        ).toLowerCase();
        if (after != 'qđ' && after != 'qd' &&
            after != 'quy đê' && after != before) {
          continue;
        }
      }
      final body = _partyBodyAfter(text, tokens, spokenType.next);
      if (body != null &&
          _partyWordsAreAdjacent(text, tokens, i + 1, body.next)) {
        final formatted = number.display + '-' +
            spokenType.value + '/' + body.value;
        edits.add(_Edit(
          tokens[i + 1].start,
          tokens[body.next - 1].end,
          formatted,
        ));
        i = body.next - 1;
        continue;
      }
    }

    // Normal dictation: "Kết luận số 61 của Ban Bí thư".
    // Keep the issuing body's spoken words; add only the known suffix.
    if (precedingType != null) {
      final body = _partyBodyAfter(text, tokens, number.next);
      if (body != null) {
        edits.add(_Edit(
          tokens[i + 1].start,
          numberEnd,
          number.display + '-' + precedingType + '/' + body.value,
        ));
        i = number.next - 1;
      }
    }
  }
  return _applyEdits(text, edits);
}

/// Congress and Party-organisation sessions use Roman ordinal numerals;
/// training classes, document IDs and calendar years do not.
bool _hasPartySessionContext(String text, List<_Token> tokens, int at) {
  if (at <= 0) return false;
  final start = at > 10 ? at - 10 : 0;
  final before = text
      .substring(tokens[start].start, tokens[at].start)
      .toLowerCase()
      .split(RegExp(r'[.!?;\n]'))
      .last;
  if (before.contains('lớp ') || before.contains('lớp bồi dưỡng')) {
    return false;
  }
  const markers = <String>[
    'đại hội', 'đảng bộ', 'đảng ủy', 'đảng uỷ',
    'ban chấp hành', 'bộ chính trị', 'ban bí thư',
    'quốc hội', 'hội đồng nhân dân', 'hđnd', 'bch', 'bct',
    'mặt trận tổ quốc', 'hội nông dân', 'hội liên hiệp phụ nữ',
    'công đoàn', 'đoàn thanh niên',
  ];
  return markers.any(before.contains);
}

String _normalizePartySessionOrdinals(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    final word = tokens[i].lower;
    if (word != 'khóa' && word != 'quý') continue;
    final number = _readNumber(text, tokens, i + 1);
    if (number == null) continue;

    if (word == 'khóa' &&
        (number.value < 1 ||
            number.value > 30 ||
            !_hasPartySessionContext(text, tokens, i))) {
      continue;
    }
    if (word == 'quý' && (number.value < 1 || number.value > 4)) {
      continue;
    }
    final start = tokens[i + 1].start;
    final end = tokens[number.next - 1].end;
    if (RegExp(r'^\s*[-]').hasMatch(text.substring(end))) continue;
    final roman = _toCongressRoman(number.value);
    if (text.substring(start, end) != roman) {
      edits.add(_Edit(start, end, roman));
    }
    i = number.next - 1;
  }
  return _applyEdits(text, edits);
}

/// Date ranges only when explicitly said "nhiệm kỳ ... đến ..." or
/// "giai đoạn ... đến ..."; never join unrelated adjacent years.
String _normalizePartyYearRanges(String text) {
  final pattern = RegExp(
    r'(nhiệm kỳ|giai đoạn)\s+((?:19|20)\d{2})\s+(đến|tới)\s+((?:19|20)\d{2})',
    caseSensitive: false,
    unicode: true,
  );
  final edits = <_Edit>[];
  for (final m in pattern.allMatches(text)) {
    final first = int.parse(m.group(2)!);
    final second = int.parse(m.group(4)!);
    if (second < first || second - first > 20) continue;
    edits.add(_Edit(
      m.start,
      m.end,
      m.group(1)! + ' ' + m.group(2)! + '-' + m.group(4)!,
    ));
  }
  return _applyEdits(text, edits);
}

// Expand NOTHING automatically: an already recognized "BCH" stays "BCH",
// while clearly identified full institutional names receive standard casing.
// Longer proper names appear first to avoid overlapping token edits.
const _partyProperTerms = <String, String>{
  'ban chấp hành trung ương đảng': 'Ban Chấp hành Trung ương Đảng',
  'văn phòng trung ương đảng': 'Văn phòng Trung ương Đảng',
  'ban tổ chức trung ương': 'Ban Tổ chức Trung ương',
  'ban nội chính tỉnh ủy': 'Ban Nội chính Tỉnh ủy',
  'ban chấp hành trung ương': 'Ban Chấp hành Trung ương',
  'mặt trận tổ quốc việt nam': 'Mặt trận Tổ quốc Việt Nam',
  'đảng cộng sản việt nam': 'Đảng Cộng sản Việt Nam',
  'hội nông dân việt nam': 'Hội Nông dân Việt Nam',
  'ủy ban kiểm tra': 'Ủy ban Kiểm tra',
  'uỷ ban kiểm tra': 'Ủy ban Kiểm tra',
  'ban chấp hành': 'Ban Chấp hành',
  'ban thường vụ': 'Ban Thường vụ',
  'bộ chính trị': 'Bộ Chính trị',
  'ban bí thư': 'Ban Bí thư',
  'trung ương đảng': 'Trung ương Đảng',
  'tỉnh ủy': 'Tỉnh ủy',
  'tỉnh uỷ': 'Tỉnh ủy',
  'huyện ủy': 'Huyện ủy',
  'huyện uỷ': 'Huyện ủy',
  'đảng ủy': 'Đảng ủy',
  'đảng uỷ': 'Đảng ủy',
  'đảng bộ': 'Đảng bộ',
  'bch': 'BCH',
  'btv': 'BTV',
  'bct': 'BCT',
  'ubkt': 'UBKT',
  'mttqvn': 'MTTQVN',
  'ubmttqvn': 'UBMTTQVN',
  'nk': 'NK',
};

String _normalizePartyProperTerms(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    final matched = _matchPartyPhrase(text, tokens, i, _partyProperTerms);
    if (matched == null) continue;
    final start = tokens[i].start;
    final end = tokens[matched.next - 1].end;
    if (text.substring(start, end) != matched.value) {
      edits.add(_Edit(start, end, matched.value));
    }
    i = matched.next - 1;
  }
  return _applyEdits(text, edits);
}

/// Converts dictation of a document's full spoken symbol, including the
/// common form without "số": "nghị quyết không ba nghị quyết huyện ủy".
/// A second, matching document type after the number is mandatory: this
/// distinguishes a spoken symbol from ordinary "nghị quyết ba ...".
/// Standalone archive code dictation: "hai mươi chín công văn đảng ủy"
/// -> "29-CV/ĐU". Allow at the beginning of an input or immediately after
/// an explicit "ký hiệu"/"số hiệu" cue, never inside ordinary narrative.
String _normalizeBarePartyCodes(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    var allowed = i == 0;
    if (i >= 2 && tokens[i - 2].lower == 'ký' &&
        tokens[i - 1].lower == 'hiệu') {
      allowed = true;
    }
    if (i >= 2 && tokens[i - 2].lower == 'số' &&
        tokens[i - 1].lower == 'hiệu') {
      allowed = true;
    }
    if (!allowed) continue;
    final hasSpokenCue = i >= 2;
    final number = _readDocumentNumber(text, tokens, i);
    if (number == null || number.value > 999999 ||
        number.next >= tokens.length) continue;
    final kind = _matchPartyPhrase(
        text, tokens, number.next, _partyTypeAliases);
    if (kind == null) continue;
    final body = _partyBodyAfter(text, tokens, kind.next);
    if (body == null || !_partyWordsAreAdjacent(
        text, tokens, i, body.next)) continue;
    // A bare number + body inside a longer sentence might be a quantity:
    // "29 công văn đảng ủy cần xử lý" must NOT become a document ID.
    if (!hasSpokenCue && body.next < tokens.length) continue;
    final replacement = number.display + '-' + kind.value + '/' + body.value;
    edits.add(_Edit(tokens[i].start, tokens[body.next - 1].end,
        replacement));
    i = body.next - 1;
  }
  return _applyEdits(text, edits);
}

String _normalizeSpokenPartyCodes(String text) {
  final tokens = _tokenize(text);
  final edits = <_Edit>[];
  for (var i = 0; i < tokens.length; i++) {
    final type = _matchPartyPhrase(text, tokens, i, _partyDocumentTypes);
    if (type == null) continue;
    var numberAt = type.next;
    if (numberAt < tokens.length && tokens[numberAt].lower == 'số') {
      numberAt++;
    }
    if (numberAt >= tokens.length) continue;
    final number = _readDocumentNumber(text, tokens, numberAt);
    if (number == null || number.value > 999999) continue;
    // Require whitespace throughout the spoken symbol, not a preformatted
    // identifier or punctuation separating independent clauses.
    var adjacent = true;
    for (var j = i + 1; j < number.next; j++) {
      final between = text.substring(tokens[j - 1].end, tokens[j].start);
      if (!_whitespace.hasMatch(between) || between.contains('\n')) {
        adjacent = false;
        break;
      }
    }
    if (!adjacent) continue;
    final numberEnd = tokens[number.next - 1].end;
    if (RegExp(r'^\s*[-/]').hasMatch(text.substring(numberEnd))) {
      continue;
    }
    final repeat = _matchPartyPhrase(
      text, tokens, number.next, _partyTypeAliases,
    );
    if (repeat == null || repeat.value != type.value) continue;

    // "quyết định" and "quy định" both use QĐ. Do not silently
    // treat one *spoken word* as the other just because the code matches.
    if (type.value == 'QĐ') {
      final firstText = text.substring(
        tokens[i].start, tokens[type.next - 1].end,
      ).toLowerCase();
      final repeatedText = text.substring(
        tokens[number.next].start, tokens[repeat.next - 1].end,
      ).toLowerCase();
      if (repeatedText != 'qđ' && repeatedText != 'qd' &&
          repeatedText != 'quy đê' &&
          firstText != repeatedText) {
        continue;
      }
    }
    final body = _partyBodyAfter(text, tokens, repeat.next);
    if (body == null) continue;
    // Do not cross punctuation between type, number and issuing body.
    var safe = true;
    for (var j = number.next; j < body.next; j++) {
      if (j == 0) continue;
      final between = text.substring(tokens[j - 1].end, tokens[j].start);
      if (!_whitespace.hasMatch(between) || between.contains('\n')) {
        safe = false;
        break;
      }
    }
    if (!safe) continue;
    final replacement = number.display + '-' + type.value + '/' + body.value;
    edits.add(_Edit(tokens[numberAt].start, tokens[body.next - 1].end,
        replacement));
    i = body.next - 1;
  }
  return _applyEdits(text, edits);
}

/// Normalizes explicit spoken references, without guessing incomplete metadata.
///
/// "Số sáu mươi mốt kết luận Trung ương" -> "Số 61-KL/TW"
/// "ngày ba tháng mười hai năm hai nghìn lẻ chín" -> "ngày 3/12/2009"
String normalizeVietnameseAdministrativeText(String text) {
  var result = _normalizeDates(text);
  result = _normalizeSpokenPartyCodes(result);
  result = _normalizeBarePartyCodes(result);
  result = _normalizePartyDocumentCodes(result);
  result = _normalizeNumbers(result);
  result = _normalizeCongressOrdinals(result);
  result = _normalizePartySessionOrdinals(result);
  result = _normalizePartyYearRanges(result);
  result = _normalizePartyProperTerms(result);
  return result;
}
