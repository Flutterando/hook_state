import 'package:flutter/material.dart';

import 'hook.dart';

class _HookController {
  var _hookIndex = 0;
  final _hooks = <Hook>[];

  R use<R extends Hook>(R hook, void Function() listener) {
    late Hook value;
    if (_hooks.length > _hookIndex) {
      value = _hooks[_hookIndex];
    } else {
      hook.setState = listener;
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
  final _hookController = _HookController();

  @override
  void resetIndex() => _hookController.resetIndex();

  @override
  R use<R extends Hook>(R hook) {
    return _hookController.use(hook, _listener);
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

class _MutableController {
  _HookController? hookController;
  void Function()? listener;

  R use<R extends Hook>(R hook) => hookController!.use<R>(hook, listener!);
}

mixin HookMixin on StatelessWidget implements HookState {
  final _hack = _MutableController();

  @override
  StatelessElement createElement() {
    return _HookElement(this);
  }

  @override
  void resetIndex() => _hack.hookController!.resetIndex();

  @override
  R use<R extends Hook>(R hook) => _hack.use<R>(hook);
}

class _HookElement extends StatelessElement {
  final _hookController = _HookController();

  _HookElement(super.widget);

  @override
  HookMixin get widget => super.widget as HookMixin;

  void invalidate() {
    _hookController.resetIndex();
    markNeedsBuild();
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    widget._hack.hookController = _hookController;
    widget._hack.listener = invalidate;
    super.mount(parent, newSlot);
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
    final child = super.build();
    if (_hookController._hookIndex == 0) {
      debugPrint('No use for hook found in ${widget.runtimeType}');
    }
    return child;
  }
}
