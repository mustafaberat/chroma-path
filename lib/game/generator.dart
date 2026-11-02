import 'dart:math';

import 'bands.dart';
import 'model.dart';
import 'validator.dart';

typedef RectSpec = ({int r0, int c0, int r1, int c1, bool vertical, bool flip});

abstract final class PuzzleGenerator {
  static List<FlowLevel> buildAll() {
    final levels = <FlowLevel>[..._manual()];
    final seen = {for (final level in levels) PuzzleValidator.layoutKey(level)};
    for (var id = levels.length + 1; id <= 100; id++) {
      final band = LevelBand.of(id);
      final pairs = band.pairsFor(id);
      final t = (id - 21) / 79;
      final straight = (0.82 - t * 0.7).clamp(0.12, 0.82);
      final level = _woven(
        id: id,
        size: band.size,
        pairs: pairs,
        straight: straight,
        rng: Random(id * 9176 + 42),
        seen: seen,
      );
      seen.add(PuzzleValidator.layoutKey(level));
      levels.add(level);
    }
    return levels;
  }

  static FlowLevel? woven({
    required int id,
    required int size,
    required int pairs,
    required int seed,
    double straight = 0.4,
  }) {
    return _woven(
      id: id,
      size: size,
      pairs: pairs,
      straight: straight,
      rng: Random(seed),
      seen: {},
    );
  }

  static FlowLevel _woven({
    required int id,
    required int size,
    required int pairs,
    required double straight,
    required Random rng,
    required Set<String> seen,
  }) {
    for (var attempt = 0; attempt < 60; attempt++) {
      final path = _hamiltonian(size, rng, straight);
      if (path == null) continue;
      final flows = _split(path, pairs, rng)..shuffle(rng);
      final level = FlowLevel(id: id, size: size, flows: flows);
      final issues = PuzzleValidator.problems(level);
      if (issues.isNotEmpty) continue;
      if (seen.contains(PuzzleValidator.layoutKey(level))) continue;
      return level;
    }
    throw StateError('no unique puzzle for level $id');
  }

  static List<int>? _hamiltonian(int size, Random rng, double straight) {
    final cells = size * size;
    final starts = List<int>.generate(cells, (index) => index)..shuffle(rng);
    for (final start in starts.take(8)) {
      final path = _search(size, rng, straight, start, budget: 120000);
      if (path != null) return path;
    }
    return null;
  }

  static List<int>? _search(int size, Random rng, double straight, int start, {required int budget}) {
    final cells = size * size;
    final visited = List<bool>.filled(cells, false);
    final path = <int>[start];
    visited[start] = true;
    var steps = 0;
    var direction = -1;

    List<({int cell, int dir, int score})> options(int cell, int previousDir) {
      final row = cell ~/ size;
      final col = cell % size;
      const deltas = [(-1, 0), (1, 0), (0, -1), (0, 1)];
      final found = <({int cell, int dir, int score})>[];
      for (var dir = 0; dir < deltas.length; dir++) {
        final nextRow = row + deltas[dir].$1;
        final nextCol = col + deltas[dir].$2;
        if (nextRow < 0 || nextCol < 0 || nextRow >= size || nextCol >= size) continue;
        final next = nextRow * size + nextCol;
        if (visited[next]) continue;
        var open = 0;
        for (final delta in deltas) {
          final lookRow = nextRow + delta.$1;
          final lookCol = nextCol + delta.$2;
          if (lookRow < 0 || lookCol < 0 || lookRow >= size || lookCol >= size) continue;
          if (!visited[lookRow * size + lookCol]) open++;
        }
        var score = open * 10 + rng.nextInt(5);
        if (previousDir == dir) score -= (straight * 14).round();
        found.add((cell: next, dir: dir, score: score));
      }
      found.sort((a, b) => a.score.compareTo(b.score));
      return found;
    }

    bool walk() {
      if (path.length == cells) return true;
      if (++steps > budget) return false;
      final previous = direction;
      for (final option in options(path.last, previous)) {
        visited[option.cell] = true;
        path.add(option.cell);
        direction = option.dir;
        if (walk()) return true;
        direction = previous;
        path.removeLast();
        visited[option.cell] = false;
        if (steps > budget) return false;
      }
      return false;
    }

    if (!walk()) return null;
    return List<int>.of(path);
  }

  static List<List<int>> _split(List<int> path, int parts, Random rng) {
    final total = path.length;
    final minLength = total >= parts * 3 ? 3 : 2;
    var remaining = total;
    final lengths = <int>[];
    for (var index = 0; index < parts; index++) {
      final slots = parts - index;
      if (slots == 1) {
        lengths.add(remaining);
        break;
      }
      final maxLength = remaining - minLength * (slots - 1);
      final ideal = (remaining / slots).round();
      final length = (ideal + rng.nextInt(3) - 1).clamp(minLength, maxLength);
      lengths.add(length);
      remaining -= length;
    }
    final flows = <List<int>>[];
    var offset = 0;
    for (final length in lengths) {
      flows.add(path.sublist(offset, offset + length));
      offset += length;
    }
    return flows;
  }

