import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

class TestStreamWidget extends StatefulWidget {
  const TestStreamWidget({super.key});

  @override
  State<TestStreamWidget> createState() => _TestStreamWidgetState();
}

class _TestStreamWidgetState extends State<TestStreamWidget> with HookState<TestStreamWidget> {
  final stream = Stream<int>.periodic(
    const Duration(seconds: 1),
    (count) => count + 1,
  ).take(3);

  @override
  Widget build(BuildContext context) {
    final streamValue = useStream(stream, 0);

    return Text('$streamValue');
  }
}

class TestStreamCallbackWidget extends StatefulWidget {
  const TestStreamCallbackWidget({super.key});

  @override
  State<TestStreamCallbackWidget> createState() => _TestStreamCallbackWidgetState();
}

class _TestStreamCallbackWidgetState extends State<TestStreamCallbackWidget> with HookState<TestStreamCallbackWidget> {
  int callbackCount = 0;
  final stream = Stream<int>.periodic(
    const Duration(seconds: 1),
    (count) => count + 1,
  ).take(3);

  @override
  Widget build(BuildContext context) {
    useStreamCallback(stream, (value) {
      setState(() {
        callbackCount = value;
      });
    });

    return Text('$callbackCount');
  }
}

void main() {
  testWidgets('useStream updates the widget when the Stream emits new values', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestStreamWidget(),
        ),
      ),
    );

    // Verify the initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    // Advance time by 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.text('2'), findsNothing);

    // Advance time by 1 more second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('useStreamCallback executes the callback when the Stream emits new values', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestStreamCallbackWidget(),
        ),
      ),
    );

    // Verify the initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);

    // Advance time by 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.text('2'), findsNothing);

    // Advance time by 1 more second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsNothing);
  });
}
