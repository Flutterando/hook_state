import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../hook.dart';
import '../hook_state.dart';

/// Extension methods for HookState to handle Animation-based Hooks.
extension AnimationHookStateExtension on HookState {
  /// Registers an AnimationControllerHook to manage an AnimationController.
  /// Returns the created AnimationController.
  AnimationController useAnimationController({
    required Duration duration,
    required TickerProvider vsync,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    double? value,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    final hook = _AnimationControllerHook(
      duration: duration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: vsync,
      value: value,
      animationBehavior: animationBehavior,
    );
    return use(hook).controller;
  }
}

/// A Hook to manage an AnimationController.
class _AnimationControllerHook extends Hook<AnimationController> {
  final Duration duration;
  final String? debugLabel;
  final double lowerBound;
  final double upperBound;
  final TickerProvider vsync;
  final double? value;
  final AnimationBehavior animationBehavior;

  late final AnimationController controller;

  _AnimationControllerHook({
    required this.duration,
    this.debugLabel,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    required this.vsync,
    this.value,
    this.animationBehavior = AnimationBehavior.normal,
  });

  @override
  void init() {
    controller = AnimationController(
      duration: duration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: vsync,
      value: value,
      animationBehavior: animationBehavior,
    );
  }

  @override
  void dispose() {
    controller.dispose();
  }
}
