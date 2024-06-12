import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hook_state/hook_state.dart';

class TestTextEditingControllerWidget extends StatefulWidget {
  const TestTextEditingControllerWidget({super.key});

  @override
  State<TestTextEditingControllerWidget> createState() =>
      _TestTextEditingControllerWidgetState();
}

class _TestTextEditingControllerWidgetState
    extends State<TestTextEditingControllerWidget>
    with HookStateMixin<TestTextEditingControllerWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(initialText: "Initial");

    return TextField(controller: controller);
  }
}

class TestFocusNodeWidget extends StatefulWidget {
  const TestFocusNodeWidget({super.key});

  @override
  State<TestFocusNodeWidget> createState() => _TestFocusNodeWidgetState();
}

class _TestFocusNodeWidgetState extends State<TestFocusNodeWidget>
    with HookStateMixin<TestFocusNodeWidget> {
  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();

    return TextField(focusNode: focusNode);
  }
}

class TestTabControllerWidget extends StatefulWidget {
  const TestTabControllerWidget({super.key});

  @override
  State<TestTabControllerWidget> createState() =>
      _TestTabControllerWidgetState();
}

class _TestTabControllerWidgetState extends State<TestTabControllerWidget>
    with
        HookStateMixin<TestTabControllerWidget>,
        SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(length: 2, vsync: this);

    return TabBarView(controller: tabController, children: const [
      Text('Tab 1'),
      Text('Tab 2'),
    ]);
  }
}

class TestScrollControllerWidget extends StatefulWidget {
  const TestScrollControllerWidget({super.key});

  @override
  State<TestScrollControllerWidget> createState() =>
      _TestScrollControllerWidgetState();
}

class _TestScrollControllerWidgetState extends State<TestScrollControllerWidget>
    with HookStateMixin<TestScrollControllerWidget> {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return ListView(
      controller: scrollController,
      children: List.generate(20, (index) => Text('Item $index')),
    );
  }
}

class TestPageControllerWidget extends StatefulWidget {
  const TestPageControllerWidget({super.key});

  @override
  State<TestPageControllerWidget> createState() =>
      _TestPageControllerWidgetState();
}

class _TestPageControllerWidgetState extends State<TestPageControllerWidget>
    with HookStateMixin<TestPageControllerWidget> {
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return PageView(
      controller: pageController,
      children: const [
        Text('Page 1'),
        Text('Page 2'),
      ],
    );
  }
}

void main() {
  testWidgets(
      'useTextEditingController creates and manages TextEditingController',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestTextEditingControllerWidget(),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller!.text, 'Initial');
  });

  testWidgets('useFocusNode creates and manages FocusNode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestFocusNodeWidget(),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.focusNode, isNotNull);
  });

  testWidgets('useTabController creates and manages TabController',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestTabControllerWidget(),
        ),
      ),
    );

    expect(find.byType(TabBarView), findsOneWidget);
    final tabBarView = tester.widget<TabBarView>(find.byType(TabBarView));
    expect(tabBarView.controller, isNotNull);
    expect(tabBarView.controller!.length, 2);
  });

  testWidgets('useScrollController creates and manages ScrollController',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestScrollControllerWidget(),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView.controller, isNotNull);
  });

  testWidgets('usePageController creates and manages PageController',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestPageControllerWidget(),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller, isNotNull);
  });
}
