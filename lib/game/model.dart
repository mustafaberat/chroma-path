import 'bands.dart';

/// One cell index is `row * size + column`.
class Board {
  Board({required this.size, required this.ends, required List<List<int>> paths})
    : paths = [for (final path in paths) List<int>.of(path)];

  final int size;
  final List<int?> ends;
  final List<List<int>> paths;

  int get colorCount => paths.length;
  int get cellCount => size * size;

  Board copy() => Board(size: size, ends: ends, paths: paths);

  int? ownerOf(int cell) {
    for (var color = 0; color < paths.length; color++) {
      if (paths[color].contains(cell)) return color;
    }
    return null;
  }

  List<int> endpointsOf(int color) {
    final found = <int>[];
    for (var cell = 0; cell < ends.length; cell++) {
      if (ends[cell] == color) found.add(cell);
    }
    return found;
  }

  String get signature => paths.map((path) => path.join('.')).join('|');
}

class FlowLevel {
  FlowLevel({required this.id, required this.size, required List<List<int>> flows})
    : flows = [for (final flow in flows) List<int>.of(flow)];

  final int id;
  final int size;
  final List<List<int>> flows;

  int get index => id - 1;
  int get colorCount => flows.length;

  late final List<int?> ends = () {
    final painted = List<int?>.filled(size * size, null);
    for (var color = 0; color < flows.length; color++) {
      final flow = flows[color];
      painted[flow.first] = color;
      painted[flow.last] = color;
    }
    return painted;
  }();

  Board get empty => Board(
    size: size,
    ends: ends,
    paths: List<List<int>>.generate(colorCount, (_) => <int>[]),
  );

  Board get solved => Board(size: size, ends: ends, paths: flows);

  LevelBand get band => LevelBand.of(id);
}

bool orthogonal(int a, int b, int size) {
  if (a == b || a < 0 || b < 0) return false;
  final cells = size * size;
  if (a >= cells || b >= cells) return false;
  final ar = a ~/ size;
  final ac = a % size;
  final br = b ~/ size;
  final bc = b % size;
  return (ar - br).abs() + (ac - bc).abs() == 1;
}

/// One orthogonal step from [head] toward [target]. Diagonal travel becomes a stair.
int? stepToward(int head, int target, int size) {
  if (head == target) return null;
  final hr = head ~/ size;
  final hc = head % size;
  final tr = target ~/ size;
  final tc = target % size;
  final dr = tr - hr;
  final dc = tc - hc;
  if (dr == 0 && dc == 0) return null;
  if (dr != 0 && dr.abs() >= dc.abs()) {
    return (hr + dr.sign) * size + hc;
  }
  return hr * size + (hc + dc.sign);
}
