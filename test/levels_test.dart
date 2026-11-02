import 'package:chroma_path/game/bands.dart';
import 'package:chroma_path/game/generator.dart';
import 'package:chroma_path/game/hint.dart';
import 'package:chroma_path/game/levels.dart';
import 'package:chroma_path/game/model.dart';
import 'package:chroma_path/game/rules.dart';
import 'package:chroma_path/game/solver.dart';
import 'package:chroma_path/game/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every level is a unique solved puzzle in its band', () {
    expect(Levels.all, hasLength(100));
    final seen = <String>{};
    for (final level in Levels.all) {
      expect(PuzzleValidator.problems(level), isEmpty, reason: 'level ${level.id}');
      expect(seen.add(PuzzleValidator.layoutKey(level)), isTrue, reason: 'level ${level.id}');
      final band = LevelBand.of(level.id);
      expect(level.size, band.size);
      expect(level.colorCount, inInclusiveRange(band.minPairs, band.maxPairs));
    }
  });

  test('the generator builds a checked puzzle', () {
    final level = PuzzleGenerator.woven(id: 80, size: 9, pairs: 7, seed: 3, straight: 0.2);
    expect(level, isNotNull);
    expect(PuzzleValidator.isValid(level!), isTrue);
    expect(level.size, 9);
    expect(level.colorCount, 7);
  });

  test('hint follows the solution and ignores a wrong branch', () {
    final level = Levels.all.first;
    expect(HintSystem.nextCell(level, level.empty), level.flows.first[1]);
    final prefix = level.flows.first.sublist(0, 2);
    final partial = Board(
      size: level.size,
      ends: level.ends,
      paths: [
        prefix,
        for (var color = 1; color < level.colorCount; color++) <int>[],
      ],
    );
    expect(HintSystem.nextCell(level, partial), level.flows.first[2]);

    final wrong = Board(
      size: level.size,
      ends: level.ends,
      paths: [
        [...prefix, 99],
        for (var color = 1; color < level.colorCount; color++) <int>[],
      ],
    );
    expect(HintSystem.nextCell(level, wrong), level.flows.first[2]);
    expect(HintSystem.nextCell(level, level.solved), isNull);
  });

  test('a small puzzle is solvable without the stored path', () {
    final level = Levels.all.first;
    final found = PuzzleSolver.solve(level, budget: 200000);
    expect(found, isNotNull);
    final board = Board(size: level.size, ends: level.ends, paths: found!);
    expect(Rules.isSolved(board), isTrue);
  });
}
