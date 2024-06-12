import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

class TestAnimationControllerWidget extends StatefulWidget {
  const TestAnimationControllerWidget({super.key});

  @override
  State<TestAnimationControllerWidget> createState() => _TestAnimationControllerWidgetState();
}

class _TestAnimationControllerWidgetState extends State<TestAnimationControllerWidget> with HookState<TestAnimationControllerWidget>, SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    return GestureDetector(
      onTap: () {
        controller.forward();
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: controller.value * 100,
            height: controller.value * 100,
            color: Colors.blue,
          );
        },
      ),
    );
  }
}

void main() {
  testWidgets('useAnimationController creates and disposes the AnimationController correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestAnimationControllerWidget(),
        ),
      ),
    );

    // Verify initial state
    final containerFinder = find.byType(Container);
    Container container = tester.firstWidget(containerFinder);
    expect(container.constraints?.maxWidth, 0.0);
    expect(container.constraints?.maxHeight, 0.0);

    // Tap to start the animation
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // Verify animation started
    await tester.pump(const Duration(milliseconds: 500));
    container = tester.firstWidget(containerFinder);
    expect(container.constraints?.maxWidth, greaterThan(0.0));
    expect(container.constraints?.maxHeight, greaterThan(0.0));

    // Verify animation completes
    await tester.pumpAndSettle();
    container = tester.firstWidget(containerFinder);
    expect(container.constraints?.maxWidth, 100.0);
    expect(container.constraints?.maxHeight, 100.0);
  });
}
