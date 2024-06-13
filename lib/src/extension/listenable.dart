import 'package:flutter/material.dart';

import '../hook.dart';
import '../hook_state.dart';

/// Extension methods for HookState to handle Listenable-based Hooks.
extension ListenableHookStateExtension on HookState {
  /// Registers a ListenableHook to listen to a Listenable object.
  R useListenable<R extends Listenable>(
    R notifier, {
    bool Function(R value)? when,
  }) {
    final hook = _ListenableHook(notifier, when);
    return use(hook).listenable;
  }

  /// Registers a ValueNotifierHook to listen to a ValueNotifier.
  /// Returns the current value of the ValueNotifier.
  R useValueNotifier<R>(
    ValueNotifier<R> notifier, {
    bool Function(R value)? when,
  }) {
    final hook = _ListenableHook<ValueNotifier<R>>(
      notifier,
      (notifier) => when?.call(notifier.value) ?? true,
    );
    return use(hook).listenable.value;
  }

  /// Registers a CallbackHook to invoke a callback when a Listenable changes.
  void useCallback(List<Listenable> notifiers, void Function() callback) {
    final listeners = Listenable.merge(notifiers);
    final hook = _CallbackHook(listeners, () {
      callback();
      resetIndex();
    });
    use(hook);
  }

  /// Registers a ValueNotifier with an initial value.
  /// Returns the ValueNotifier.
  ValueNotifier<R> useNotifier<R>(R initialValue) {
    final hook =
        _ListenableHook<ValueNotifier<R>>(ValueNotifier(initialValue), null);
    return use(hook).listenable;
  }
}

/// A Hook to handle callbacks when a Listenable changes.
class _CallbackHook extends Hook<Listenable> {
  final Listenable listenable;
  final void Function() callback;

  _CallbackHook(this.listenable, this.callback);

  @override
  void init() {
    listenable.addListener(callback);
  }

  @override
  void dispose() {
    listenable.removeListener(callback);
  }
}

/// A Hook to listen to changes in a Listenable object and trigger rebuilds.
class _ListenableHook<R extends Listenable> extends Hook<R> {
  final R listenable;
  final bool Function(R)? when;

  _ListenableHook(this.listenable, this.when);

  @override
  void init() {
    listenable.addListener(_listener);
  }

  void _listener() {
    if (when?.call(listenable) ?? true) {
      setState();
    }
  }

  @override
  void dispose() {
    listenable.removeListener(_listener);
  }
}