  static List<FlowLevel> _manual() {
    FlowLevel build(int id, int size, List<RectSpec> rects) {
      final level = FlowLevel(id: id, size: size, flows: [for (final rect in rects) _snake(size, rect)]);
      final issues = PuzzleValidator.problems(level);
      final band = LevelBand.of(id);
      if (issues.isNotEmpty) {
        throw StateError('manual $id: $issues');
      }
      if (level.size != band.size || level.colorCount < band.minPairs || level.colorCount > band.maxPairs) {
        throw StateError('manual $id is outside its band');
      }
      return level;
    }

    return [
      build(1, 5, [_r(0, 0, 1, 4), _r(2, 0, 2, 4), _r(3, 0, 4, 4)]),
      build(2, 5, [_r(0, 0, 4, 1, vertical: true), _r(0, 2, 4, 2, vertical: true), _r(0, 3, 4, 4, vertical: true)]),
      build(3, 5, [_r(0, 0, 4, 2, vertical: true), _r(0, 3, 4, 4, vertical: true, flip: true)]),
      build(4, 5, [_r(0, 0, 2, 4), _r(3, 0, 4, 4, flip: true)]),
      build(5, 5, [_r(0, 0, 4, 0, vertical: true), _r(0, 1, 4, 2), _r(0, 3, 4, 4, flip: true)]),
      build(6, 5, [_r(0, 0, 4, 1, vertical: true), _r(0, 2, 2, 4), _r(3, 2, 4, 4, flip: true)]),
      build(7, 5, [_r(0, 0, 1, 4), _r(2, 0, 4, 2, vertical: true), _r(2, 3, 4, 4)]),
      build(8, 5, [_r(0, 0, 2, 2), _r(0, 3, 4, 4, vertical: true), _r(3, 0, 4, 2, flip: true)]),
      build(9, 5, [_r(0, 0, 4, 1), _r(0, 2, 4, 4, vertical: true, flip: true)]),
      build(10, 5, [_r(0, 0, 1, 2), _r(0, 3, 4, 4, vertical: true), _r(2, 0, 4, 2, flip: true)]),
      build(11, 6, [_r(0, 0, 1, 5), _r(2, 0, 3, 5, flip: true), _r(4, 0, 5, 5)]),
      build(12, 6, [_r(0, 0, 2, 2), _r(0, 3, 2, 5, flip: true), _r(3, 0, 5, 2, vertical: true), _r(3, 3, 5, 5)]),
      build(13, 6, [_r(0, 0, 5, 1, vertical: true), _r(0, 2, 5, 3, vertical: true, flip: true), _r(0, 4, 5, 5, vertical: true)]),
      build(14, 6, [
        _r(0, 0, 5, 0, vertical: true),
        _r(0, 1, 5, 2),
        _r(0, 3, 5, 4, flip: true),
        _r(0, 5, 5, 5, vertical: true, flip: true),
      ]),
      build(15, 6, [_r(0, 0, 0, 5), _r(1, 0, 2, 5, flip: true), _r(3, 0, 4, 5), _r(5, 0, 5, 5, flip: true)]),
      build(16, 6, [_r(0, 0, 2, 3), _r(0, 4, 2, 5, vertical: true), _r(3, 0, 5, 1, flip: true), _r(3, 2, 5, 5)]),
      build(17, 6, [_r(0, 0, 5, 2, vertical: true), _r(0, 3, 2, 5), _r(3, 3, 5, 5, flip: true)]),
      build(18, 6, [_r(0, 0, 1, 5), _r(2, 0, 5, 2, vertical: true), _r(2, 3, 5, 5)]),
      build(19, 6, [_r(0, 0, 3, 2), _r(0, 3, 3, 5, flip: true), _r(4, 0, 5, 2, vertical: true), _r(4, 3, 5, 5)]),
      build(20, 6, [_r(0, 0, 5, 1, vertical: true), _r(0, 2, 3, 3), _r(0, 4, 3, 5, flip: true), _r(4, 2, 5, 5)]),
    ];
  }

  static RectSpec _r(int r0, int c0, int r1, int c1, {bool vertical = false, bool flip = false}) =>
      (r0: r0, c0: c0, r1: r1, c1: c1, vertical: vertical, flip: flip);

  static List<int> _snake(int size, RectSpec rect) {
    final cells = <int>[];
    if (!rect.vertical) {
      final rows = [for (var row = rect.r0; row <= rect.r1; row++) row];
      final orderedRows = rect.flip ? rows.reversed.toList() : rows;
      var leftToRight = !rect.flip;
      for (final row in orderedRows) {
        final cols = [for (var col = rect.c0; col <= rect.c1; col++) col];
        for (final col in leftToRight ? cols : cols.reversed) {
          cells.add(row * size + col);
        }
        leftToRight = !leftToRight;
      }
    } else {
      final cols = [for (var col = rect.c0; col <= rect.c1; col++) col];
      final orderedCols = rect.flip ? cols.reversed.toList() : cols;
      var topToBottom = !rect.flip;
      for (final col in orderedCols) {
        final rows = [for (var row = rect.r0; row <= rect.r1; row++) row];
        for (final row in topToBottom ? rows : rows.reversed) {
          cells.add(row * size + col);
        }
        topToBottom = !topToBottom;
      }
    }
    return cells;
  }
}
