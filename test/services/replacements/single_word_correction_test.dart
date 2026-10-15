import 'package:flutter_test/flutter_test.dart';
import 'package:whispaste/services/replacements/correction_learning_service.dart';

void main() {
  test('extracts one changed Vietnamese word from a transcript edit', () {
    final result = singleWordCorrection(
      'Báo cáo công tác của huyền ủy',
      'Báo cáo công tác của huyện ủy',
    );
    expect(result?.source, 'huyền');
    expect(result?.target, 'huyện');
  });

  test('does not auto-learn sentences, punctuation or short tokens', () {
    expect(singleWordCorrection('abc def', 'ghi jkl'), isNull);
    expect(singleWordCorrection('đã đi', 'đã về!'), isNull);
    expect(singleWordCorrection('đi đi', 'đi về'), isNull);
    expect(singleWordCorrection('Huyện ủy', 'huyện ủy'), isNull);
  });
}
