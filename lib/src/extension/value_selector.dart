import '../../hook_state.dart';

extension ValueSelectorExtension on HookState {
  T useValueSelector<T>(Selectable<T> selector) {
    useListenable<Selectable<T>>(selector);
    return selector.value;
  }
}
