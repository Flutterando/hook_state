import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

final counter = ValueNotifier(0);
final counter2 = ValueNotifier(0);

final controller = StreamController<int>.broadcast();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HookState {
  @override
  Widget build(BuildContext context) {
    final state = useNotifier(0);
    final state2 = useValueNotifier(counter);
    final state3 = useStream(controller.stream, 0);
    useCallback([counter2], () {
      print('Only callback ${counter.value}');
      final snackbar = SnackBar(content: Text('Counter: ${counter.value}'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                state.value++;
              },
              child: Text('useNotifier ${state.value}'),
            ),
            ElevatedButton(
              onPressed: () {
                counter.value++;
              },
              child: Text('useValueNotifier - $state2'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.add(state3 + 1);
              },
              child: Text('useStream - $state3'),
            ),
            ElevatedButton(
              onPressed: () {
                counter2.value++;
              },
              child: const Text('Callback'),
            ),
          ],
        ),
      ),
    );
  }
}
