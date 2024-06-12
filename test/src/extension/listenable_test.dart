import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

void main() {
  testWidgets('useListenable updates the widget when the Listenable changes',
      (WidgetTester tester) async {
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

  testWidgets(
      'useValueNotifier updates the widget when the ValueNotifier changes',
      (WidgetTester tester) async {
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

  testWidgets('useCallback is called when the Listenable changes',
      (WidgetTester tester) async {
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

  testWidgets('useNotifier updates the widget when the ValueNotifier changes',
      (WidgetTester tester) async {
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

  testWidgets('useNotifier in Stateless', (tester) async {
    final notifier = ValueNotifier<int>(0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestStatelessWidget(
            notifier: notifier,
          ),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    notifier.value = 1;
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    notifier.value = 2;
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    notifier.value = 3;
    await tester.pump();
    expect(find.text('3'), findsOneWidget);
  });
}

class TestStatelessWidget extends Widget with HookMixin {
  final ValueNotifier<int> notifier;

  TestStatelessWidget({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final value = useValueNotifier(notifier);
    return Text('$value');
  }
}

class TestListenableWidget extends StatefulWidget {
  const TestListenableWidget({super.key});

  @override
  State<TestListenableWidget> createState() => _TestListenableWidgetState();
}

class _TestListenableWidgetState extends State<TestListenableWidget>
    with HookStateMixin<TestListenableWidget> {
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
  State<TestValueNotifierWidget> createState() =>
      _TestValueNotifierWidgetState();
}

class _TestValueNotifierWidgetState extends State<TestValueNotifierWidget>
    with HookStateMixin<TestValueNotifierWidget> {
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

class _TestCallbackWidgetState extends State<TestCallbackWidget>
    with HookStateMixin<TestCallbackWidget> {
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

class _TestNotifierWidgetState extends State<TestNotifierWidget>
    with HookStateMixin {
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
