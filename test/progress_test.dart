import 'package:color_links/services/progress_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('progress unlocks the next level and keeps the best stars', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = ProgressStore(prefs);

    expect(store.isUnlocked(0), isTrue);
    expect(store.isUnlocked(1), isFalse);
    expect(store.currentNumber, 1);

    await store.markComplete(0, 2);
    expect(store.isComplete(0), isTrue);
    expect(store.isUnlocked(1), isTrue);
    expect(store.stars[0], 2);
    expect(store.draft, isNull);

    await store.markComplete(0, 1);
    expect(store.stars[0], 2);

    await store.saveDraft(const PuzzleDraft(levelIndex: 1, paths: [
      [0, 1],
    ], hints: 1, resets: 0));

    final restored = ProgressStore(prefs);
    expect(restored.stars[0], 2);
    expect(restored.isUnlocked(1), isTrue);
    expect(restored.draft?.levelIndex, 1);
    expect(restored.draft?.paths, [
      [0, 1],
    ]);
    expect(restored.draft?.hints, 1);

    await restored.markComplete(1, 3);
    expect(restored.draft, isNull);
    expect(restored.isUnlocked(2), isTrue);

    await restored.resetAll();
    final cleared = ProgressStore(prefs);
    expect(cleared.finishedAll, isFalse);
    expect(cleared.stars.every((value) => value == 0), isTrue);
    expect(cleared.draft, isNull);
    expect(cleared.isUnlocked(1), isFalse);
  });

  test('a broken save is ignored', () async {
    SharedPreferences.setMockInitialValues({'progress_draft': '{', 'progress_stars': 'nope'});
    final prefs = await SharedPreferences.getInstance();
    final store = ProgressStore(prefs);
    expect(store.draft, isNull);
    expect(store.stars.every((value) => value == 0), isTrue);
  });
}
