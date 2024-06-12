import 'package:flutter/material.dart';

import 'hook.dart';

/// A mixin to be used with StatefulWidget to enable the use of Hooks.
/// This mixin manages the lifecycle of Hooks, ensuring they are properly
/// initialized and disposed of.
mixin HookState<T extends StatefulWidget> on State<T> {
  var _hookIndex = 0;
  final _hooks = <Hook>[];

  /// Registers a Hook and ensures it is initialized only once.
  /// This method returns the registered Hook.
  R use<R extends Hook>(R hook) {
    late Hook value;
    if (_hooks.length > _hookIndex) {
      value = _hooks[_hookIndex];
    } else {
      hook.setState = _listener;
      hook.init();
      _hooks.add(hook);
      value = hook;
    }

    _hookIndex++;
    return value as R;
  }

  void resetIndex() => _hookIndex = 0;

  /// Listener to reset hook index and trigger a rebuild.
  void _listener() => setState(resetIndex);

  @override
  void reassemble() {
    _dispose();
    super.reassemble();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  /// Disposes all registered Hooks.
  void _dispose() {
    for (var hook in _hooks) {
      hook.dispose();
    }
    _hooks.clear();
    resetIndex();
  }
}
