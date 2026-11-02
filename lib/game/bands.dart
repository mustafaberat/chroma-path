class LevelBand {
  const LevelBand(this.from, this.to, this.size, this.minPairs, this.maxPairs);

  final int from;
  final int to;
  final int size;
  final int minPairs;
  final int maxPairs;

  static const List<LevelBand> all = [
    LevelBand(1, 10, 5, 2, 3),
    LevelBand(11, 25, 6, 3, 4),
    LevelBand(26, 45, 7, 4, 5),
    LevelBand(46, 70, 8, 5, 6),
    LevelBand(71, 100, 9, 6, 7),
  ];

  static LevelBand of(int level) {
    for (final band in all) {
      if (level >= band.from && level <= band.to) return band;
    }
    throw ArgumentError.value(level, 'level');
  }

  int pairsFor(int level) {
    if (minPairs == maxPairs) return minPairs;
    final t = (level - from) / (to - from);
    return (minPairs + (t * (maxPairs - minPairs)).floor()).clamp(minPairs, maxPairs);
  }
}
