import 'package:flutter/material.dart';

import 'hook.dart';

class _HookController {
  var _hookIndex = 0;
  final _hooks = <Hook>[];
  final void Function() _listener;

  _HookController(this._listener);

  static _HookController? _currentInstance;

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

  /// Disposes all registered Hooks.
  void dispose() {
    for (var hook in _hooks) {
      hook.dispose();
    }
    _hooks.clear();
    resetIndex();
  }
}

/// A mixin to be used with StatefulWidget to enable the use of Hooks.
/// This mixin manages the lifecycle of Hooks, ensuring they are properly
/// initialized and disposed of.
abstract class HookState {
  /// Registers a Hook and ensures it is initialized only once.
  /// This method returns the registered Hook.
  R use<R extends Hook>(R hook);

  void resetIndex();
}

mixin HookStateMixin<T extends StatefulWidget> on State<T> implements HookState {
  late final _hookController = _HookController(_listener);

  @override
  void resetIndex() => _hookController.resetIndex();

  @override
  R use<R extends Hook>(R hook) {
    return _hookController.use(hook);
  }

  void _listener() => setState(resetIndex);

  @override
  void reassemble() {
    _hookController.dispose();
    super.reassemble();
  }

  @override
  void dispose() {
    _hookController.dispose();
    super.dispose();
  }
}

mixin HookMixin on StatelessWidget implements HookState {
  @override
  StatelessElement createElement() {
    return _HookElement(this);
  }

  @override
  void resetIndex() => _HookController._currentInstance!.resetIndex();

  @override
  R use<R extends Hook>(R hook) => _HookController._currentInstance!.use<R>(hook);
}

class _HookElement extends StatelessElement {
  late final _hookController = _HookController(invalidate);

  _HookElement(super.widget);

  @override
  HookMixin get widget => super.widget as HookMixin;

  void invalidate() {
    _hookController.resetIndex();
    markNeedsBuild();
  }

  @override
  void reassemble() {
    _hookController.dispose();
    super.reassemble();
  }

  @override
  void unmount() {
    _hookController.dispose();
    super.unmount();
  }

  @override
  Widget build() {
    _HookController._currentInstance = _hookController;
    final child = super.build();
    _HookController._currentInstance = null;
    if (_hookController._hookIndex == 0) {
      debugPrint('No use for hook found in ${widget.runtimeType}');
    }
    return child;
  }
}
