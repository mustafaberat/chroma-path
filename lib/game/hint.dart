import 'model.dart';
import 'rules.dart';

abstract final class HintSystem {
  /// The next cell of the known solution for the color the player has
  /// already drawn the farthest. Empty colors point at their first dot.
  static int? nextCell(FlowLevel level, Board board) {
    var bestLength = -1;
    int? bestCell;
    for (var color = 0; color < level.colorCount; color++) {
      if (Rules.connects(board, color) && board.paths[color].length == level.flows[color].length) {
        continue;
      }
      final solution = level.flows[color];
      final player = board.paths[color];
      final forward = _prefix(solution, player);
      final backward = _prefix(solution.reversed.toList(), player);
      final length = forward >= backward ? forward : backward;
      final source = forward >= backward ? solution : solution.reversed.toList();
      if (length >= source.length) continue;
      final nextIndex = length == 0 && source.length > 1 ? 1 : length;
      if (nextIndex >= source.length) continue;
      if (length > bestLength) {
        bestLength = length;
        bestCell = source[nextIndex];
      }
    }
    return bestCell;
  }

  static int _prefix(List<int> solution, List<int> player) {
    if (player.isEmpty || solution.isEmpty || player.first != solution.first) return 0;
    var count = 0;
    final limit = player.length < solution.length ? player.length : solution.length;
    for (var i = 0; i < limit; i++) {
      if (player[i] != solution[i]) break;
      count++;
    }
    return count;
  }
}
