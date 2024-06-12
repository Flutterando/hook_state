import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

class TestListenableWidget extends StatefulWidget {
  const TestListenableWidget({super.key});

  @override
  State<TestListenableWidget> createState() => _TestListenableWidgetState();
}

class _TestListenableWidgetState extends State<TestListenableWidget> with HookState<TestListenableWidget> {
  final notifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    useListenable(notifier);

    return GestureDetector(
      onTap: () {
        notifier.value += 1;
      },
      child: Text('${notifier.value}'),
    );
  }
}

class TestValueNotifierWidget extends StatefulWidget {
  const TestValueNotifierWidget({super.key});

  @override
  State<TestValueNotifierWidget> createState() => _TestValueNotifierWidgetState();
}

class _TestValueNotifierWidgetState extends State<TestValueNotifierWidget> with HookState<TestValueNotifierWidget> {
  final notifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final value = useValueNotifier(notifier);

    return GestureDetector(
      onTap: () {
        notifier.value += 1;
      },
      child: Text('$value'),
    );
  }
}

class TestCallbackWidget extends StatefulWidget {
  const TestCallbackWidget({super.key});

  @override
  State<TestCallbackWidget> createState() => _TestCallbackWidgetState();
}

class _TestCallbackWidgetState extends State<TestCallbackWidget> with HookState<TestCallbackWidget> {
  int callbackCount = 0;
  final notifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    useCallback([notifier], () {
      setState(() {
        callbackCount++;
      });
    });

    return GestureDetector(
      onTap: () {
        notifier.value += 1;
      },
      child: Text('$callbackCount'),
    );
  }
}

class TestNotifierWidget extends StatefulWidget {
  const TestNotifierWidget({super.key});

  @override
  State<TestNotifierWidget> createState() => _TestNotifierWidgetState();
}

class _TestNotifierWidgetState extends State<TestNotifierWidget> with HookState<TestNotifierWidget> {
  @override
  Widget build(BuildContext context) {
    final notifier = useNotifier<int>(0);

    return GestureDetector(
      onTap: () {
        notifier.value += 1;
      },
      child: Text('${notifier.value}'),
    );
  }
}

void main() {
  testWidgets('useListenable updates the widget when the Listenable changes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestListenableWidget(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useValueNotifier updates the widget when the ValueNotifier changes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestValueNotifierWidget(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useCallback is called when the Listenable changes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestCallbackWidget(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('useNotifier updates the widget when the ValueNotifier changes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestNotifierWidget(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
