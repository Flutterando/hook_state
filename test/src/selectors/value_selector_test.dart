import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

void main() {
  group('ValueSelector Tests', () {
    test('ValueSelector should compute initial value', () {
      final counter = ValueNotifier<int>(1);
      final doubleCounter = ValueSelector<int>((get) => get(counter) * 2);

      expect(doubleCounter.value, 2);
    });

    test('ValueSelector should update value when dependent changes', () {
      final counter = ValueNotifier<int>(1);
      final doubleCounter = ValueSelector<int>((get) => get(counter) * 2);

      counter.value = 2;
      expect(doubleCounter.value, 4);
    });

    test('ValueSelector should notify listeners on value change', () {
      final counter = ValueNotifier<int>(1);
      final doubleCounter = ValueSelector<int>((get) => get(counter) * 2);

      bool notified = false;
      doubleCounter.addListener(() {
        notified = true;
      });

      counter.value = 2;
      expect(notified, true);
      expect(doubleCounter.value, 4);
    });
  });

  group('AsyncValueSelector Tests', () {
    test('AsyncValueSelector should compute initial value asynchronously',
        () async {
      final asyncCounter = AsyncValueSelector<int>(0, (get) async {
        await Future.delayed(Duration(milliseconds: 100));
        return 5;
      });

      await asyncCounter.isReady;
      expect(asyncCounter.value, 5);
    });

    test('AsyncValueSelector should update value when dependent changes',
        () async {
      final counter = ValueNotifier<int>(1);
      final asyncDoubleCounter = AsyncValueSelector<int>(0, (get) async {
        return get(counter) * 2;
      });

      await asyncDoubleCounter.isReady;
      expect(asyncDoubleCounter.value, 2);

      counter.value = 3;
      await Future.delayed(Duration(milliseconds: 100)); // allow async update
      expect(asyncDoubleCounter.value, 6);
    });

    test('AsyncValueSelector should notify listeners on value change',
        () async {
      final counter = ValueNotifier<int>(1);
      final asyncDoubleCounter = AsyncValueSelector<int>(0, (get) async {
        return get(counter) * 2;
      });

      bool notified = false;
      asyncDoubleCounter.addListener(() {
        notified = true;
      });
      expect(notified, false);
      await asyncDoubleCounter.isReady;

      counter.value = 2;
      await Future.delayed(
          const Duration(milliseconds: 100)); // allow async update
      expect(notified, true);
      expect(asyncDoubleCounter.value, 4);
    });
  });
}
