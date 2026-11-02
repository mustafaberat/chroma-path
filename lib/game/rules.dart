import 'model.dart';

/// Drawing rules. A path grows from a dot, stays on orthogonal cells, and
/// never crosses another color. Pulling back, or grabbing a cell already on
/// the same path, shortens it.
abstract final class Rules {
  static Board? startStroke(Board board, int cell) {
    if (cell < 0 || cell >= board.cellCount) return null;
    final endpoint = board.ends[cell];
    if (endpoint != null) {
      return _withPath(board, endpoint, [cell]);
    }
    final color = board.ownerOf(cell);
    if (color == null) return null;
    final path = board.paths[color];
    final index = path.indexOf(cell);
    return _withPath(board, color, path.sublist(0, index + 1));
  }

  static Board? extend(Board board, int color, int cell) {
    if (color < 0 || color >= board.colorCount) return null;
    if (cell < 0 || cell >= board.cellCount) return null;
    final path = board.paths[color];
    if (path.isEmpty) return null;
    final head = path.last;
    if (cell == head) return board;
    if (!orthogonal(head, cell, board.size)) return null;

    if (path.length >= 2 && path[path.length - 2] == cell) {
      return _withPath(board, color, path.sublist(0, path.length - 1));
    }

    final own = path.indexOf(cell);
    if (own != -1) {
      return _withPath(board, color, path.sublist(0, own + 1));
    }

    final endpoint = board.ends[cell];
    if (endpoint != null && endpoint != color) return null;
    if (board.ownerOf(cell) != null) return null;
    return _withPath(board, color, [...path, cell]);
  }

  static Board cleared(Board board) => Board(
    size: board.size,
    ends: board.ends,
    paths: List<List<int>>.generate(board.colorCount, (_) => <int>[]),
  );

  static bool isSolved(Board board) {
    if (board.ends.length != board.cellCount) return false;
    final seen = <int>{};
    for (var color = 0; color < board.colorCount; color++) {
      final path = board.paths[color];
      final ends = board.endpointsOf(color);
      if (ends.length != 2 || path.length < 2) return false;
      final starts = path.first == ends[0] || path.first == ends[1];
      final finishes = path.last == ends[0] || path.last == ends[1];
      if (!starts || !finishes || path.first == path.last) return false;
      for (var i = 0; i < path.length; i++) {
        final cell = path[i];
        if (!seen.add(cell)) return false;
        if (i > 0 && !orthogonal(path[i - 1], cell, board.size)) return false;
        final mark = board.ends[cell];
        if (mark != null && mark != color) return false;
      }
    }
    return seen.length == board.cellCount;
  }

  static bool connects(Board board, int color) {
    final path = board.paths[color];
    if (path.length < 2) return false;
    final ends = board.endpointsOf(color);
    if (ends.length != 2) return false;
    final forward = path.first == ends[0] && path.last == ends[1];
    final backward = path.first == ends[1] && path.last == ends[0];
    return forward || backward;
  }

  static int starsFor(int hints, int resets) {
    final spent = hints + resets;
    if (spent <= 0) return 3;
    if (spent <= 2) return 2;
    return 1;
  }

  static Board _withPath(Board board, int color, List<int> path) {
    final paths = [for (final item in board.paths) List<int>.of(item)];
    paths[color] = path;
    return Board(size: board.size, ends: board.ends, paths: paths);
  }
}
