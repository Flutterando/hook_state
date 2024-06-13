import 'dart:async';

import '../hook.dart';
import '../hook_state.dart';

/// Extension methods for HookState to handle Stream-based Hooks.
extension StreamHookStateExtension on HookState {
  /// Registers a StreamHook to listen to a Stream.
  /// Returns the latest value emitted by the Stream.
  R useStream<R>(Stream<R> stream, R initialValue) {
    final hook = _StreamHook<R>(stream, initialValue);
    return use(hook).value;
  }

  /// Registers a StreamCallbackHook to listen to a Stream and execute a callback.
  /// The callback is executed every time the Stream emits a new value.
  void useStreamChanged<R>(Stream<R> stream, void Function(R state) callback) {
    final hook = _StreamChangedHook<R>(stream, (R state) {
      callback(state);
      resetIndex();
    });
    use(hook);
  }
}

/// A Hook to listen to a Stream and execute a callback for each emitted value.
class _StreamChangedHook<R> extends Hook<R> {
  final Stream<R> stream;
  final void Function(R state) callback;

  late final StreamSubscription<R> subscription;

  _StreamChangedHook(this.stream, this.callback);

  @override
  void init() {
    subscription = stream.listen(callback);
  }

  @override
  void dispose() {
    subscription.cancel();
  }
}

/// A Hook to listen to a Stream and trigger rebuilds with new values.
class _StreamHook<R> extends Hook<R> {
  final Stream<R> stream;
  late final StreamSubscription<R> subscription;
  R value;

  _StreamHook(this.stream, this.value);

  @override
  void init() {
    subscription = stream.listen((event) {
      value = event;
      setState();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
  }
}
