import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

/// Abstract class for a selectable value, extending ChangeNotifier.
abstract class Selectable<T> extends ChangeNotifier {
  /// The current value of the selectable.
  T get value;

  /// Listener method to be implemented by subclasses.
  void _listener();
}

/// A selector that computes a synchronous value based on a given scope.
class ValueSelector<T> extends Selectable<T> {
  final T Function(_ValueHelper get) scope;
  late T _value;

  @override
  T get value => _value;

  late final _get = _ValueHelper<T>(this);

  /// Constructs a ValueSelector with an initial value and a scope function.
  ValueSelector(this.scope) {
    _value = scope(_get);
    _get.tracking = false;
  }

  @override
  void _listener() {
    _value = scope(_get);
    notifyListeners();
  }

  @override
  void dispose() {
    _get.dispose();
    super.dispose();
  }
}

/// A selector that computes an asynchronous value based on a given scope.
class AsyncValueSelector<T> extends Selectable<T> {
  final FutureOr<T> Function(_ValueHelper get) scope;
  final Queue<FutureOr Function()> _requestQueue = Queue();
  bool _isProcessing = false;

  late final _get = _ValueHelper<T>(this);
  final _readyCompleter = Completer<bool>();

  /// Future that completes when the selector is ready.
  Future<bool> get isReady => _readyCompleter.future;

  late T _value;

  @override
  T get value => _value;

  /// Constructs an AsyncValueSelector with an initial value and a scope function.
  AsyncValueSelector(this._value, this.scope) {
    _requestQueue.add(_init);
    _processQueue();
  }

  /// Processes the request queue, ensuring only one request is processed at a time.
  Future<void> _processQueue() async {
    if (_isProcessing || _requestQueue.isEmpty) return;

    _isProcessing = true;
    try {
      while (_requestQueue.isNotEmpty) {
        final request = _requestQueue.removeFirst();
        await request();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void _listener() async {
    _requestQueue.add(() async {
      _value = await scope(_get);
      notifyListeners();
    });
    _processQueue();
  }

  /// Initializes the selector by computing the initial value.
  Future<void> _init() async {
    try {
      _value = await scope(_get);
      notifyListeners();
      _get.tracking = false;
      _readyCompleter.complete(true);
    } catch (e) {
      _readyCompleter.completeError(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    _get.dispose();
    super.dispose();
  }
}

/// Helper class to manage value dependencies and tracking for selectors.
class _ValueHelper<T> {
  final Selectable<T> _selector;
  final List<void Function()> _disposers = [];
  var tracking = true;

  _ValueHelper(this._selector);

  /// Registers a notifier and returns its value.
  R call<R>(ValueNotifier<R> notifier) {
    if (tracking) {
      notifier.addListener(_selector._listener);
      _disposers.add(() => notifier.removeListener(_selector._listener));
    }
    return notifier.value;
  }

  /// Disposes of all registered listeners.
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}
