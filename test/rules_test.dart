import 'package:chroma_path/game/levels.dart';
import 'package:chroma_path/game/model.dart';
import 'package:chroma_path/game/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Board empty() {
    final ends = List<int?>.filled(9, null);
    ends[0] = 0;
    ends[8] = 0;
    ends[2] = 1;
    ends[6] = 1;
    return Board(size: 3, ends: ends, paths: [[], []]);
  }

  test('diagonal steps are rejected', () {
    final started = Rules.startStroke(empty(), 0)!;
    expect(Rules.extend(started, 0, 4), isNull);
    expect(started.paths[0], [0]);
  });

  test('a path rewinds and shortens when it crosses itself', () {
    var board = Rules.startStroke(empty(), 0)!;
    board = Rules.extend(board, 0, 1)!;
    board = Rules.extend(board, 0, 4)!;
    board = Rules.extend(board, 0, 3)!;
    expect(board.paths[0], [0, 1, 4, 3]);
    board = Rules.extend(board, 0, 4)!;
    expect(board.paths[0], [0, 1, 4]);
    board = Rules.extend(board, 0, 1)!;
    expect(board.paths[0], [0, 1]);
    final grabbed = Rules.startStroke(board, 0)!;
    expect(grabbed.paths[0], [0]);
  });

  test('another color endpoint or path cannot be crossed', () {
    var board = Rules.startStroke(empty(), 2)!;
    board = Rules.extend(board, 1, 5)!;
    expect(board.paths[1], [2, 5]);
    var red = Rules.startStroke(board, 0)!;
    red = Rules.extend(red, 0, 1)!;
    expect(Rules.extend(red, 0, 2), isNull);
    red = Rules.extend(red, 0, 4)!;
    expect(Rules.extend(red, 0, 5), isNull);
    expect(red.paths[0], [0, 1, 4]);
    expect(red.paths[1], [2, 5]);
  });

  test('empty cells and a reversed solution', () {
    final level = Levels.all.first;
    expect(Rules.isSolved(level.empty), isFalse);
    expect(Rules.isSolved(level.solved), isTrue);
    final reversed = Board(
      size: level.size,
      ends: level.ends,
      paths: [for (final flow in level.flows) flow.reversed.toList()],
    );
    expect(Rules.isSolved(reversed), isTrue);
    final missing = Board(
      size: level.size,
      ends: level.ends,
      paths: [
        level.flows.first.sublist(0, level.flows.first.length - 1),
        for (final flow in level.flows.skip(1)) List<int>.of(flow),
      ],
    );
    expect(Rules.isSolved(missing), isFalse);
  });

  test('stars drop as hints and resets are used', () {
    expect(Rules.starsFor(0, 0), 3);
    expect(Rules.starsFor(1, 0), 2);
    expect(Rules.starsFor(0, 2), 2);
    expect(Rules.starsFor(2, 2), 1);
  });

  test('stepToward never moves diagonally', () {
    expect(stepToward(0, 1, 5), 1);
    expect(stepToward(0, 6, 5), 5);
    final step = stepToward(0, 12, 5)!;
    expect(orthogonal(0, step, 5), isTrue);
  });
}
