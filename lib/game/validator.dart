import 'model.dart';
import 'rules.dart';

abstract final class PuzzleValidator {
  static bool isValid(FlowLevel level) => problems(level).isEmpty;

  static List<String> problems(FlowLevel level) {
    final issues = <String>[];
    final cells = level.size * level.size;
    if (level.size < 2) issues.add('size');
    if (level.flows.isEmpty) issues.add('no colors');
    final seen = <int>{};
    for (var color = 0; color < level.flows.length; color++) {
      final flow = level.flows[color];
      if (flow.length < 2) {
        issues.add('color $color is too short');
        continue;
      }
      for (var i = 0; i < flow.length; i++) {
        final cell = flow[i];
        if (cell < 0 || cell >= cells) {
          issues.add('color $color has cell $cell');
          continue;
        }
        if (!seen.add(cell)) issues.add('cell $cell is used twice');
        if (i > 0 && !orthogonal(flow[i - 1], cell, level.size)) {
          issues.add('color $color breaks at $i');
        }
      }
      final ends = flow.where((cell) => level.ends[cell] != null).toList();
      if (flow.first != flow.last && (level.ends[flow.first] != color || level.ends[flow.last] != color)) {
        issues.add('color $color ends are wrong');
      }
      if (ends.length != 2) issues.add('color $color has ${ends.length} dots');
    }
    if (seen.length != cells) issues.add('covered ${seen.length} of $cells');
    if (issues.isEmpty && !Rules.isSolved(level.solved)) issues.add('solution is not complete');
    return issues;
  }

  static String layoutKey(FlowLevel level) {
    final pairs = <String>[];
    for (final flow in level.flows) {
      final a = flow.first;
      final b = flow.last;
      final low = a < b ? a : b;
      final high = a < b ? b : a;
      pairs.add('$low-$high');
    }
    pairs.sort();
    return '${level.size}:${pairs.join(',')}';
  }
}
