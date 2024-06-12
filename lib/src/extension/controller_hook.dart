import 'package:flutter/material.dart';

import '../hook.dart';
import '../hook_state.dart';

/// Extension methods for HookState to handle various Controller-based Hooks.
extension ControllerHookStateExtension on HookState {
  /// Registers a TextEditingControllerHook to manage a TextEditingController.
  /// Returns the created TextEditingController.
  TextEditingController useTextEditingController({
    String? initialText,
  }) {
    final hook = _TextEditingControllerHook(initialText);
    return use(hook).controller;
  }

  /// Registers a FocusNodeHook to manage a FocusNode.
  /// Returns the created FocusNode.
  FocusNode useFocusNode() {
    final hook = _FocusNodeHook();
    return use(hook).focusNode;
  }

  /// Registers a TabControllerHook to manage a TabController.
  /// Returns the created TabController.
  TabController useTabController({
    required int length,
    required TickerProvider vsync,
    int initialIndex = 0,
  }) {
    final hook = _TabControllerHook(length, vsync, initialIndex);
    return use(hook).controller;
  }

  /// Registers a ScrollControllerHook to manage a ScrollController.
  /// Returns the created ScrollController.
  ScrollController useScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
  }) {
    final hook = _ScrollControllerHook(initialScrollOffset, keepScrollOffset);
    return use(hook).controller;
  }

  /// Registers a PageControllerHook to manage a PageController.
  /// Returns the created PageController.
  PageController usePageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) {
    final hook = _PageControllerHook(initialPage, keepPage, viewportFraction);
    return use(hook).controller;
  }
}

class _TextEditingControllerHook extends Hook<TextEditingController> {
  final String? initialText;

  late final TextEditingController controller;

  _TextEditingControllerHook(this.initialText);

  @override
  void init() {
    controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class _FocusNodeHook extends Hook<FocusNode> {
  late final FocusNode focusNode;
  @override
  void init() {
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
  }
}

class _TabControllerHook extends Hook<TabController> {
  final int length;
  final TickerProvider vsync;
  final int initialIndex;

  late final TabController controller;

  _TabControllerHook(this.length, this.vsync, this.initialIndex);

  @override
  void init() {
    controller = TabController(
      length: length,
      vsync: vsync,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class _ScrollControllerHook extends Hook<ScrollController> {
  final double initialScrollOffset;
  final bool keepScrollOffset;

  late final ScrollController controller;

  _ScrollControllerHook(this.initialScrollOffset, this.keepScrollOffset);

  @override
  void init() {
    controller = ScrollController(
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class _PageControllerHook extends Hook<PageController> {
  final int initialPage;
  final bool keepPage;
  final double viewportFraction;

  late final PageController controller;

  _PageControllerHook(this.initialPage, this.keepPage, this.viewportFraction);

  @override
  void init() {
    controller = PageController(
      initialPage: initialPage,
      keepPage: keepPage,
      viewportFraction: viewportFraction,
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}
