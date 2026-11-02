import 'model.dart';

/// Finds one full covering. Used to check that a puzzle is solvable without
/// trusting the stored path. The stored path is still the hint source.
abstract final class PuzzleSolver {
  static List<List<int>>? solve(FlowLevel level, {int budget = 300000}) {
    final size = level.size;
    final cells = size * size;
    final colors = level.colorCount;
    final endpointPairs = List<List<int>>.generate(colors, level.empty.endpointsOf);
    final order = List<int>.generate(colors, (index) => index)
      ..sort((a, b) {
        final da = _manhattan(endpointPairs[a][0], endpointPairs[a][1], size);
        final db = _manhattan(endpointPairs[b][0], endpointPairs[b][1], size);
        return da.compareTo(db);
      });

    final owner = List<int>.filled(cells, -1);
    final found = List<List<int>>.generate(colors, (_) => <int>[]);
    var steps = 0;

    bool regionsHold(int orderIndex) {
      final remaining = order.sublist(orderIndex).toSet();
      if (remaining.isEmpty) return owner.every((value) => value != -1);
      final seen = List<bool>.filled(cells, false);
      final componentOf = <int, int>{};
      final countOf = <int, int>{};
      var component = 0;
      for (var cell = 0; cell < cells; cell++) {
        if (seen[cell] || owner[cell] != -1) continue;
        final queue = <int>[cell];
        seen[cell] = true;
        var holdsDot = false;
        while (queue.isNotEmpty) {
          final current = queue.removeLast();
          final mark = level.ends[current];
          if (mark != null && remaining.contains(mark)) {
            holdsDot = true;
            final previous = componentOf[mark];
            if (previous != null && previous != component) return false;
            componentOf[mark] = component;
            countOf[mark] = (countOf[mark] ?? 0) + 1;
          }
          for (final next in _neighbors(current, size)) {
            if (seen[next] || owner[next] != -1) continue;
            seen[next] = true;
            queue.add(next);
          }
        }
        if (!holdsDot) return false;
        component++;
      }
      for (final color in remaining) {
        if (countOf[color] != 2) return false;
      }
      return true;
    }

    int openness(int cell) {
      var count = 0;
      for (final next in _neighbors(cell, size)) {
        if (owner[next] == -1) count++;
      }
      return count;
    }

    bool place(int orderIndex) {
      if (steps > budget) return false;
      if (orderIndex == order.length) return owner.every((value) => value != -1);
      if (!regionsHold(orderIndex)) return false;

      final color = order[orderIndex];
      final start = endpointPairs[color][0];
      final goal = endpointPairs[color][1];
      final path = <int>[start];
      owner[start] = color;

      bool walk() {
        if (steps++ > budget) return false;
        final head = path.last;
        if (orthogonal(head, goal, size) && owner[goal] == -1) {
          path.add(goal);
          owner[goal] = color;
          found[color] = List<int>.of(path);
          if (place(orderIndex + 1)) return true;
          found[color] = <int>[];
          path.removeLast();
          owner[goal] = -1;
        }
        final options = <int>[];
        for (final next in _neighbors(head, size)) {
          if (next == goal || owner[next] != -1) continue;
          options.add(next);
        }
        options.sort((a, b) {
          final byOpen = openness(a).compareTo(openness(b));
          return byOpen != 0 ? byOpen : a.compareTo(b);
        });
        for (final next in options) {
          path.add(next);
          owner[next] = color;
          if (walk()) return true;
          path.removeLast();
          owner[next] = -1;
          if (steps > budget) return false;
        }
        return false;
      }

      final ok = walk();
      if (!ok) owner[start] = -1;
      return ok;
    }

    if (!place(0)) return null;
    return found;
  }

  static int _manhattan(int a, int b, int size) {
    final ar = a ~/ size;
    final ac = a % size;
    final br = b ~/ size;
    final bc = b % size;
    return (ar - br).abs() + (ac - bc).abs();
  }

  static List<int> _neighbors(int cell, int size) {
    final row = cell ~/ size;
    final col = cell % size;
    final next = <int>[];
    if (row > 0) next.add(cell - size);
    if (row + 1 < size) next.add(cell + size);
    if (col > 0) next.add(cell - 1);
    if (col + 1 < size) next.add(cell + 1);
    return next;
  }
}
