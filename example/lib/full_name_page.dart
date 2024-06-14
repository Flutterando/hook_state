import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';
import 'package:value_selectable/value_selectable.dart';

final nameState = ValueNotifier('');
final lastNameState = ValueNotifier('');

final fullNameSelector = ValueSelector<String>(
  (get) {
    final name = get(nameState);
    final lastName = get(lastNameState);

    return '$name $lastName';
  },
);

class FullNamePage extends StatefulWidget {
  const FullNamePage({super.key});

  @override
  State<FullNamePage> createState() => _FullNamePageState();
}

class _FullNamePageState extends State<FullNamePage> with HookStateMixin {
  @override
  Widget build(BuildContext context) {
    final fullName = useValueListenable(fullNameSelector);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Name Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              initialValue: nameState.value,
              onChanged: (value) {
                nameState.value = value;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              initialValue: lastNameState.value,
              onChanged: (value) {
                lastNameState.value = value;
              },
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 30),
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
