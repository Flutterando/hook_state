
# Hook State

[![Pub Version](https://img.shields.io/pub/v/hook_state.svg)](https://pub.dev/packages/hook_state)

`hook_state` is a Flutter package inspired by React hooks and the `flutter_hooks` package. It offers a similar hooks experience but without the need for additional widgets, allowing you to use just `StatefulWidget` to manage complex states declaratively and reactively.

## Motivation

The motivation behind this package is to provide a simpler and more intuitive development experience for managing state in Flutter. Unlike other packages that require the use of custom widgets, `hook_state` allows you to use just `StatefulWidget`, making the code cleaner and easier to maintain. This package is ideal to be used alongside widgets like `ListenableBuilder` and `StreamBuilder`.

## Installation

Add the dependency to your `pubspec.yaml`:

```
flutter pub add hook_state
```

## Usage

### Basic Example

Here is a basic example of how to use `hook_state` to manage a counter.

First, create a new `StatefulWidget`. Then, use a `HookStateMixin` as a mixin in the State.
After that, you can use the hook methods.

```dart
class _ExampleWidgetState extends State<ExampleWidget> with HookStateMixin {
```

You can also use the `HookMixin` directly in the `Widget` class, replacing the `StatelessWidget`.

```dart
class ExampleWidget extends StatelessWidget with HookMixin {

  Widget build(BuildContext context) {
    final counter = useNotifier<int>(0);
    return Text('$value');
  }
}
```

Now you can use a hooks methods in the `build` method.
This example uses the `useNotifier` hook to manage a `ValueNotifier` and return its value.

```dart
@override
  Widget build(BuildContext context) {
    final counter = useNotifier<int>(0);
    ...
```
See the full example below:

```dart
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> with HookStateMixin {
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

| Hook                       | Description                                                |
|----------------------------|------------------------------------------------------------|
| `useValueNotifier`         | Create a `ValueNotifier` and returns its value             |
| `useListenable`            | Listen a `Listenable` like `ChangeNotifier`                |
| `useListenableChanged`     | Listen a `Listenable` and execute a callback               |
| `useValueListenable`       | Listen a `ValueNotifier` and returns its value             |
| `useStream`                | Listens to a `Stream` and returns the latest emitted value |
| `useStreamChanged`         | Listen a `Listenable` and execute a callback               |
| `useStreamController`      | Create a `StreamController`                                |
| `useTextEditingController` | Manages a `TextEditingController`                          |
| `useFocusNode`             | Manages a `FocusNode`                                      |
| `useTabController`         | Manages a `TabController`                                  |
| `useScrollController`      | Manages a `ScrollController`                               |
| `usePageController`        | Manages a `PageController`                                 |
| `useAnimationController`   | Manages an `AnimationController`                           |

## Creating Custom Hooks

You can create custom hooks by extending `Hook` and using extensions. Here’s an example:

### Custom Hook for `GlobalKey`

#### Implementing the Custom Hook

```dart
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

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

class _ExampleCustomHookWidgetState extends State<ExampleCustomHookWidget> with HookStateMixin {
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


## Contribution

Contributions are welcome! Feel free to open issues and pull requests on the GitHub repository.

## License

This project is licensed under the MIT License. See the LICENSE file for more information.

