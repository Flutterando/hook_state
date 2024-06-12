
# Hook State

[![Pub Version](https://img.shields.io/pub/v/hook_state.svg)](https://pub.dev/packages/hook_state)

`hook_state` is a Flutter package inspired by React hooks and the `flutter_hooks` package. It offers a similar hooks experience but without the need for additional widgets, allowing you to use just `StatefulWidget` to manage complex states declaratively and reactively.

## Motivation

The motivation behind this package is to provide a simpler and more intuitive development experience for managing state in Flutter. Unlike other packages that require the use of custom widgets, `hook_state` allows you to use just `StatefulWidget`, making the code cleaner and easier to maintain. This package is ideal to be used alongside widgets like `ListenableBuilder` and `StreamBuilder`.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  hook_state: ^1.0.0
```

Then, install the packages with the command:

```sh
flutter pub get
```

## Usage

### Basic Example

Here is a basic example of how to use `hook_state` to manage a counter:

```dart
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> with HookState<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    final counter = useNotifier<int>(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hook Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pressed the button this many times:'),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value += 1;
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Available Hooks

| Hook                      | Description                                                    |
|---------------------------|----------------------------------------------------------------|
| `useNotifier`             | Manages a `ValueNotifier` and returns its value                |
| `useStream`               | Listens to a `Stream` and returns the latest emitted value     |
| `useTextEditingController`| Manages a `TextEditingController`                              |
| `useFocusNode`            | Manages a `FocusNode`                                          |
| `useTabController`        | Manages a `TabController`                                      |
| `useScrollController`     | Manages a `ScrollController`                                   |
| `usePageController`       | Manages a `PageController`                                     |
| `useAnimationController`  | Manages an `AnimationController`                               |
| `useStreamCallback`       | Listens to a `Stream` and executes a callback on new values    |

### Example Usage of All Hooks

Here is an example showing how to use each of the available hooks:

```dart
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

class ExampleAllHooksWidget extends StatefulWidget {
  @override
  _ExampleAllHooksWidgetState createState() => _ExampleAllHooksWidgetState();
}

class _ExampleAllHooksWidgetState extends State<ExampleAllHooksWidget> with HookState<ExampleAllHooksWidget>, SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final counter = useNotifier<int>(0);
    final streamValue = useStream<int>(Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(10), 0);
    final textController = useTextEditingController(initialText: "Hello");
    final focusNode = useFocusNode();
    final tabController = useTabController(length: 2, vsync: this);
    final scrollController = useScrollController();
    final pageController = usePageController();
    final animationController = useAnimationController(duration: Duration(seconds: 1));

    useStreamCallback<int>(Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(10), (value) {
      print('Stream value: $value');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('All Hooks Example'),
        bottom: TabBar(
          controller: tabController,
          tabs: [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Column(
            children: [
              TextField(controller: textController, focusNode: focusNode),
              Text('Counter: ${counter.value}'),
              Text('Stream Value: $streamValue'),
              ElevatedButton(
                onPressed: () {
                  counter.value += 1;
                },
                child: Text('Increment Counter'),
              ),
              Container(
                height: 100,
                color: Colors.blue,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
                ),
              ),
              Container(
                height: 100,
                color: Colors.red,
                child: PageView(
                  controller: pageController,
                  children: [Text('Page 1'), Text('Page 2')],
                ),
              ),
              GestureDetector(
                onTap: () {
                  animationController.forward();
                },
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Container(
                      width: animationController.value * 100,
                      height: animationController.value * 100,
                      color: Colors.green,
                    );
                  },
                ),
              ),
            ],
          ),
          Center(child: Text('Tab 2 Content')),
        ],
      ),
    );
  }
}
```

## Creating Custom Hooks

You can create custom hooks by extending `Hook` and using extensions. Here’s an example:

### Custom Hook for `GlobalKey`

#### Implementing the Custom Hook

```dart
// src/extension/custom_hooks.dart

import 'package:flutter/material.dart';
import '../hook.dart';
import '../hook_state.dart';

extension CustomHookStateExtension on HookState {
  /// Registers a GlobalKeyHook to manage a GlobalKey.
  /// Returns the created GlobalKey.
  GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() {
    final hook = GlobalKeyHook<T>();
    return use(hook).key;
  }
}

class GlobalKeyHook<T extends State<StatefulWidget>> extends Hook<GlobalKey<T>> {
  late final GlobalKey<T> key;

  GlobalKeyHook();

  @override
  void init() {
    key = GlobalKey<T>();
  }

  @override
  void dispose() {
    // GlobalKey does not need to be disposed.
  }
}
```

#### Using the Custom Hook

```dart
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

class ExampleCustomHookWidget extends StatefulWidget {
  @override
  _ExampleCustomHookWidgetState createState() => _ExampleCustomHookWidgetState();
}

class _ExampleCustomHookWidgetState extends State<ExampleCustomHookWidget> with HookState<ExampleCustomHookWidget> {
  @override
  Widget build(BuildContext context) {
    final key = useGlobalKey<_CustomWidgetState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Hook Example'),
      ),
      body: Center(
        child: CustomWidget(key: key),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          key.currentState?.doSomething();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

class CustomWidget extends StatefulWidget {
  CustomWidget({Key? key}) : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  void doSomething() {
    print('Doing something!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Custom Widget'),
    );
  }
}
```

## Running Tests

Ensure that the tests cover all use cases:

```sh
flutter test
```

## Contribution

Contributions are welcome! Feel free to open issues and pull requests on the GitHub repository.

## License

This project is licensed under the MIT License. See the LICENSE file for more information.

---

This package was inspired by React hooks and the `flutter_hooks` package but aims to simplify the development experience in Flutter by eliminating the need for additional custom widgets.
